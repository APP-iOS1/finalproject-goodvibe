//
//  NaverMapView.swift
//  GukbapMinister
//
//  Created by Martin on 2023/01/16.
//

import UIKit
import SwiftUI

import NMapsMap
import NMapsGeometry


struct NaverMapView: UIViewRepresentable {
    //받아오는 위도,경도 좌표값
    var coordination: (Double, Double)
    
    // 마커를 클릭했을 때 상위뷰로 전달되는 Bool값
    @Binding var marked : Bool

    
    @Binding var marked2 : Bool

    
    //UI를 그리는 함수
    func makeUIView(context: Context) -> NMFNaverMapView {

        let view = NMFNaverMapView()
        view.showZoomControls = false
        view.mapView.positionMode = .direction
        view.mapView.zoomLevel = 14
        view.showLocationButton = true

        let marker = NMFMarker()
        marker.position = NMGLatLng(lat: 37.503693, lng: 127.053033)
        
        //아이콘 이미지 및 사이즈 변경
//        marker.width = 5.0
//        let iconImage = NMFOverlayImage(image: UIImage(systemName: "person") ?? UIImage())
//        marker.iconImage = iconImage

        marker.mapView = view.mapView
        
        // 마커를 클릭했을 때 발동되는 메서드
        marker.touchHandler = { (overlay: NMFOverlay) -> Bool in
            marked.toggle()
            return true
            // 이벤트 소비, -mapView:didTapMap:point 이벤트는 발생하지 않음
        }
        
        
        let marker2 = NMFMarker()
        marker2.position = NMGLatLng(lat: 37.506276, lng: 127.048977)
        marker2.mapView = view.mapView
        marker2.touchHandler = { (overlay: NMFOverlay) -> Bool in
            marked2.toggle()
            return true
            // 이벤트 소비, -mapView:didTapMap:point 이벤트는 발생하지 않음
        }
        
        return view
    }
    
    //UI를 업데이트하는 함수
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {
            let coord = NMGLatLng(lat: coordination.0, lng: coordination.1)
            let cameraUpdate = NMFCameraUpdate(scrollTo: coord)
        
            // 카메라가 이동할 때 애니메이션
            cameraUpdate.animation = .fly
            // 카메라가 이동할 때 애니메이션 지속시간
            cameraUpdate.animationDuration = 1
            // 카메라 이동시켜주는 함수
            uiView.mapView.moveCamera(cameraUpdate)
        
    }
}

