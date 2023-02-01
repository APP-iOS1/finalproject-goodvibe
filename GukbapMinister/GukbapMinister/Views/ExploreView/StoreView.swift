//
//  StoreView.swift
//  GukbapMinister
//
//  Created by ishio on 2023/01/31.
//

import SwiftUI

struct StoreView: View{
    var store :Store
     var storeViewModel: StoreViewModel

    var body: some View{
        ZStack {
            VStack{
                
                Image(uiImage: storeViewModel.storeTitleImage[store.storeImages.first ?? ""] ?? UIImage())
                    .resizable()
                    .frame(width: 353, height: 250)
            
//                HStack{
//                    Image("\(store.storeImages)")
//                        .resizable()
//                        .frame(width: 353, height: 250)
//
//                }//HStack
                
                HStack{
                    Image(systemName: "heart")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.secondary)
                        .fontWeight(.bold)
                        .offset(x: 140, y: -235)
                }
               
                    
                    VStack{
                        HStack {
                            Image(systemName: "mappin")
                            Text("\(store.storeName)")
                               
                                .fontWeight(.bold)
                                .font(.title2)
                            Spacer()
                        }
                        .padding(.bottom,5)
                        HStack {
                            Text("\(store.storeAddress)")
                            Spacer()
                        }
                        .padding(.bottom, 20)
                        HStack {
                            Text("\(store.description)")
                                .font(.title3)
                            Spacer()
                        }
                        .padding(.bottom)
                        HStack {
                            Text("평점 4.9")
                                .font(.subheadline)
                            Text("조회수 24150")
                                .font(.subheadline)
                            Spacer()
                        }
                        .padding(.bottom)
              
                    .foregroundColor(.white)
                    .offset(y: 255)
                    .padding([.leading,.trailing],45)
                }
            }
        }//ZStack
    } // var body
}

//struct StoreView_Previews: PreviewProvider {
//    static var previews: some View {
//        StoreView()
//    }
//}
