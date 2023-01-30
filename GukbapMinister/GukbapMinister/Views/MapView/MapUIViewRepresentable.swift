//
//  MapUIViewRepresentable.swift
//  GukbapMinister
//
//  Created by TEDDY on 1/30/23.
//

import SwiftUI
import UIKit
import MapKit




class MapViewCoordinator: NSObject, MKMapViewDelegate {
    var mapViewController: MapUIView
    
    init(_ control: MapUIView) {
        self.mapViewController = control
    }
    
    /**
     - Description - 특정 어노테이션 오브젝트와 연관된 뷰를 리턴
     */
    @MainActor
    func mapView(_ mapView: MKMapView,
                 viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Custom View for Annotation
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customView")
        annotationView.canShowCallout = true
       
        
        /**
         - Description - 스위프트 유아이 뷰를 ImageRenderer를 통해 이미지로 바꿔주는 부분
         */
        let renderer = ImageRenderer(content: LocationMapAnnotationView())
        
        // renderer.uiImage로 UIImage타입으로 사용할 수 있게 됨
        if let uiImage = renderer.uiImage {
            // use the rendered image somehow
            // Your custom image icon
            annotationView.image = uiImage
        }
        
        return annotationView
    }
}

struct MapUIView: UIViewRepresentable {
    // Model with test data
    let landmarks = LandmarkAnnotation.requestMockData()
    /**
     - Description - Replace the body with a make UIView(context:) method that creates and return an empty MKMapView
     */
    func makeUIView(context: Context) -> MKMapView{
        let maps = MKMapView(frame: .zero)
        // 맵의 초기 지역 MKMapRect로 설정
        maps.visibleMapRect = .seoul
        
        // 맵이 보이는 범위를 제한하기
//         maps.cameraBoundary = MKMapView.CameraBoundary(mapRect: .korea)
//         maps.cameraZoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: CLLocationDistance(500000))
//
        
        return maps
    }
    
    
    func updateUIView(_ view: MKMapView, context: Context) {
        // If you changing the Map Annotation then you have to remove old Annotations
        // mapView.removeAnnotations(mapView.annotations)
        // Assigning delegate
        view.delegate = context.coordinator
        // Passing model array here
        view.addAnnotations(landmarks)
    }
    
    func makeCoordinator() -> MapViewCoordinator{
        MapViewCoordinator(self)
    }
}

class LandmarkAnnotation: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String?,
         subtitle: String?,
         coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
    
    static func requestMockData() -> [LandmarkAnnotation] {
        return [LandmarkAnnotation(title: "테스트", subtitle: "테스트", coordinate: .init(latitude: 12.9716, longitude: 77.5946))]
    }
}


struct MapUIViewRepresentable_Previews: PreviewProvider {
    static var previews: some View {
        MapUIView()
    }
}

extension MKMapRect {
    static let seoul =
    MKMapRect(origin: .init(x: 228718441.06904224,
                            y: 103649825.48263545),
              size: .init(width: 362917.52856230736,
                          height: 655652.5325171798))
    
    static let korea =
    MKMapRect(origin: .init(x: 227328883.2,
                            y: 101698704.0),
              size: .init(width: 5548101.7,
                          height: 8032702.8))
}
