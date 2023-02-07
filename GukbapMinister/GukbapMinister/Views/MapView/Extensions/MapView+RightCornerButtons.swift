//
//  MapView+RightCornerUtilityButtons.swift
//  GukbapMinister
//
//  Created by Martin on 2023/02/06.
//

import SwiftUI

extension MapView {
  @ViewBuilder
  func rightCornerButtons(width: CGFloat, height: CGFloat) -> some View {
    StoreReportButton()
    .frame(maxWidth: .infinity)
    .frame(height: height * 0.45)
  }
}


