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
import MapKit

struct Store : Identifiable, Equatable{
    var id: String
    var storeName: String
    var storeAddress: String
    var coordinate: CLLocationCoordinate2D
    var storeImages: [String]
    var menu: [[String]]
    var description: String
    var countingStar: Double
    
    // Equatable
    static func == (lhs : Store, rhs: Store) -> Bool{
        lhs.id == rhs.id
    }
}



//struct StoreLocation: Identifiable {
//  let id = UUID()
//  let name: String
//  let coordinate: CLLocationCoordinate2D
//}
