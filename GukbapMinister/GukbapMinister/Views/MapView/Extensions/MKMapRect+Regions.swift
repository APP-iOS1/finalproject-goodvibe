//
//  MapRect+Regions.swift
//  GukbapMinister
//
//  Created by Martin on 2023/01/31.
//

import Foundation
import MapKit



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
