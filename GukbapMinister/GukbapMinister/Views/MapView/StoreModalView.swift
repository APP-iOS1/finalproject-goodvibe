//
//  StoreModalView.swift
//  GukbapMinister
//
//  Created by TEDDY on 1/18/23.
//

import SwiftUI

struct StoreModalView: View {
  @State private var isHeart : Bool = false
  @Binding var selectedDetent: PresentationDetent
  
  var storeLocation : Store
  
  var body: some View {
    NavigationStack {
      VStack {
        Button("test") {
          selectedDetent = .large
        }
        
        HStack{
          Text(storeLocation.storeName)
            .font(.title2)
            .bold()
            .padding(.leading, 20)
          Spacer()
        }
        
        NavigationLink {
          DetailView()
        } label: {
          HStack {
            AsyncImage(url: URL(string: storeLocation.storeImages[0])) { image in
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
                Text(storeLocation.storeAddress)
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
  }
}

//struct StoreModalView_Previews: PreviewProvider {
//  static var previews: some View {
//    StoreModalView()
//  }
//}
