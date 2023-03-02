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

class MapViewModel : ObservableObject {
    // All loaded locations
    @Published var storeLocations : [Store] = [] {
        willSet(newValue) {
            setStoreLocationAnnotations(newValue)
        }
    }
    @Published var storeLocationAnnotations: [StoreAnnotation] = []
    // 마커 클릭시 선택된 특정 Store
    @Published var selectedStore: Store? = nil
    @Published var selectedStoreAnnotation : StoreAnnotation = .init(storeId: "Did you know?", title: "Seokjun", subtitle: "is", foodType: ["순대국밥"], coordinate: .init(latitude: 37.506276, longitude: 127.048977)) {
        willSet(newVal) {
            selectedStore = storeLocations.first { store in
                store.id == newVal.storeId
            }
        }
    }
    // 국밥카테고리
    @Published var filteredGukbaps: [Gukbaps] = []
    
    
    init(storeLocations: [Store]) {
        self.storeLocations = storeLocations
    }
    
    
    func setStoreLocationAnnotations(_ storeLocations: [Store]) {
        self.storeLocationAnnotations = storeLocations.map { store in
            StoreAnnotation(  storeId: store.id ?? "Not Found",
                              title: store.storeName,
                              subtitle: store.storeAddress,
                              foodType: store.foodType,
                              coordinate: .init(latitude: store.coordinate.latitude, longitude: store.coordinate.longitude)
            )
        }
    }
}
