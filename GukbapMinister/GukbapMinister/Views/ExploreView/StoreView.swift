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
        
            VStack{
                
                //                Image(uiImage: storeViewModel.storeTitleImage[store.storeImages.first ?? ""] ?? UIImage())
                Image("ExampleImage")
                    .resizable()
                    .frame(width: 353, height: 250)
                    .padding(.top, 25)
                
                
                
                Image(systemName: "heart")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(.secondary)
                    .fontWeight(.bold)
                    .offset(x: 140, y: -235)
                    .padding(.bottom, -25)
                
                
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
                    .padding(.bottom, 10)
                    HStack {
                        Text("\(store.description)")
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    .padding(.bottom, 10)
                    
                    HStack {
                        Text("평점 4.9")
                        Text("조회수 24150")
                        Spacer()
                    }
                    .font(.callout)
                    
                    
                }
                .padding()
                
                
            }
            .background {
                Rectangle()
                    .stroke(Color.mainColor)
            }
            .padding(10)
        
        
    } // var body
}

//struct StoreView_Previews: PreviewProvider {
//    static var previews: some View {
//        StoreView()
//    }
//}
