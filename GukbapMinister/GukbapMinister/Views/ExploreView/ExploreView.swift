//
//  ExploreView.swift
//  GukbapMinister
//
//  Created by Martin on 2023/01/16.
//

import SwiftUI

struct ExploreView: View {
    @Environment(\.colorScheme) var scheme

    @EnvironmentObject var storesViewModel: StoresViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    
    @State private var selectedIndex: Int = 0
    
    // HGrid의 행
    var rows: [GridItem] = Array(repeating: .init(.fixed(50)), count: 1)
    
    // 배너의 샘플
    //let sampleColors: [Color] = [.yellow, .orange, .red]
    let bannerIndex : [String] = ["GBMain1", "GBMain2" , "GBMain3" ]
    let bannerImg : [String : String] = ["GBMain1" : "이달의 국밥집 Top 3", "GBMain2" : "국밥집 장관들의 Pick", "GBMain3" : "서울 3대 국밥"]

    
    // 배너 자동 넘기기 기능
    private var numberOfImages = 3
    private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    @State private var currentIndex = 0
    
    func previous() {
        currentIndex = currentIndex > 0 ? currentIndex - 1 : numberOfImages - 1
    }
    
    func next() {
        withAnimation {
            currentIndex = currentIndex < numberOfImages ? currentIndex + 1 : 0
        }
    }
    @State var isLoading = true
    

    var body: some View {
        NavigationStack{
            SearchBarButton()
                .padding(.bottom, 5)
                .background(scheme == .light ? .white : .black)
            
            ZStack{
                Color.gray.opacity(scheme == .light ? 0.2 : 0)
                
                VStack{
                    ScrollView{
                        VStack(spacing: 0){
                                    TabView(selection: $currentIndex) {
                                        ForEach(Array(bannerIndex.enumerated()), id: \.offset) { index, img in
                                            
                                            // TODO : 클릭시 국밥집 해당되는 국밥집 소개 페이지(또는 리스트 뷰, 또는 정보 창) 이동
                                            // 현재는 2, 3번째 이미지 저작권(출처) 이슈
                                            
                                            ZStack (alignment: .topLeading) {
                                                Text("\(bannerImg[img] ?? "")")
                                                    .font(.title)
                                                    .bold()
                                                    .foregroundColor(.white)
                                                    .padding(.top, 25)
                                                    .padding(.leading, 20)
                                                    .zIndex(1)
                                                    .tag(index)
                                                
                                                
                                                Image("\(img)")
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.75)
                                                    .overlay{ (LinearGradient(gradient: Gradient(colors: [Color.black, .clear]), startPoint: .center, endPoint: .bottom).opacity(0.5))
                                                    }

                                            }
//                                            .frame(maxWidth: .infinity)
//                                            .frame(height: UIScreen.main.bounds.width * 0.75)
                                            
                                        }
                                    }
                                    .frame(height: UIScreen.main.bounds.width * 0.75)
                                    .tabViewStyle(.page(indexDisplayMode: .always))
                                    .onReceive(timer, perform: { _ in next()})
                                    
                                    
                                    
                                    ExploreCategoryIconsView()
                                        .frame(width: UIScreen.main.bounds.width)
                        }
                        
                        
                        // TODO : 찜 순으로 StoreCollectView 에 담아줘야함
                        // 뷰모델 및 모델에 찜 카운트 항목 생성해서 전체적인 수정 필요
                    
                        VStack{
                            VStack(alignment: .leading, spacing: 0) {
                                HStack(alignment: .center, spacing: 0){

                                    Text("찜이 가장 많이 된 국밥집")
                                        .font(.body)
                                        .bold()
                                    

                                }
                                .padding(.top)
                                .padding(.leading)
                                .font(.body)

                                
                                Text("국밥부 직원들이 가장 많이 찜한 국밥집들을 소개합니다")
                                    .foregroundColor(.gray)
                                    .font(.caption)
                                    .padding(.leading)
                                    .padding(.top, 3)

                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    LazyHGrid(rows: rows, alignment: .center) {
                                        ForEach(storesViewModel.stores, id: \.self){ store in
                                            let imageData = storesViewModel.storeTitleImage[store.storeImages.first ?? ""] ?? UIImage()
                                            NavigationLink{
                                                DetailView(store: store)
                                            } label:{
                                                StoreCollectView(store:store, imagedata: imageData)
                                            }
                                            .padding(.bottom, 10)
                                        }
                                    }
                                    .padding(.leading, 10)
                                }
                            }
                            .background(scheme == .light ? .white : .black)
                            
                            
                            
                            // 깍두기 점수 순 정렬 뷰
                            VStack(alignment: .leading, spacing: 0) {
                                HStack(alignment: .center, spacing: 0){

                                    
                                    Text("깍두기 점수가 높은 국밥집")
                                        .bold()
                                    
                                    
                                    Spacer()
                                    
                                    NavigationLink{
                                        DetailListView(listName : "깍두기 점수 랭킹", list : storesViewModel.storesStar, images: storesViewModel.storeTitleImageStar)
                                    } label:{
                                        Text("더보기 >")
                                            .font(.caption)
                                            .bold()
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.trailing)


                                }
                                .padding(.top)
                                .padding(.leading)
                                .font(.body)

                                Text("국밥부 직원들이 높게 평가한 국밥집을 모아봤어요")
                                    .foregroundColor(.gray)
                                    .font(.caption)
                                    .padding(.leading)
                                    .padding(.top, 3)

                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    LazyHGrid(rows: rows, alignment: .center) {
                                        ForEach(storesViewModel.storesStar, id: \.self){ store in
                                            let imageData = storesViewModel.storeTitleImageStar[store.storeImages.first ?? ""] ?? UIImage()
                                            NavigationLink{
                                                DetailView(store: store)
                                            } label:{
                                                StoreStarView(store:store, imagedata: imageData)
                                            }
                                            .padding(.bottom, 10)
                                        }
                                    }
                                    .padding(.leading, 10)
                                }
                            }
                            .background(scheme == .light ? .white : .black)

                            
                            
                        }
                        //VStack
                        
                    } //ScrollView
                    
                    
                } //VStack
            } // ZStack
            .onAppear {
                Task{
                    storesViewModel.subscribeStores()
                    storesViewModel.fetchStarStores()
                }

            }
            .onDisappear {
                storesViewModel.unsubscribeStores()
            }
        } //NavigationStack
        .redacted(reason: isLoading ? .placeholder : [])
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isLoading = false
          }
        }
    } // var body
}


