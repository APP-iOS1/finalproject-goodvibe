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
}
