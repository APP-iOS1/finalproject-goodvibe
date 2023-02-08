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
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var userViewModel: UserViewModel
    //   @EnvironmentObject var mapViewModel: MapViewModel
    @StateObject private var reviewViewModel: ReviewViewModel = ReviewViewModel()
    @StateObject private var storesViewModel: StoresViewModel = StoresViewModel()
    @ObservedObject var starStore = StarStore()
    //@StateObject private var storeViewModel : StoreViewModel
    @StateObject private var collectionViewModel: CollectionViewModel = CollectionViewModel()
    
    @State private var text: String = ""
    @State private var isBookmarked: Bool = false
    @State private var showingCreateRewviewSheet: Bool = false
    @State private var ggakdugiCount: Int = 0
    
    @State var startOffset: CGFloat = 0
    @State var scrollViewOffset: CGFloat = 0
    @State private var isReviewImageClicked: Bool = false
    let colors: [Color] = [.yellow, .green, .red]
    //let menus: [String : String] = ["국밥" : "9,000원", "술국" : "18,000원", "수육" : "32,000원", "토종순대" : "12,000원"]
    let currentUser = Auth.auth().currentUser
    
    //lineLimit 관련 변수
    @State private var isFirst: Bool = true
    @State private var isExpanded: Bool = false
    @State private var needFoldButton: Bool = true
    @State private var textHeight: CGFloat? = nil
    
    //StoreImageDetailView 전달 변수
    @State private var isshowingStoreImageDetail: Bool = false
    
    
    var store : Store
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                // let width: CGFloat = geo.size.width
                
                
                ScrollView(showsIndicators: false) {
                    
                    ZStack {
                        //배경색
                        Color(uiColor: .white)
                        
                        VStack{
                            
                            //상호명 주소
                            //Store.storeName, Store.storeAddress
                //            storeNameAndAddress
                            
                            //Store.images
                            storeImages
                            
                            //Store.description
                            storeDescription
                            
                            //Store.menu
                            storeMenu
                            
                            userStarRate
                            
                            ForEach(reviewViewModel.reviews) { review in
                                //                                NavigationLink{
                                // 리뷰 섹션 클릭시 뭐할지? 고민중, 우선순위도에서 밀려남                                   ReviewDetailView(reviewViewModel:reviewViewModel, selectedtedReview: review)
                                //                                }label: {
                                if (review.storeName == store.storeName){
                                    UserReview(reviewViewModel: reviewViewModel, scrollViewOffset: $scrollViewOffset, review: review)
                                    
                                    //                                        .contextMenu{
                                    //                                            Button{
                                    //                                                reviewViewModel.removeReview(review: review)
                                    //                                            }label: {
                                    //                                                Text("삭제")
                                    //                                                Image(systemName: "trash")
                                    //                                            }
                                    //                                        }//contextMenu
                                    //   }//NavigationLink
                                }
                                
                            }//FirstForEach
                            
                        }//VStack
                        // .padding(.bottom, 200)
                    }//ZStack
                }//ScrollView
                //                .overlay(
                //                    GeometryReader{ proxy -> Color in
                //                        DispatchQueue.main.async {
                //                            if startOffset == 0 {
                //                                self.startOffset = proxy.frame(in: .global).minY
                //                            }
                //                            let offset = proxy.frame(in: .global).minY
                //                            self .scrollViewOffset = offset - startOffset
                //
                //                            //print("y축 위치 값: \(self.scrollViewOffset)")
                //                        }
                //                        return Color.clear
                //                    })
                
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
    var storeNameAndAddress: some View {
        //상호명 주소
        //Store.storeName, Store.storeAddress
        HStack {
            VStack(alignment: .center){
                
                // .padding(.bottom, 3)
                Text(store.storeAddress)
                    .font(.system(size:15))
                    .foregroundColor(.secondary)
                    .padding(.top,-25)
                
            }
            //                ForEach(mapViewModel.filteredGukbaps, id:\.self) { gukbap in
            //                    HStack(spacing: 2) {
            //                        gukbap.image
            //                            .resizable()
            //                            .scaledToFill()
            //                            .frame(width:28, height: 28)
            //                        Text("\(gukbap.rawValue)")
            //                    }
            //                    .categoryCapsule()
            //                }
            
        }
        .padding(15)
        
        .background(.white)
    }
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
    //MARK: 가게 설명
    var storeDescription: some View {
        
        VStack{
            Text(store.description)
                .font(.system(size:18))
                .frame(width: Screen.maxWidth - 20, height:textHeight)
                .lineSpacing(5)
                .lineLimit(isExpanded ? nil : 2)
            HStack{
                Spacer()
                Button(action: {
                    isExpanded.toggle()
                }){
                    //                    HStack{
                    //                        Text("삭제")
                    //                               .fontWeight(.medium)
                    //                               .font(.system(size:15))
                    //                               .foregroundColor(Color("AccentColor"))
                    //                               .padding(EdgeInsets(top: 0.5, leading: 5, bottom: 0.5, trailing: 5))
                    //                               .overlay(
                    //                                   RoundedRectangle(cornerRadius: 20)
                    //                                    .stroke(Color("AccentColor"), lineWidth: 0.5)
                    //                               )
                    //                                .padding(.trailing,15)
                    //
                    //                    }
                    HStack{
                        if(isExpanded == true) {
                            
                            Text("접기")
                                .fontWeight(.medium)

                            Image(systemName: "chevron.up")
                                .foregroundColor(.black)
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

                                .foregroundColor(.black)
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
                Spacer()
            }
        }
        .animation(.easeInOut, value: store.description)
    }
    
    
    fileprivate struct SizePreference: PreferenceKey {
        static let defaultValue: CGSize = .zero
        static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
    }
    
    //MARK: 가게 메뉴정보
    var storeMenu: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("메뉴")
                    .font(.title2.bold())
                    .padding(.bottom)
                
                ForEach(/*menus.sorted(by: >)*/store.menu.sorted(by: >), id: \.key) {menu, price in
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
        .background(.white)
    }
    
    var userStarRate: some View {
        VStack {
            HStack {
                Spacer()
                VStack {
                    Text("\(userViewModel.userInfo.userNickname) 님의 리뷰를 작성해주세요.")
                        .fontWeight(.bold)
                        .padding(.bottom,10)
                    
                    
                    GgakdugiRatingWide(selected: starStore.selectedStar, size: 45, spacing: 15) { ggakdugi in
                        starStore.selectedStar = ggakdugi
                        showingCreateRewviewSheet.toggle()
                    }
                }
                .padding(.top, 10)
                .padding(.bottom, 15)
                
                Spacer()
            }
            .background(.white)
            
        }
        
    }
}
//MARK: 가게 리뷰
struct UserReview:  View {
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
        VStack{
            
            
            HStack{
                if userViewModel.currentUser?.uid ?? "" == review.userId {
                    Text("\(review.nickName)")
                        .foregroundColor(.black)
                        .fontWeight(.semibold)
                        .padding()
                    
                    Text("(내 리뷰)")
                        .font(.system(size:15))
                        .foregroundColor(.black)
                        .fontWeight(.medium)
                        .padding(.leading,-20)
                }else {
                    Text("\(review.nickName)")
                        .foregroundColor(.black)
                        .fontWeight(.semibold)
                        .padding()
                }
                
                Spacer()
                HStack{
                    Spacer()
                    if userViewModel.currentUser?.uid ?? ""  == review.userId {
                        Button {
                            isDeleteAlert.toggle()
                            
                        } label: {
                            HStack{
                                Text("삭제")
                                    .fontWeight(.medium)
                                    .font(.system(size:15))
                                    .foregroundColor(Color("AccentColor"))
                                    .padding(EdgeInsets(top: 0.5, leading: 5, bottom: 0.5, trailing: 5))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color("AccentColor"), lineWidth: 0.5)
                                    )
                                    .padding(.trailing,15)
                                
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
                
                
            }
            
            HStack(spacing: -30){
                ForEach(0..<5) { index in
                    Image(review.starRating >= index ? "Ggakdugi" : "Ggakdugi.gray")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .padding()
                }
                Text("\(review.createdDate)")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding(.leading,20)
                Spacer()
                if(userViewModel.currentUser?.uid ?? "" != review.userId){
                    Button(action:{
                        isShowingReportView.toggle()
                        
                    }){
                        Text("신고하기")
                            .font(.system(size:12))
                        Image(systemName: "chevron.right")
                            .font(.system(size:7))
                            .padding(.leading, -8)
                    }
                    .padding()
                    .foregroundColor(.secondary)
                }else{
                    Text("")
                }
                
            }//HStack
            .padding(.top,-35)
            
            
            
            
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
                    .foregroundColor(.black)
                    .padding()
                Spacer()
            }
            
            Divider()
        }//VStack
        //"부적절한 리뷰 신고하기" 작성하는 sheet로 이동
        .fullScreenCover(isPresented: $isShowingReportView) {
            ReportView(isshowingReportSheet: $isShowingReportView, selectedReportButton: $selectedReportButton, reportEnter: $reportEnter)
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