// 별점 순으로 보여주는 하위 뷰
struct StoreStarView: View{
    var store : Store
    var imagedata: UIImage
    var body: some View{
        
        VStack{
            
            VStack{

                ZStack(alignment: .topLeading){
                    HStack(alignment: .center, spacing: 0){
                        Image("Ggakdugi")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .padding(.trailing, 5)

                        
                        Text("\(String(format: "%.1f", store.countingStar))")
                            .font(.caption)
                            .bold()
                    }
                    .zIndex(1)
                    .padding(5)
                    .background(RoundedRectangle(cornerRadius: 10).fill(.white.opacity(0.5)))
                    .padding(.top, 3)
                    .padding(.leading, 3)
                    
                    Image(uiImage: imagedata)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 190, height: 190)
                        .cornerRadius(10)
                }
                
                
                VStack(alignment: .leading, spacing: 1){
                    HStack {
                        Text("\(store.storeName)")
                            .fontWeight(.bold)
                            .font(.callout)
                            .padding(5)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color("AccentColor").opacity(0.1)))

                        Spacer()
                    }
                    
                    HStack {
                        Text("\(store.storeAddress)")
                            .font(.caption2)
                            .lineLimit(1)
                            .padding(.leading, 3)
                        Spacer()
                    }
                    .padding(.vertical, 3)

                    
                    HStack {
                        Text("\(store.description)")
                            .font(.caption)
                            .bold()
                            .lineLimit(1)
                            .padding(.leading, 3)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    .padding(.vertical, 3)


                }
                .frame(width: 185)
                .padding(2.5)
            } //VStack
            .foregroundColor(.black)
            .frame(width: 200, height: 300)
            .padding(1)
            
        } // var body
    }
}


// 찜 순으로 보여주는 하위 뷰
struct StoreCollectView: View{
    var store : Store
    var imagedata: UIImage
    var body: some View{
        
        VStack{
            
            VStack{
                ZStack(alignment: .topLeading){
                    HStack(alignment: .center, spacing: 0){
                        Image(systemName: "heart.fill")
                            .resizable()
                            .foregroundColor(.red)
                            .frame(width: 13, height: 12)
                            .padding(.trailing, 5)

                        
                        Text("124")
                            .font(.caption)
                            .bold()
                    }
                    .zIndex(1)
                    .padding(5)
                    .background(RoundedRectangle(cornerRadius: 10).fill(.white.opacity(0.5)))
                    .padding(.top, 3)
                    .padding(.leading, 3)
                    
                    Image(uiImage: imagedata)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 190, height: 190)
                        .cornerRadius(10)
                }

                
                VStack(alignment: .leading, spacing: 1){
                    HStack {
                        Text("\(store.storeName)")
                            .fontWeight(.bold)
                            .font(.callout)
                            .padding(5)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color("AccentColor").opacity(0.1)))

                        Spacer()
                    }
                    
                    HStack {
                        Text("\(store.storeAddress)")
                            .font(.caption2)
                            .lineLimit(1)
                            .padding(.leading, 3)
                        Spacer()
                    }
                    .padding(.vertical, 3)

                    
                    HStack {
                        Text("\(store.description)")
                            .font(.caption)
                            .bold()
                            .lineLimit(1)
                            .padding(.leading, 3)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    .padding(.vertical, 3)


                }
                .frame(width: 185)
                .padding(2.5)
            } //VStack
            .foregroundColor(.black)
            .frame(width: 200, height: 300)
            .padding(1)
            
        } // var body
    }
}

