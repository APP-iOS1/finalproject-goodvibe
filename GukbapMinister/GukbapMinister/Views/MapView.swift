//
//  MapView.swift
//  GukbapMinister
//
//  Created by Martin on 2023/01/16.
//

import SwiftUI

struct MapView: View {
    // 초기 좌표값 서울시청
    @State var coordination: (Double, Double) = (37.503693, 127.053033)
    @State var searchGukBap : String = ""
    @State private var showModal = false //상태
    @State var marked : Bool = false // 마크 모달 

    
    var body: some View {
        
        ZStack {
            VStack {
                
                HStack{
                    ZStack {
                        VStack {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.secondary)
                                    .padding(.leading, 15)
                                TextField("국밥집 검색",text: $searchGukBap)
                            }
                            .frame(width: 280, height: 50)
                            .background(Capsule().fill(Color.white))
                            .overlay {
                                Capsule()
                                    .stroke(.yellow)
                            }
                        }
                    }
                    
                    Button{
                        //
                    } label: {
                        Text("확인")
                            .foregroundColor(.white)
                    }
                    .frame(width: 65, height: 50)
                    .background(.yellow)
                    .cornerRadius(25)
                }
                
                HStack{
                    Button{
                        self.showModal = true
                    } label: {
                        Text(Image(systemName: "slider.horizontal.3")).foregroundColor(.gray) + Text("필터")
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Capsule().fill(Color.white))
                    .overlay {
                        Capsule()
                            .stroke(.yellow)
                    }
                    .padding(.leading, 10)
                    .sheet(isPresented: self.$showModal) {
                        MapCategoryModalView()
                            .presentationDetents([.medium])
                    }

                    
                    Spacer()
                    
                }
                
                Button(action: {coordination = (35.1379222, 129.05562775)}) {
                    Text("부산으로 위치 이동")
                }
                Button(action: {coordination = (37.503693, 127.053033)}) {
                    Text("서울 아무 지역으로 위치 이동")
                }
                Spacer()
            }
            .zIndex(1)
            
            NaverMapView(coordination: coordination, marked: $marked)
                .edgesIgnoringSafeArea(.all)
                .sheet(isPresented: self.$marked) {
                    StoreModalView()
                        .presentationDetents([.height(200)])
                }
        }
        
    }
}

//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView(marked: )
//    }
//}
