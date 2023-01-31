//
//  StoreView.swift
//  GukbapMinister
//
//  Created by ishio on 2023/01/31.
//

import SwiftUI

struct StoreView: View{
    //    var storeList: Store
    
    var body: some View{
//        VStack {
            ZStack {
                HStack{
                    Image(systemName: "heart.circle")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .offset(x: 150, y: -300)
                }
                HStack{
                    Rectangle() //storeImages 부분
                        .fill(.secondary)
                        .frame(width: 500, height: 500)
                        .ignoresSafeArea()
                        .offset(y: -250)
                }//HStack
                VStack{
                    HStack {
                        Text("storeList.storeName")
                        Spacer()
                    }
                    .padding(.bottom)
                    HStack {
                        Text("storeList.storeAddress")
                        Spacer()
                    }
                    .padding(.bottom)
                    HStack {
                        Text("storeList.description")
                        Spacer()
                    }
                    .padding(.bottom)
                }//VStack
                .offset(y: 80)
                .padding(70)
            }//ZStack
//        }// 가장 바깥 VStack
    } // var body
}

struct StoreView_Previews: PreviewProvider {
    static var previews: some View {
        StoreView()
    }
}
