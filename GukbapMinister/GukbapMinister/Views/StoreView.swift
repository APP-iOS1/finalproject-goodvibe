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
        ZStack {

            HStack{
                Image("ExampleImage")
                    .resizable()
                    .frame(width: 500, height: 700)
                    .ignoresSafeArea()
                    .offset(y: -250)
            }//HStack
            HStack{
                Image(systemName: "heart.circle")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.white)
                    .offset(x: 150, y: -350)
            }
            ZStack {
                Color(.black)
                    .ignoresSafeArea()
                    .offset(y: 475)
                VStack{
                    HStack {
                        Text("국밥부장관 12호점")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(.title)
                        Spacer()
                    }
                    .padding(.bottom, 25)
                    HStack {
                        Text("서울특별시 중구 세종대로 110")
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.bottom, 20)
                    HStack {
                        Text("한번 맛보면 절대 헤어나오지 못하는 담백한 국밥")
                            .font(.title3)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.bottom)
                    HStack {
                        Text("평점 4.9")
                            .font(.subheadline)
                            .foregroundColor(.white)
                        Text("조회수 24150")
                            .font(.subheadline)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.bottom)
                }//VStack
                .offset(y: 255)
                .padding(70)
            }
        }//ZStack
    } // var body
}

struct StoreView_Previews: PreviewProvider {
    static var previews: some View {
        StoreView()
    }
}
