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
                annotationView = setUpStoreAnnotationView(for: annotation, on: mapView) ?? MKAnnotationView(annotation: annotation, reuseIdentifier: "customView")
            }
        
        return annotationView
    }
 
    // 마커를 클릭 했을 때 동작하는 함수
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? StoreAnnotation else { return }
        mapViewController.selectedStoreAnnotation = annotation
        mapViewController.isSelected = true
    }
    
    
    func setUpStoreAnnotationView(for annotation: StoreAnnotation, on mapView: MKMapView) -> MKAnnotationView? {
        let identifier = "customView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            let markerImage = UIImage()
                .getMarkerImage(foodType: annotation.foodType)?
                .resizeImageTo(size: CGSize(width: 60, height: 60))
            annotationView?.image =  markerImage
            
        } else {
            annotationView?.annotation = annotation
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

