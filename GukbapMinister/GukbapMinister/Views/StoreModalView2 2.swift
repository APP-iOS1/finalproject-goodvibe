//
//  StoreModalView.swift
//  GukbapMinister
//
//  Created by TEDDY on 1/18/23.
//

import SwiftUI

struct StoreModalView2: View {
    @State private var isHeart : Bool = false
    

    
  var body: some View {
    
    VStack {
        HStack{
            Text("우가네")
                .font(.title2)
                .bold()
                .padding(.leading, 20)
            Spacer()
        }
        
      HStack {
        AsyncImage(url: URL(string: "https://img1.kakaocdn.net/cthumb/local/R0x420/?fname=http%3A%2F%2Ft1.daumcdn.net%2Flocal%2FkakaomapPhoto%2Freview%2F3c7f504de60ea04fdff919b38722b977e15f59e8%3Foriginal")) { image in
          image
            .resizable()
            //.scaledToFit()
        } placeholder: {
            Color.gray.opacity(0.1)
          }
        .frame(width: 100, height: 100)
        .cornerRadius(6)
        .padding(.leading, 20)

          VStack{
              HStack(alignment: .top){
                  Text("서울 강남구 선릉로96길 7 1층")
                      .bold()
                  
                  Spacer()
                  
                  Button{
                      isHeart.toggle()
                  } label: {
                      Image(systemName: isHeart ? "heart.fill" : "heart")
                          .foregroundColor(.red)
                  }
                  .padding(.top, 2.5)
              }
              .padding(.trailing, 20)
              .padding(.bottom, 20)
              HStack{
                  Text("별점")
                  
                  HStack(spacing: 0) {
                      Text(Image(systemName: "star.fill")).foregroundColor(.yellow)
                      Text(Image(systemName: "star.fill")).foregroundColor(.yellow)
                      Text(Image(systemName: "star.fill")).foregroundColor(.yellow)
                      Text(Image(systemName: "star.fill")).foregroundColor(.yellow)
                      Text(Image(systemName: "star")).foregroundColor(.yellow)
                  }
                  
                  Spacer()
              }
          }
          .padding(.horizontal, 5)

          
      }
      .background {
          RoundedRectangle(cornerRadius: 5)
              .frame(width: 375, height: 120)
              .foregroundColor(.gray)
              .opacity(0.2)
      }
        
    }
  }
}

struct StoreModalView2_Previews: PreviewProvider {
  static var previews: some View {
    StoreModalView2()
  }
}
