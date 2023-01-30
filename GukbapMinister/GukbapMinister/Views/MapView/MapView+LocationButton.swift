//
//  MapView + LocationButton.swift
//  GukbapMinister
//
//  Created by TEDDY on 1/30/23.
//

import SwiftUI
import CoreLocationUI

extension MapView {
  // var 대신에 func을 쓰는 이유는 같은 mapView에 geo가 걸려있고 그 body 안에 쓰이고 scope 문제 해결
  func locationButton(width: CGFloat, height: CGFloat) -> some View {
    LocationButton {
      locationManager.requestLocation()
    }
    .labelStyle(.iconOnly)
    .cornerRadius(30)
    .font(.title3)
    .frame(width: 100, height: 100)
    .symbolVariant(.fill)
    .foregroundColor(.white)
    // offset이기 때문에 * 0일시 있던 위치 * 1일 시에 너비의 길이에 위치
    .offset(x: width * 0.5 * 0.75, y: height * 0.5)
  }
}
