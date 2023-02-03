//
//  StoreModalView.swift
//  GukbapMinister
//
//  Created by TEDDY on 1/18/23.
//

import SwiftUI

struct StoreModalView: View {
  @EnvironmentObject private var mapViewModel: MapViewModel
  @State private var isHeart : Bool = false
  var store: Store = .test
  
  var body: some View {
    NavigationStack {
      VStack {
        HStack{
          Text(store.storeName)
            .font(.title2)
            .bold()
            .padding(.leading, 20)
          Spacer()
        }
        
        NavigationLink(destination: DetailView(store: store)) {
          HStack {
            AsyncImage(url: URL(string: store.storeImages.isEmpty ? "이미지 없음" : store.storeImages[0])) { image in
              image
                .resizable()
            } placeholder: {
              Color.gray.opacity(0.1)
            }
            .frame(width: 90, height: 90)
            .cornerRadius(6)
            .padding(.leading, 20)
            
            VStack{
              HStack(alignment: .top){
                Text(store.storeAddress)
                  .bold()
                  .padding(.leading, 20)
                Spacer()
                
              }
              .padding(.trailing, 20)
              .padding(.bottom, 20)
              HStack {
                Text("깍두기지수")
                Image("Ggakdugi")
                  .resizable()
                  .scaledToFill()
                  .frame(width: 20, height: 20)
                Text("\(store.countingStar)")
                
                Spacer()
              }
            }
            .padding(.horizontal, 5)
            
          }
          .background {
            RoundedRectangle(cornerRadius: 25)
              .frame(width: 346, height: 103)
              .foregroundColor(Color.mainColor)
              .opacity(0.2)
          }
        }
        
      }
    }
    
  }
}

//struct StoreModalView_Previews: PreviewProvider {
//  static var previews: some View {
//    StoreModalView()
//  }
//}
