//
//  MapUIViewRepresentable.swift
//  GukbapMinister
//
//  Created by TEDDY on 1/30/23.
//

import SwiftUI
import UIKit
import MapKit

// SwiftUI와 UIRepresentable 이 상호작용하도록 도와주는 것
class MapViewCoordinator: NSObject, MKMapViewDelegate {
    var mapViewController: MapUIView
    
    init(_ control: MapUIView) {
        self.mapViewController = control
    }
    
    
    /*
     - Description - 특정 어노테이션 오브젝트와 연관된 뷰를 리턴
     */
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
        mapViewController.selectedStoreAnnotation = .init(storeId: "", title: "", subtitle: "", foodType: "", coordinate: .init())
        mapViewController.isSelected = false
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
    }
    
    
    func setUpStoreAnnotationView(for annotation: StoreAnnotation, on mapView: MKMapView) -> MKAnnotationView? {
        let identifier = annotation.storeId
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            
            let markerImage = Gukbaps(rawValue: annotation.foodType)?
                .uiImage?
                .resizeImageTo(size: CGSize(width: 60, height: 60))
            
            annotationView?.image =  markerImage
            
            //텍스트 추가 시도
            /*
             let uiText = UITextView(frame: CGRect())
             uiText.text = annotation.title
             uiText.textColor = .black
             uiText.textAlignment = .center
             uiText.layer.cornerRadius = 10
             
             annotationView?.addSubview(uiText)
             */
            
        }
        
        
        return annotationView
    }
    
}

// View라고 생각하면 됨
struct MapUIView: UIViewRepresentable {
    // Model with test data
    //    let landmarks = LandmarkAnnotation.requestMockData()
    @Binding var region: MKCoordinateRegion
    @Binding var storeAnnotations: [StoreAnnotation]
    @Binding var selectedStoreAnnotation: StoreAnnotation
    @Binding var isSelected: Bool
    
    
    
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
      trackingButton.layer.cornerRadius = 22.5
        
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
        // If you changing the Map Annotation then you have to remove old Annotations
        //        view.removeAnnotations(view.annotations)
        // Passing model array here
        view.addAnnotations(storeAnnotations)
        
        
    }
    
    func makeCoordinator() -> MapViewCoordinator{
        MapViewCoordinator(self)
    }
}

