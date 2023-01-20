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

struct Store {
    
    var id: String
    var storeName: String
    var storeAddress: String
    var coordinate: GeoPoint
    var storeImages: [String]
    var menu: [[String]]
    var description: String
    var countingStar: Double
    var filterdGukbaps: [String] = []
}
