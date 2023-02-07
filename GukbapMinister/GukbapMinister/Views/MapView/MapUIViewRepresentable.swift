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
        mapViewController.selectedStoreAnnotation = annotation
        mapViewController.isSelected = true
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
        
        // 멥에서 기본적으로 제공하는 요소들의 위치를 조절하기 위한 설정
        maps.layoutMargins = UIEdgeInsets(top: 140, left: 0, bottom: 36, right: 9)
        
        // 유저의 위치를 볼 수있게 설정
        maps.showsUserLocation = true
        
        // 나침반이 보이게 설정
        maps.showsCompass = true
        
        let trackingButton = MKUserTrackingButton(mapView: maps)
        trackingButton.layer.backgroundColor = UIColor(white: 1, alpha: 0.8).cgColor
        trackingButton.layer.borderColor = UIColor.white.cgColor
        trackingButton.layer.borderWidth = 1
        trackingButton.layer.cornerRadius = 5
        trackingButton.center = CGPoint(x: 120, y: 200)
        
        
        
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

