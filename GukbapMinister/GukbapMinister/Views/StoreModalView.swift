//
//  StoreModalView.swift
//  GukbapMinister
//
//  Created by TEDDY on 1/18/23.
//

import SwiftUI

struct StoreModalView: View {
  var body: some View {
    
    VStack {
      Text("농민백암순대")
      HStack {
        AsyncImage(url: URL(string: "https://d12zq4w4guyljn.cloudfront.net/20201217093530967_photo_4cfe72970c06.jpg")) { image in
          image
            .resizable()
            .scaledToFit()
        } placeholder: {
          Color.gray.opacity(0.1)
        }
        .frame(width: 100, height: 100)
        .cornerRadius(6)
        
        Text("서울특별시 강남구 역삼로 3길 20-4")
        Image(systemName: "heart.fill")
      }
    }
  }
}

struct StoreModalView_Previews: PreviewProvider {
  static var previews: some View {
    StoreModalView()
  }
}
