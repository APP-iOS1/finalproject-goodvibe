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
    let sampleColors: [Color] = [.yellow, .orange, .red]

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
                                        ForEach(Array(sampleColors.enumerated()), id: \.offset) { index, color in
                                            
                                            VStack {
                                                Text("국밥집 장관들의 Pick \(index + 1)")
                                                    .font(.title3)
                                                    .foregroundColor(.white)
                                                    .tag(index)
                                            }
                                            .frame(maxWidth: .infinity)
                                            .frame(height: UIScreen.main.bounds.width * 0.8)
                                            .background(color)
                                        }
                                    }
                                    .frame(height: UIScreen.main.bounds.width * 0.75)
                                    .tabViewStyle(.page(indexDisplayMode: .always))
                                    .onReceive(timer, perform: { _ in next()})
                                    
                                    
                                    
                                    ExploreCategoryIconsView()
                                        .frame(width: UIScreen.main.bounds.width)
                        }
                        
                        
                        VStack{
                            
                            
                            VStack(alignment: .leading, spacing: 0) {
                                HStack(alignment: .center, spacing: 0){
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(.red)
                                        .padding(.trailing, 5)
                                    
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
                                                StoreView(store:store, imagedata: imageData)
                                            }
                                            .padding(.bottom, 10)
                                        }
                                    }
                                    .padding(.leading, 10)
                                }

                                
                            }
                            .background(scheme == .light ? .white : .black)
                            
                            
                            
                            
                            
                            VStack(alignment: .leading, spacing: 0) {
                                HStack(alignment: .center, spacing: 0){
                                    Image("Ggakdugi")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .padding(.trailing, 5)

                                    
                                    Text("깍두기 점수가 높은 국밥집")
                                        .bold()

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
                                        ForEach(storesViewModel.stores, id: \.self){ store in
                                            let imageData = storesViewModel.storeTitleImage[store.storeImages.first ?? ""] ?? UIImage()
                                            NavigationLink{
                                                DetailView(store: store)
                                            } label:{
                                                StoreView(store:store, imagedata: imageData)
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
                    //storeViewModel.fetchStore()
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


struct StoreView: View{
    var store :Store
    var imagedata: UIImage
    var body: some View{
        
        VStack{
            
            VStack{
                Image(uiImage: imagedata)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 190, height: 190)
                    .cornerRadius(10)
                
                VStack{
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
                        
                        Spacer()
                    }
                    .padding(.bottom, 5)
                    
                    
                    HStack {
                        Text("\(store.description)")
                            .font(.caption)
                            .bold()
                            .lineLimit(1)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    .padding(.bottom, 5)


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

