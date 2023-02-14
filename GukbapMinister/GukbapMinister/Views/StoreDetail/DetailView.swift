//
//  DetailView.swift
//  GukbapMinister
//
//  Created by Martin on 2023/01/17.
//

import SwiftUI
import Shimmer

import FirebaseAuth
class StarStore: ObservableObject {
    @Published var selectedStar: Int = 0
}

struct DetailView: View {
    @Environment(\.colorScheme) var scheme
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var userViewModel: UserViewModel
    //   @EnvironmentObject var mapViewModel: MapViewModel
    @StateObject private var reviewViewModel: ReviewViewModel = ReviewViewModel()
    @StateObject private var storesViewModel: StoresViewModel = StoresViewModel()
    @StateObject private var collectionViewModel: CollectionViewModel = CollectionViewModel()
    
    //@StateObject var storeViewModel : StoreRegistrationViewModel = StoreRegistrationViewModel()
    @EnvironmentObject var storeViewModel : StoreRegistrationViewModel
    
    @ObservedObject var starStore = StarStore()
    
    @State private var text: String = ""
    @State private var isBookmarked: Bool = false
    @State private var showingCreateRewviewSheet: Bool = false
    @State private var ggakdugiCount: Int = 0
    
    @State var startOffset: CGFloat = 0
    @State var scrollViewOffset: CGFloat = 0
    @State private var isReviewImageClicked: Bool = false
    
    let currentUser = Auth.auth().currentUser
    
    //lineLimit 관련 변수
    @State private var isFirst: Bool = true
    @State private var isExpanded: Bool = false
    
    //StoreImageDetailView 전달 변수
    @State private var isshowingStoreImageDetail: Bool = false
    
    
    @State private var isLoading: Bool = true
    
    
    var store : Store
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ScrollView(showsIndicators: false) {
                    VStack{
                        storeImages
                        
                        storeFoodTypeAndRate
                        
                        storeDescription
                        
                        storeMenu
                        
                        userStarRate
                        
                        ForEach(reviewViewModel.reviews) { review in
                            if (review.storeName == store.storeName){
                                UserReviewCell(reviewViewModel: reviewViewModel, review: review, isInMypage: false)
                            }
                        }//FirstForEach
                        
                    }//VStack
                    
                }//ScrollView
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "arrow.backward")
                                .tint(scheme == .light ? .black : .white)
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {

                        Button {
                            collectionViewModel.isHeart.toggle()
                            collectionViewModel.manageHeart(userId: currentUser?.uid ?? "" , store: store)
                        } label: {
                            Image(systemName: collectionViewModel.isHeart ? "heart.fill" : "heart")
                                .tint(.red)
                        }
                    }
                }
            }//GeometryReader
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("\(store.storeName)").font(.headline)
                        Text("\(store.storeAddress)").font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            //            .navigationTitle(store.storeName)
        }//NavigationStack
        //가게 이미지만 보는 sheet로 이동
        .fullScreenCover(isPresented: $isshowingStoreImageDetail){
            StoreImageDetailView(storesViewModel: storesViewModel, isshowingStoreImageDetail: $isshowingStoreImageDetail, store: store)
        }
        //리뷰 작성하는 sheet로 이동
        .fullScreenCover(isPresented: $showingCreateRewviewSheet) {
            CreateReviewView(reviewViewModel: reviewViewModel, starStore: starStore,showingSheet: $showingCreateRewviewSheet, store: store )
        }
        .onAppear{
            Task{
                storesViewModel.subscribeStores()
            }
            // 조회수 증가
            storesViewModel.increaseHits(store: store)

        }
        .onDisappear {
            storesViewModel.unsubscribeStores()
        }
        .refreshable {
            reviewViewModel.fetchReviews()
        }
        .redacted(reason: isLoading ? .placeholder : [])
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isLoading = false
          }
        }
    }//body
}//struct

extension DetailView {
    
    //MARK: 가게 이미지
    var storeImages: some View {
        TabView {
            
            ForEach(Array(store.storeImages.enumerated()), id: \.offset){ index, imageData in
                Button(action: {
                    isshowingStoreImageDetail.toggle()
                }){
                    if let image = storesViewModel.storeTitleImage[imageData] {
                        
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                        
                    }
                    //if let
                }
                
            }
            
        }
        .frame(height:Screen.maxWidth * 0.8)
        .tabViewStyle(.page(indexDisplayMode: .always))
    }
    
    //MARK: 가게 음식종류, 평점
    var storeFoodTypeAndRate: some View {
        VStack {
            HStack {
                ForEach(store.foodType, id: \.self) { gukbap in
                    Text(gukbap)
                        .font(.footnote)
                        .bold()
                        .padding(.vertical, 2)
                        .padding(.horizontal, 10)
                        .background {
                            Capsule()
                                .fill(Color.mainColor.opacity(0.1))
                        }
                }
                
                Spacer()
                
                GgakdugiRatingShort(rate: store.countingStar , size: 22)
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            
            Divider()
                .padding(.bottom, 10)
        }
    }
    
    //MARK: 가게 설명
    var storeDescription: some View {
        
        VStack{
            Text(store.description)
                .font(.body)
                .frame(width: Screen.maxWidth - 20)
                .lineSpacing(5)
                .lineLimit(isExpanded ? nil : 2)
            
            Divider()
                .overlay {
                        Button {
                            isExpanded.toggle()
                        } label: {
                            HStack{
                                if isExpanded {
                                    Text("접기")
                                    Image(systemName: "chevron.up")
                                } else {
                                    Text("더보기")
                                    Image(systemName: "chevron.down")
                                }
                                    
                            }
                            .padding(EdgeInsets(top: 3, leading: 8, bottom: 3, trailing: 8))
                            .font(.footnote)
                            .fontWeight(.medium)
                            .foregroundColor(scheme == .light ? .black : .white)
                        }
                        .background {
                            Capsule().fill(scheme == .light ? .white : .black)
                                .overlay{
                                    Capsule().fill(Color.mainColor.opacity(0.1))
                                }
                        }
                }
                .padding(.vertical, 20)
            
        }

    }
    
    
    //MARK: 가게 메뉴정보
    var storeMenu: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("메뉴")
                    .font(.title2.bold())
                    .padding(.bottom)
                
                ForEach(store.menu.sorted(by: <), id: \.key) {menu, price in
                    HStack{
                        Text(menu)
                        Spacer()
                        Text(price)
                    }
                    .padding(.bottom, 5)
                }
            }
            .padding(15)
            Divider()
        }
        .background(scheme == .light ? .white : .black)
    }
    
    var userStarRate: some View {
        VStack {
            HStack {
                Spacer()
                VStack {
                    //                    Text("\(userViewModel.userInfo.userNickname) 님의 리뷰를 작성해주세요.")
                    Text("\(userViewModel.userInfo.userNickname) 님 이 국밥집은 어떠셨나요?")
                        .fontWeight(.bold)
                        .padding(.bottom,10)
                    
                    
                    GgakdugiRatingWide(selected: starStore.selectedStar, size: 40, spacing: 15) { ggakdugi in
                        starStore.selectedStar = ggakdugi
                        showingCreateRewviewSheet.toggle()
                    }
                }
                .padding(.top, 10)
                .padding(.bottom, 15)
                
                Spacer()
            }
            .background(scheme == .light ? .white : .black)
            
        }
        
    }
}



//struct DetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailView(starStore: StarStore())
//    }
//}

