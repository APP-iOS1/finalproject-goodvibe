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
    @EnvironmentObject var mapViewModel: MapViewModel
    @StateObject private var reviewViewModel: ReviewViewModel = ReviewViewModel()
    @StateObject private var storesViewModel: StoresViewModel = StoresViewModel()
    @ObservedObject var starStore = StarStore()
    
    @State private var text: String = ""
    @State private var isBookmarked: Bool = false
    @State private var showingCreateRewviewSheet: Bool = false
    @State private var ggakdugiCount: Int = 0
    
    @State var startOffset: CGFloat = 0
    @State var scrollViewOffset: CGFloat = 0
    @State private var isReviewImageClicked: Bool = false
    
    let colors: [Color] = [.yellow, .green, .red]
    //let menus: [String : String] = ["국밥" : "9,000원", "술국" : "18,000원", "수육" : "32,000원", "토종순대" : "12,000원"]
    
    
    //lineLimit 관련 변수
    @State private var isFirst: Bool = true
    @State private var isExpanded: Bool = false
    @State private var needFoldButton: Bool = true
    @State private var textHeight: CGFloat? = nil
    
    
    
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
                            storeNameAndAddress
                            
                            //Store.images
                            storeImages
                            
                            //Store.description
                            storeDescription
                            
                            //Store.menu
                            storeMenu
                            
                            // refactoring으로 인한 일시 주석처리
                            //                            NaverMapView(coordination: (37.503693, 127.053033), marked: .constant(false), marked2: .constant(false))
                            //                                .frame(height: 260)
                            //                                .padding(.vertical, 15)
                            
                            userStarRate
                            
                            ForEach(reviewViewModel.reviews) { review in
                                //                                NavigationLink{
                                //                                    ReviewDetailView(reviewViewModel:reviewViewModel, selectedtedReview: review)
                                //                                }label: {
                                if (review.storeName == store.storeName){
                                    UserReview(reviewViewModel: reviewViewModel, scrollViewOffset: $scrollViewOffset, review: review)
                                    //
                                        .contextMenu{
                                            Button{
                                                reviewViewModel.removeReview(review: review)
                                            }label: {
                                                Text("삭제")
                                                Image(systemName: "trash")
                                            }
                                        }//contextMenu
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
                            isBookmarked.toggle()
                        } label: {
                            Image(systemName: isBookmarked ? "heart.fill" : "heart")
                                .tint(.red)
                        }
                    }
                }
            }//GeometryReader
        }//NavigationStack
        //리뷰 작성하는 sheet로 이동
        .fullScreenCover(isPresented: $showingCreateRewviewSheet) {
            CreateReviewView(reviewViewModel: reviewViewModel, starStore: starStore,showingSheet: $showingCreateRewviewSheet, store: store )
        }
       
        .onAppear{
            Task{
                storesViewModel.subscribeStores()
                print("스토어뷰모델\(storesViewModel.storeTitleImage)")
                
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
                Text(store.storeName)
                    .font(.title.bold())
                    .padding(.top, -52)
                // .padding(.bottom, 3)
                Text(store.storeAddress)
                
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
    var storeImages: some View {
        TabView {
            ForEach(storesViewModel.stores, id: \.self){ store in
                let imageData = storesViewModel.storeTitleImage[store.storeImages.first ?? ""] ?? UIImage()
                Image(uiImage: imageData)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
        
        .frame(height:Screen.maxWidth * 0.8)
        .tabViewStyle(.page(indexDisplayMode: .always))
        
    }
    
    var storeDescription: some View {
        VStack(alignment: .leading) {
            Group {
                Text("동해물과 백두산이 마르고 닳도록 하느님이 보우하사 우리나라 만세 무궁화 삼천리 화려강산 대한사람 대한으로 길이 보전하세 남산위에 저 소나무 철갑을 두른 듯 바람서리 불변함은 우리 기상일세 무궁화 삼천리 화려강산 대한사람 대한으로 길이보전하세  ")
                //                Text(store.description)
                //                    .fixedSize(horizontal: false, vertical: true)
                    .frame(height: textHeight)
                    .background(GeometryReader {geometry in
                        Color.clear.preference(key: SizePreference.self, value: geometry.size)
                    })
            }
            //            .lineLimit(isExpanded ? nil : 2)
            .onPreferenceChange(SizePreference.self) { textSize in
                if self.isFirst == true {
                    if textSize.height > 40 {
                        self.textHeight = 40
                        self.isExpanded = true
                        self.isFirst = false
                    } else {
                        self.needFoldButton = false
                    }
                }
            }
            
            HStack {
                Spacer()
                if needFoldButton {
                    Button(action: {
                        self.isExpanded.toggle()
                        if self.isExpanded == true {
                            self.textHeight = 40
                        } else {
                            self.textHeight = nil
                        }
                    }) {
                        Text(isExpanded ? "더보기" : "접기")
                    }
                    .padding(.trailing, 8)
                }
            }
            
            
            //            HStack {
            //                Spacer()
            //                    .overlay(
            //                        GeometryReader { proxy in
            //                            // store.desceiption 이 한줄일 경우 더보기/접기 버튼 hidden 하는 것 만들어야함.-0205 JS
            //                            if needFoldButton {
            //                                Button(action: {
            //                                    isExpanded.toggle()
            //                                }) {
            //                                    Text(isExpanded ? "접기" : "더보기")
            //                                        .font(.caption).bold()
            //                                        .foregroundColor(.blue)
            //                                        .padding(.leading, 8.0)
            //                                        .padding(.top, 4.0)
            //                                }
            //                                .frame(width: proxy.size.width, height: proxy.size.height+30, alignment: .bottomTrailing)
            //
            //                            }
            //
            //                        }
            //                    )
            //
            //            }
            
            Divider()
        }
        .background(Color.red)
        .padding(.horizontal, 15)
        .padding(.vertical, 30)
    }
    
    
    fileprivate struct SizePreference: PreferenceKey {
        static let defaultValue: CGSize = .zero
        static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
    }
    
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
        HStack {
            Spacer()
            VStack {
                Text("\(userViewModel.userInfo.userNickname) 님의 리뷰를 작성해주세요.")
                    .fontWeight(.bold)
                
                Spacer()
                
                //별 재사용 예정
                
                GgakdugiRatingWide(selected: starStore.selectedStar, size: 40, spacing: 15) { ggakdugi in
                    starStore.selectedStar = ggakdugi
                    showingCreateRewviewSheet.toggle()
                }
            }
            .padding(.vertical, 30)
            
            Spacer()
        }
        .background(.white)
    }
}

struct UserReview:  View {
    @StateObject var reviewViewModel: ReviewViewModel
    @ObservedObject var starStore = StarStore()
    @Binding var scrollViewOffset: CGFloat
    @State private var showingReportSheet = false
    @State var selectedReportButton = ""
    @State var show = false
    var review: Review
    
    var body: some View {
        VStack{
            HStack{
                Text("\(review.nickName)")
                    .foregroundColor(.black)
                    .fontWeight(.semibold)
                    .padding()
                Spacer()
                
                Button(action:{
                    showingReportSheet.toggle()
                    print("\(showingReportSheet)")
                    
                }){
                    Text("신고하기")
                        .font(.system(size:12))
                    Image(systemName: "chevron.right")
                        .font(.system(size:7))
                        .padding(.leading, -8)
                }
                .padding()
                .foregroundColor(.secondary)
                
            }
            
            HStack(spacing: -30){
                ForEach(0..<5) { index in
                    Image(review.starRating >= index ? "Ggakdugi" : "Ggakdugi.gray")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .padding()
                }
                Spacer()
                Text("\(review.createdDate)")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding()
                
            }//HStack
            .padding(.top,-30)
            
            
            
            
            let columns = Array(repeating: GridItem(.flexible(),spacing: -8), count: 2)
            LazyVGrid(columns: columns, alignment: .leading, spacing: 4, content: {
                
                ForEach(Array(review.images!.enumerated()), id: \.offset) { index, imageData in
                    
                    
                    NavigationLink{
                        ReviewDetailView(reviewViewModel: reviewViewModel,selectedtedReview: review)
                    } label:{
                        if let image = reviewViewModel.reviewImage[imageData] {
                            
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: getWidth(index: index), height: getHeight(index: index))
                                .cornerRadius(5)
                        }//if let
                    }
                    
                    
                    
                    
                }// ForEach(review.images)
                
                
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
        .fullScreenCover(isPresented: $showingReportSheet) {
            ReportView(isshowingReportSheet: $showingReportSheet, selectedReportButton: $selectedReportButton, show: $show)
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

