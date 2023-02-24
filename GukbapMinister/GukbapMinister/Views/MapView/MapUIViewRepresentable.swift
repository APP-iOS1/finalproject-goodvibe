//
//  MapUIViewRepresentable.swift
//  GukbapMinister
//
//  Created by TEDDY on 1/30/23.
//

import SwiftUI
import UIKit
import MapKit

// SwiftUI와 UIRepresentable 이 상호작용 하도록 도와주는 것
class MapViewCoordinator: NSObject, MKMapViewDelegate {
  var mapViewController: MapUIView
  
  init(_ control: MapUIView) {
    self.mapViewController = control
  }
  
  // Description - 특정 어노테이션 오브젝트와 연관된 뷰를 리턴
  @MainActor
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard !annotation.isKind(of: MKUserLocation.self) else {
      // Make a fast exit if the annotation is the `MKUserLocation`, as it's not an annotation view we wish to customize.
      return nil
    }
    var annotationView: MKAnnotationView?
    
    if let annotation = annotation as? StoreAnnotation {
      annotationView = setUpStoreAnnotationView(for: annotation, on: mapView)
    }
    
    return annotationView
  }
  
  // 마커를 클릭 했을 때 동작하는 함수
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    guard let annotation = view.annotation as? StoreAnnotation else { return }
    print(#function, "마커 clicked")
    mapViewController.selectedStoreAnnotation = annotation
    mapViewController.isSelected = true
  }
  
  // 마커를 클릭해제 했을 때 동작하는 함수
  func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
    guard let _ = view.annotation as? StoreAnnotation else { return }
    print(#function, "마커 deselect")
    mapViewController.selectedStoreAnnotation = .init(storeId: "", title: "", subtitle: "", foodType: [], coordinate: .init())
    mapViewController.isSelected = false
  }
  
  func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
    print(#function, "\(views)")
  }
  
  func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
    
  }
  
  func setUpStoreAnnotationView(for annotation: StoreAnnotation, on mapView: MKMapView) -> MKAnnotationView? {
    let identifier = annotation.storeId
    var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
    
    if annotationView == nil {
      annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
      
      let markerImage = Gukbaps(rawValue: annotation.foodType.first ?? "순대국밥")?
        .uiImage?
        .resizeImageTo(size: CGSize(width: 60, height: 60))
      
      let text = UITextView(frame: CGRect(x: 0, y: 60, width: 90, height: 30))
      text.backgroundColor = .clear
      text.text = ("이석준가와이")
      
      annotationView?.image = markerImage
      annotationView?.addSubview(text)
    }
    return annotationView
  }
  
}

// View라고 생각하면 됨
struct MapUIView: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    @Binding var storeAnnotations: [StoreAnnotation]
    @Binding var selectedStoreAnnotation: StoreAnnotation
    @Binding var isSelected: Bool
    @Binding var filters: [Gukbaps]
    
    /*
     - Description - Replace the body with a make UIView(context:) method that creates and return an empty MKMapView
     */
  
    func makeUIView(context: Context) -> MKMapView {
        let maps = MKMapView(frame: UIScreen.main.bounds)
        
        // 맵이 처음 보이는 지역을 서울로 설정
        maps.visibleMapRect = .seoul
        
        // 유저의 위치를 볼 수있게 설정
        maps.showsUserLocation = true
        
        // 나침반이 보이게 설정
        maps.showsCompass = false
        
        let compassButton = MKCompassButton(mapView: maps)
        compassButton.frame.size = CGSize(width: 48, height: 48)
        compassButton.frame.origin = CGPoint(x: maps.frame.width - compassButton.frame.width - 14, y: maps.frame.height * 0.24 )
        compassButton.compassVisibility = .adaptive
        maps.addSubview(compassButton)
        
      let trackingButton = MKUserTrackingButton(mapView: maps)
      trackingButton.layer.backgroundColor = UIColor(white: 5, alpha: 0.8).cgColor
      trackingButton.frame.size = CGSize(width: 42, height: 42)
      trackingButton.frame.origin = CGPoint(x: maps.frame.width - trackingButton.frame.width - 17, y: maps.frame.height * 0.55)
      trackingButton.layer.cornerRadius = 7
      // trackingButton.layer.cornerRadius = 22.5

        maps.addSubview(trackingButton)
        
        // 맵이 보이는 범위를 한국으로 제한하기
        maps.cameraBoundary = MKMapView.CameraBoundary(mapRect: .korea)
        
        // 맵으로 줌아웃 했을 때 최대 고도 설정
        maps.cameraZoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: CLLocationDistance(500000))
        
        return maps
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        // Assigning delegate
        view.delegate = context.coordinator
        
        // 필터가 변함에 따라 뷰에서 제거 해야 할 Annotation이 변동되기 때문
        view.removeAnnotations(getRemovingAnnotations(filters, storeAnnotations: storeAnnotations))
        // 필터가 변함에 따라 뷰에 추가 해야 할 Annotation이 변동되기 때문
        view.addAnnotations(getAddingAnnotations(filters, storeAnnotations: storeAnnotations))
    }
    
    func makeCoordinator() -> MapViewCoordinator{
        MapViewCoordinator(self)
    }
    
    func getRemovingAnnotations(_ filters: [Gukbaps], storeAnnotations: [StoreAnnotation]) -> [StoreAnnotation] {
        var removingAnnotations: [StoreAnnotation] = []
        if filters.isEmpty {
            return removingAnnotations
        } else {
            let filterSet = Set(filters.map { $0.rawValue })
            for store in storeAnnotations {
                let foodTypeSet = Set(store.foodType)
                
                if foodTypeSet.intersection(filterSet).isEmpty {
                    removingAnnotations.append(store)
                }
            }
            return removingAnnotations
        }
    }
    
    func getAddingAnnotations(_ filters: [Gukbaps], storeAnnotations: [StoreAnnotation]) -> [StoreAnnotation] {
        var addingAnnotations: [StoreAnnotation] = []
        
        if filters.isEmpty {
            return storeAnnotations
        } else {
            let filterSet = Set(filters.map { $0.rawValue })
            for store in storeAnnotations {
                let foodTypeSet = Set(store.foodType)
                
                if foodTypeSet.intersection(filterSet).count > 0 {
                    addingAnnotations.append(store)
                }
            }
            return addingAnnotations
        }
    }
}
