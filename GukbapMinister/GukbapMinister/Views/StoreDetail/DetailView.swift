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
                                UserReview(reviewViewModel: reviewViewModel, scrollViewOffset: $scrollViewOffset, review: review)
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
                                .tint(.black)
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
            reviewViewModel.fetchReviews()
        }
        .onDisappear {
            storesViewModel.unsubscribeStores()
        }
        .refreshable {
            reviewViewModel.fetchReviews()
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
            HStack{
                Spacer()
                Button(action: {
                    isExpanded.toggle()
                }){
                    HStack{
                        if isExpanded {
                            Text("접기")
                                .fontWeight(.medium)
                            
                            Image(systemName: "chevron.up")
                                .fontWeight(.medium)
                                .font(.system(size:15))
                                .foregroundColor(Color(.black))
                                .padding(EdgeInsets(top: 2, leading: 5, bottom: 2, trailing: 5))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color(.black), lineWidth: 0.5)
                                )
                                .padding(.trailing,15)
                            
                            
                            
                        }else {
                            Text("더보기")
                                .fontWeight(.medium)
                            
                            Image(systemName: "chevron.down")
                                .fontWeight(.medium)
                                .font(.system(size:15))
                                .foregroundColor(Color(.black))
                                .padding(EdgeInsets(top: 2, leading: 5, bottom: 2, trailing: 5))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color(.black), lineWidth: 0.5)
                                )
                                .padding(.trailing,15)
                            
                        }
                    }
                    .foregroundColor(.black)
                    
                }
                .foregroundColor(scheme == .light ? .black : .white)
                Spacer()
            }
        }
        .animation(.easeInOut, value: store.description)
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
//MARK: 가게 리뷰
struct UserReview:  View {
    @Environment(\.colorScheme) var scheme
    
    @StateObject var reviewViewModel: ReviewViewModel
    @ObservedObject var starStore = StarStore()
    @Binding var scrollViewOffset: CGFloat
    @State private var isShowingReportView = false
    @State var selectedReportButton = ""
    @State var reportEnter = false
    @EnvironmentObject var userViewModel: UserViewModel
    
    @State private var isshowingReviewDetailView = false
    
    //리뷰 삭제 알림
    @State private var isDeleteAlert: Bool = false
    
    var review: Review
    
    var body: some View {
        VStack(spacing: 0){
            HStack(spacing: 0){
                Text("\(review.nickName)")
                        .fontWeight(.semibold)
                        .padding(.vertical)
//                        .padding(.leading)
                    
                if userViewModel.currentUser?.uid ?? "" == review.userId {
                    Text("(내 리뷰)")
                        .fontWeight(.medium)
                }
                
                Spacer()
                
                if userViewModel.currentUser?.uid ?? "" == review.userId {
                    Button {
                        isDeleteAlert.toggle()
                        
                    } label: {
                        HStack{
                            Text("삭제")
                                .font(.footnote)
                                .fontWeight(.thin)
                                .padding(EdgeInsets(top: 2.5, leading: 6.5, bottom: 2.5, trailing: 6.5))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.secondary, lineWidth: 0.5)
                                    
                                )
                            
                        }
                        
                    }
                    .alert(isPresented: $isDeleteAlert) {
                        Alert(title: Text(""),
                              message: Text("리뷰를 삭제하시겠습니까?"),
                              primaryButton: .destructive(Text("확인"),
                                                          action: {
                            reviewViewModel.removeReview(review: review)
                        }), secondaryButton: .cancel(Text("닫기")))
                    }
                    
                }
                
                
                
                
            }
            .padding(.horizontal, 15)
            
            HStack {
                GgakdugiRatingWide(selected: review.starRating - 1, size: 15, spacing: 2) { _ in
                }
                Text("\(review.createdDate)")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                
                Spacer()
                if(userViewModel.currentUser?.uid ?? "" != review.userId){
                    Button(action:{
                        isShowingReportView.toggle()
                        
                    }){
                        Text("신고하기")
                            .font(.system(size:12))
                        Image(systemName: "chevron.right")
                            .font(.system(size:7))
                    }
                    .padding()
                    .foregroundColor(.secondary)
                }
                
            }//HStack
            .padding(.leading)
            .padding(.trailing, 5)
            .padding(.top, -10)
            
            
            
            
            let columns = Array(repeating: GridItem(.flexible(),spacing: -8), count: 2)
            LazyVGrid(columns: columns, alignment: .leading, spacing: 4, content: {
                
                ForEach(Array(review.images!.enumerated()), id: \.offset) { index, imageData in
                    Button(action:{
                        isshowingReviewDetailView.toggle()
                    }){
                        if let image = reviewViewModel.reviewImage[imageData] {
                            
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: getWidth(index: index), height: getHeight(index: index))
                                .cornerRadius(5)
                        }//if let
                    }
                    
                }
                // ForEach(review.images)
                
                
            })
            
            .padding(.leading,10)
            .padding(.top,-15)
            
            
            HStack{
                Text("\(review.reviewText)")
                    .font(.system(size:17))
                    .padding()
                Spacer()
            }
            
            Divider()
        }//VStack
        //"부적절한 리뷰 신고하기" 작성하는 sheet로 이동
        .fullScreenCover(isPresented: $isShowingReportView) {
            ReportView(isshowingReportSheet: $isShowingReportView, selectedReportButton: $selectedReportButton, reportEnter: $reportEnter, review: review)
        }
        //리뷰 이미지 크게 보이는 sheet로 이동
        .fullScreenCover(isPresented: $isshowingReviewDetailView) {
            ReviewDetailView(reviewViewModel: reviewViewModel,selectedtedReview: review, isShowingReviewDetailView: $isshowingReviewDetailView)
            
        }
    }
    func getWidth(index:Int) -> CGFloat{
        let width = getRect().width - 25
        
        if (review.images?.count ?? 0) % 2 == 0{
            return width / 2
        }
        
        else{
            if index == (review.images?.count ?? 0) - 1 {
                return width + 5
            }
            else{
                return width / 2
                
            }
        }
    }
    func getHeight(index:Int) -> CGFloat{
        let height = getRect().height - 544
        
        if (review.images?.count ?? 0) == 1{
            return height
        }
        else if (review.images?.count ?? 0) == 2 {
            return height
        }
        else if (review.images?.count ?? 0) == 3 {
            return height / 2
        }
        else if (review.images?.count ?? 0) == 4 {
            return height / 2
        }
        else{
            if index == (review.images?.count ?? 0) - 1 {
                return height
            }
            else{ return height / 2
                
            }
        }
    }
}



extension View {
    func getRect()->CGRect{
        return UIScreen.main.bounds
    }
}


//struct DetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailView(starStore: StarStore())
//    }
//}

