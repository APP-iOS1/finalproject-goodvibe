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
    VStack(spacing: 16) {
      Spacer()
      HStack{
        Spacer()
        StoreReportButton()
        
      }.offset(x: -10, y: -40)
      
      HStack {
        Spacer()
      }
      //            HStack {
      //                Spacer()
      //                Button {
      //                    locationManager.requestLocation()
      //                } label: {
      //                    Circle()
      //                        .fill(Color.mainColorDark)
      //                        .frame(width: 42, height: 42)
      //                        .overlay {
      //                            Image(systemName: "location")
      //                                .font(.title3)
      //                                .foregroundColor(.mainColorLight)
      //                        }
      //                }
      //
      //            }
    }
    .frame(maxWidth: .infinity)
    .frame(height: height * 0.45)
    .padding(.trailing, 16)
  }
}


