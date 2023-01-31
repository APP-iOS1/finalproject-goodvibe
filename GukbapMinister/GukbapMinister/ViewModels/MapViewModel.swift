//
//  MapViewModel.swift
//  GukbapMinister
//
//  Created by 기태욱 on 2023/01/20.
//

import Foundation
import CoreLocation
import MapKit
import SwiftUI
import FirebaseFirestore
//extension CLLocationCoordinate2D: Identifiable {
//  public var id: String {
//    "\(latitude)-\(longitude)"
//  }
//}

class StoreDummyData {
    static let location : [Store] = [
        Store(id: "111", storeName: "농민백암순대", storeAddress: "서울특별시 강남구 역삼로 3길 20-4", coordinate: GeoPoint(latitude: 37.503693, longitude: 127.053033), storeImages: ["https://d12zq4w4guyljn.cloudfront.net/20201217093530967_photo_4cfe72970c06.jpg"], menu: ["":""], description: "", countingStar: 0.0),
        Store(id: "222", storeName: "우가네", storeAddress: "서울 강남구 선릉로96길 7 1층", coordinate: GeoPoint(latitude: 37.506276, longitude: 127.048977), storeImages: ["https://img1.kakaocdn.net/cthumb/local/R0x420/?fname=http%3A%2F%2Ft1.daumcdn.net%2Flocal%2FkakaomapPhoto%2Freview%2F3c7f504de60ea04fdff919b38722b977e15f59e8%3Foriginal"], menu: ["":""], description: "", countingStar: 0.0)
    ]
}



class MapViewModel : ObservableObject {
    
    // All loaded locations
    @Published var storeLocations : [Store]
    
    @Published var storeLocationAnnotations: [StoreAnnotation]
    
    // 마커 클릭시 선택된 특정 Store
    var selectedStore : Store? = nil
    
    // MKCoordinateSpan은 우리가 지정해주고자 하는 지역 범위의 폭과 너비를 정해줄 수 있는 struct
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    
    
    init(storeLocations: [Store] = StoreDummyData.location) {
        self.storeLocations = storeLocations
        self.storeLocationAnnotations = storeLocations.map { store in
            StoreAnnotation(title: store.storeName,
                            subtitle: store.storeAddress,
                            coordinate: .init(latitude: store.coordinate.latitude, longitude: store.coordinate.longitude))
        }
        
    }
    
    
    
}
