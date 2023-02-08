//
//  StoreAnnotation.swift
//  GukbapMinister
//
//  Created by Martin on 2023/01/31.
//

import Foundation
import MapKit

// MKAnnotation에 title과 subtitle이 존재
// The string containing the annotation’s title and subtitle.
class StoreAnnotation: NSObject, MKAnnotation {
    let storeId: String
    let title: String?
    let subtitle: String?
    let foodType: [String]
    let coordinate: CLLocationCoordinate2D
    
    init(storeId: String,
         title: String?,
         subtitle: String?,
         foodType: [String],
         coordinate: CLLocationCoordinate2D) {
        self.storeId = storeId
        self.title = title
        self.subtitle = subtitle
        self.foodType = foodType
        self.coordinate = coordinate
    }
}
