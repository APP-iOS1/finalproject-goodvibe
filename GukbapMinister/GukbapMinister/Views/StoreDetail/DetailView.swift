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
    @EnvironmentObject var userViewModel: UserViewModel
    @StateObject private var reviewViewModel: ReviewViewModel = ReviewViewModel()
    
    @ObservedObject var starStore = StarStore()
    
    @State private var text: String = ""
    @State private var isBookmarked: Bool = false
    @State private var showingAddingSheet: Bool = false
    
    
    let colors: [Color] = [.yellow, .green, .red]
    let menus: [[String]] = [["국밥", "9,000원"], ["술국", "18,000원"], ["수육", "32,000원"], ["토종순대", "12,000원"]]
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                let width: CGFloat = geo.size.width
                ScrollView {
                    ZStack {
                        //배경색
                        Color(uiColor: .systemGray6)
                        
                        VStack(alignment: .leading, spacing: 0){
                            //상호명 주소
                            //Store.storeName, Store.storeAddress
                            storeNameAndAddress
                            
                            //Store.images
                            storeImages(width)
                            
                            //Store.description
                            storeDescription
                            
                            //Store.menu
                            storeMenu
                 
                          // refactoring으로 인한 일시 주석처리
//                            NaverMapView(coordination: (37.503693, 127.053033), marked: .constant(false), marked2: .constant(false))
//                                .frame(height: 260)
//                                .padding(.vertical, 15)
                            
                            userStarRate
                            
                            userReview
                            
                        }//VStack
                        .padding(.bottom, 200)
                    }//ZStack
                }//ScrollView
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
            }//GeometryReader
        }//NavigationStack
        .sheet(isPresented: $showingAddingSheet) {
            CreateReviewView(reviewViewModel: reviewViewModel, starStore: starStore,showingSheet: $showingAddingSheet )
        }
    }//body
}//struct

extension DetailView {
    var storeNameAndAddress: some View {
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
    }
    
    func storeImages(_ width: CGFloat) -> some View {
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
        
    }
    
    var storeDescription: some View {
        VStack(alignment: .leading) {
            Text("수요미식회에서 인정한 선릉역 찐 맛집!")
                .lineLimit(10)
                .padding(.horizontal, 15)
                .padding(.vertical, 30)
            Divider()
        }
        .background(.white)
    }
    
    var storeMenu: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("메뉴")
                    .font(.title2.bold())
                    .padding(.bottom)

                ForEach(menus, id: \.self) {menu in
                    HStack{
                        Text(menu[0])
                        Spacer()
                        Text(menu[1])
                    }
                    .padding(.bottom, 5)
                }
            }
            .padding(15)
            Divider()
        }
        .background(.white)
    }
    
    var userStarRate: some View {
        HStack {
            Spacer()
            VStack {
                Text("테디베어님의 후기를 남겨주세요")
                    .fontWeight(.bold)
                
                Spacer()
                
                //별 재사용 예정
                
                HStack {
                    ForEach(0..<5) { index in
                        Button {
                            starStore.selectedStar = index
                            showingAddingSheet.toggle()
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
    }
    
    var userReview: some View {
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
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(starStore: StarStore())
    }
}
