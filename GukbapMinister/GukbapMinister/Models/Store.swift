//
//  Store.swift
//  GukbapMinister
//
//  Created by Martin on 2023/01/16.
//

import Foundation
import SwiftUI
import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift


struct Store: Codable, Hashable, Identifiable {
    
    @DocumentID var id: String?
    var storeName: String
    var storeAddress: String
    var coordinate: GeoPoint
    var storeImages: [String]
    var menu: [String : String]
    var description: String
    var countingStar: Double
    var foodType: [String] //국밥 타입: ex:순대,돼지국밥
    //    var viewCount: Int// 장소 조회수
    
    static func == (lhs : Store, rhs: Store) -> Bool{
        lhs.id == rhs.id
    }
    
    
    
}

extension Store {
    static var test: Store = .init(storeName: "test", storeAddress: "test", coordinate: GeoPoint(latitude: 37, longitude: 125), storeImages: [], menu: [:], description: "test", countingStar: 0.5, foodType: ["순대국밥"])
}



