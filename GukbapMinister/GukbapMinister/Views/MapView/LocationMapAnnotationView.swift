//
//  LocationMapAnnotationView.swift
//  GukbapMinister
//
//  Created by TEDDY on 1/30/23.
//

import SwiftUI

struct LocationMapAnnotationView: View {
  var body: some View {
    VStack (spacing: 0) {
      ZStack {
        Circle()
          .frame(width: 50, height: 50)
          .foregroundColor(.mainColor)
        
        Image("Ddukbaegi.fill")
          .resizable()
          .scaledToFit()
          .frame(width: 30, height: 30)
          .font(.headline)
          .foregroundColor(.mainColor)
          .padding(6)
          .background(Color.white)
        .cornerRadius(36)
      }

      Image(systemName: "triangle.fill")
        .resizable()
        .scaledToFit()
        .foregroundColor(.mainColor)
        .frame(width: 10, height: 10)
        .rotationEffect(Angle(degrees: 180))
        .offset(y: -3)
      // To prevent image to be right on the map
        .padding(.bottom, 40)
    }
  }
}

struct LocationMapAnnotationView_Previews: PreviewProvider {
  static var previews: some View {
    ZStack{
      
      LocationMapAnnotationView()
    }
  }
}
