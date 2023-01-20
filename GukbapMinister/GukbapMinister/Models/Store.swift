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
    
    static func == (lhs : Store, rhs: Store) -> Bool{
        lhs.id == rhs.id
    }
    


}



//struct StoreLocation: Identifiable {
//  let id = UUID()
//  let name: String
//  let coordinate: CLLocationCoordinate2D
//}
