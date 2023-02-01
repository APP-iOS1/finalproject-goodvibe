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
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            mapViewController.region = mapView.region
    }
    
    /**
     - Description - 특정 어노테이션 오브젝트와 연관된 뷰를 리턴
     */
    @MainActor
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "customView"
        
        // 스위프트 유아이 뷰를 ImageRenderer를 통해 이미지로 바꿔주는 부분
        let renderer = ImageRenderer(content: LocationMapAnnotationView())
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
         
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)

            if let uiImage = renderer.uiImage {
                // use the rendered image somehow
                // Your custom image icon
                annotationView?.image = uiImage
            }
            
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
 
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? StoreAnnotation else { return }
        mapViewController.selectedStoreAnnotation = annotation
        mapViewController.isSelected = true
    }
    
    
}

// View라고 생각하면 됨
struct MapUIView: UIViewRepresentable {
    // Model with test data
    //    let landmarks = LandmarkAnnotation.requestMockData()
    
    @Binding var storeAnnotations: [StoreAnnotation]
    @Binding var region: MKCoordinateRegion
    @Binding var isSelected: Bool
    @Binding var selectedStoreAnnotation: StoreAnnotation
    
    
    /**
     - Description - Replace the body with a make UIView(context:) method that creates and return an empty MKMapView
     */
    func makeUIView(context: Context) -> MKMapView {
        let maps = MKMapView(frame: .zero)
        // 맵의 초기 지역 MKMapRect로 설정
        //    maps.visibleMapRect = .seoul
        maps.setRegion(region, animated: true)
        
        maps.showsCompass = true
        maps.showsUserLocation = true
        
        // 맵이 보이는 범위를 제한하기
        //         maps.cameraBoundary = MKMapView.CameraBoundary(mapRect: .korea)
        //         maps.cameraZoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: CLLocationDistance(500000))
        //
        
        return maps
    }
    
    
    func updateUIView(_ view: MKMapView, context: Context) {
        // If you changing the Map Annotation then you have to remove old Annotations
//        view.removeAnnotations(view.annotations)
        // Assigning delegate
        view.delegate = context.coordinator
        // Passing model array here
        view.addAnnotations(storeAnnotations)
        
    }
    
    func makeCoordinator() -> MapViewCoordinator{
        MapViewCoordinator(self)
    }
}

