//
//  DetailView.swift
//  GukbapMinister
//
//  Created by Martin on 2023/01/17.
//
import SwiftUI
import Shimmer
import FirebaseFirestore

import FirebaseAuth
import Firebase
import FirebaseFirestoreSwift
struct DetailView: View {
    @Environment(\.colorScheme) var scheme
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var userViewModel: UserViewModel
    @StateObject private var reviewViewModel: ReviewViewModel = ReviewViewModel()
    @EnvironmentObject private var storesViewModel: StoresViewModel
    @StateObject private var collectionViewModel: CollectionViewModel = CollectionViewModel()
    
    @State private var selectedStar: Int = 0
    
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
    var storeReview : [Review] {
        reviewViewModel.reviews.filter{
            $0.storeName == store.storeName
        }
    }
    @State var reviewData : [Review] = []
    
    var store : Store
    @State var time = Timer.publish(every: 0.1, on: .main, in: .tracking).autoconnect()

    var body: some View {
        NavigationStack {
   
                ScrollView(showsIndicators: false) {
                    VStack{
                        storeImages
                        
                        storeFoodTypeAndRate
                        
                        storeDescription
                        
                        storeMenu
                        
                        userStarRate
                        
                        
                        
                        
                        
                        if !self.reviewViewModel.reviews2.isEmpty {
                        ForEach(reviewViewModel.reviews2) { review in
                            
                            if review.reviewText == "" {}
                            else {
                                   //  ZStack{
                                if self.reviewViewModel.reviews2.last?.id == review.id {
                                    GeometryReader { g in
                                        UserReviewCell(reviewViewModel: reviewViewModel, review: review, isInMypage: false)
                                            .onAppear(){
                                                self.time = Timer.publish(every: 0.1, on: .main, in: .tracking).autoconnect()
                                            }
                                            .onReceive(self.time) { (_) in
                                                print(g.frame(in:.global).maxY)
                                                print(UIScreen.main.bounds.height - 120)
                                                if g.frame(in:.global).maxY < UIScreen.main.bounds.height - 120{
                                                 
                                                    reviewViewModel.updateReviews()
                                                    print("리뷰 데이터 로딩중")
                                                    self.time.upstream.connect().cancel()
                                                }

                                            }
                                    }
                                }
                                else{
                                    UserReviewCell(reviewViewModel: reviewViewModel, review: review, isInMypage: false)
                                }
                                    //  }
                            }
                            
                        }
                        //FirstForEach
                        }else{
                            VStack{
                                Image(uiImage: (Gukbaps(rawValue: store.foodType.first ?? "순대국밥")?.uiImagePlaceholder!)!)
                                    .resizable()
                                    .frame(width: UIScreen.main.bounds.width * 0.53,
                                           height: UIScreen.main.bounds.height * 0.25 )
                                
                                    Text("작성된 리뷰가 없습니다.")
                                         .padding(.bottom)
                                         .padding(.top,-20)
                                         .font(.title2)
                                         .fontWeight(.semibold)
                                         .foregroundColor(.secondary)
                            }
                        }
//                                                GeometryReader {reader -> Color in
//
//
//                                                        let minY = reader.frame(in: .global).minY
//                                                        let height = UIScreen.main.bounds.height * 0.7
//                                                        if reviewViewModel.reviews2.isEmpty && ( minY < height) {
//                                                            print("마지막\(minY)")
//                                                        }
//                                                        if minY < height {
//                                                            print("화면 70%\(minY)")
//                                                            reviewViewModel.fetchReviews()
//                                                        }
//
//
//                                                    return Color.clear
//
//                                                }
                           
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
            CreateReviewView(reviewViewModel: reviewViewModel,selectedStar: $selectedStar, showingSheet: $showingCreateRewviewSheet, store: store )
        }
        .onAppear{
            print("asdfadjflakjsdhkljfhasdkjfhakjsdhfkajhsdlkjfhkaljhskdhfkjahskljdhfkjahskldjhfkjahskjdhfkjahsdkjfhakjdshfkjhlasdf\(UIScreen.main.bounds.height)")
            print("review2,2,2,2,2,2,2,2,\(reviewViewModel.reviews2)")
            Task{
                storesViewModel.subscribeStores()
            }

            reviewViewModel.fetchReviews()

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
                .padding(.top, 20)
            
        }

    }
    
    
    //MARK: 가게 메뉴정보
    var storeMenu: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack{
                    Text("메뉴")

                    Text("\(store.menu.count)")
                        .foregroundColor(Color("AccentColor"))
                       
                }
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
                    //로그인 안되어있을시 로그인하고 리뷰를 남겨주세요 보여주기, 아니면 아이디와 가게정보의 리뷰를 남겨주세요 보여주기
                    if (currentUser?.uid == nil) {
                        Text("로그인하고 리뷰를 남겨주세요.")
                            .fontWeight(.bold)
                            .padding(.bottom,10)
                    }
                       
                    else {
                        Text("\(userViewModel.userInfo.userNickname)님 '\(store.storeName)'의 리뷰를 남겨주세요! ")
                            .fontWeight(.bold)
                            .padding(.bottom,10)
                    }
                       
                    
                    
                    GgakdugiRatingWide(selected: selectedStar, size: 40, spacing: 15) { ggakdugi in
                        self.selectedStar = ggakdugi
                        showingCreateRewviewSheet.toggle()
                    }
                }
                .padding(.top, 10)
                .padding(.bottom, 15)
                
                Spacer()
            }
           
            Divider()
                NavigationLink{
                   UserReviewCellDetailView()
                }label:{
                    HStack{
                        Text("방문자 리뷰")
                            .foregroundColor(.black)
                        Text("\(reviewViewModel.reviews2.count)")
                                .foregroundColor(Color("AccentColor"))
            
                        Spacer()
                        Image(systemName: "chevron.forward")
                            .foregroundColor(.gray)
                            .padding(.trailing)
                    }//HStack
                   
                }//NavigationLink
                .padding(.leading)
                .padding(.top)
                .font(.title2.bold())
        
            
        }
        .background(scheme == .light ? .white : .black)
    }
}



//struct DetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailView(starStore: StarStore())
//    }
//}
