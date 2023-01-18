//
//  DetailView.swift
//  GukbapMinister
//
//  Created by Martin on 2023/01/17.
//

import SwiftUI

class StarStore: ObservableObject {
    @Published var selectedStar: Int = 0
}

struct DetailView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    
    @State private var text: String = ""
    @State private var isBookmarked: Bool = false
    @ObservedObject var starStore = StarStore()
    
    let colors: [Color] = [.yellow, .green, .red]
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                let width: CGFloat = geo.size.width
                
                ScrollView {
                    ZStack {
                        Color(uiColor: .systemGray6)
                        
                        VStack(alignment: .leading, spacing: 0){
                            
                            //상호명 주소
                            //Store.storeName, Store.storeAddress
                            HStack {
                                VStack(alignment: .leading){
                                    Text("농민백암순대")
                                        .font(.title.bold())
                                        .padding(.bottom, 8)
                                    Text("서울 강남구 역삼로3길 20-4")
                                }
                                Spacer()
                            }
                            .padding(15)
                            .background(.white)
                            
                            //Store.images
                            TabView {
                                ForEach(Array(colors.enumerated()), id: \.offset) { index, color in
                                    
                                    VStack {
                                        Text("사진\(index + 1)")
                                            .foregroundColor(.white)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: width * 0.8)
                                    .background(color)
                                }
                            }
                            .frame(height:width * 0.8)
                            .tabViewStyle(.page(indexDisplayMode: .always))
                            
                            //Store.description
                            VStack(alignment: .leading) {
                                Text("수요미식회에서 인정한 선릉역 찐 맛집!")
                                    .lineLimit(10)
                                    .padding(.horizontal, 15)
                                    .padding(.vertical, 30)
                                Divider()
                            }
                            .background(.white)
                            
                            
                            //Store.menu
                            VStack {
                                VStack(alignment: .leading) {
                                    Text("메뉴")
                                        .font(.title2.bold())
                                        .padding(.bottom)
                                    
                                    HStack{
                                        Text("국밥")
                                        Spacer()
                                        Text("9,000원")
                                    }
                                    .padding(.bottom, 5)
                                    
                                    HStack{
                                        Text("술국")
                                        Spacer()
                                        Text("18,000원")
                                    }
                                    .padding(.bottom, 5)
                                    
                                    HStack{
                                        Text("수육")
                                        Spacer()
                                        Text("32,000원")
                                    }
                                    .padding(.bottom, 5)
                                    
                                    HStack{
                                        Text("토종순대")
                                        Spacer()
                                        Text("12,000원")
                                    }
                                    .padding(.bottom, 5)
                                }
                                .padding(15)
                                Divider()
                            }
                            .background(.white)
                            
                            
                            
                            //네이버맵뷰
                            NaverMapView(coordination: (37.503693, 127.053033))
                                .frame(height: 260)
                                .padding(.vertical, 15)
                            
                            
                            HStack {
                                Spacer()
                                VStack {
                                    Text("테디베어님의 후기를 남겨주세요")
                                        .fontWeight(.bold)
                                    
                                    Spacer()
                                    
                                    //별 재사용 예정
                                    
                                    HStack {
                                        ForEach(0..<5) { index in
                                                NavigationLink {
                                                    CreateReviewView(starStore: starStore, stars: index)
                                                } label: {
                                                    Image(starStore.selectedStar >= index ? "StarFilled" : "StarEmpty")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 30, height: 30)
                                                }
                                        }
                                    }
                                }
                                .padding(.vertical, 30)
                                
                                Spacer()
                            }
                            .background(.white)
                            
                            
                            VStack(spacing: 0) {
                                ForEach(0..<3) { index in
                                    let imageTest: [String] = .init(repeating: "Test", count: index)
                                    CommentUnit(nickname: "써니\(index)", date: "2023.01.17", starRate: 4, comment: "여기 외 않가?", images: imageTest)
                                    if index != 2 {
                                        Divider()
                                    }
                                }
                            }
                            .padding(.vertical, 15)
                            
                            
                            
                        }
                        .padding(.bottom, 200)
                    }
                }
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "arrow.backward")
                                .tint(.black)
                        }
                    }
                    
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            isBookmarked.toggle()
                        } label: {
                            Image(systemName: isBookmarked ? "heart.fill" : "heart")
                                .tint(.red)
                        }
                    }
                }
                
            }
        }
        
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        
        DetailView()
        
    }
}
