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
    @State private var ggakdugiCount: Int = 0
    
    @State var startOffset: CGFloat = 0
    @State var scrollViewOffset: CGFloat = 0
    
    let colors: [Color] = [.yellow, .green, .red]
    let menus: [String : String] = ["국밥" : "9,000원", "술국" : "18,000원", "수육" : "32,000원", "토종순대" : "12,000원"]
    
    
    //lineLimit 관련 변수
    @State private var isExpanded: Bool = false
//    @State private var truncated: Bool = false
//    @State private var shrinkText: String
//
//    let font: UIFont
//    let lineLimit: Int
//
//    private var moreLessText: String {
//            if !truncated {
//                return ""
//            } else {
//                return self.isExpanded ? " 접기 " : " 더보기 "
//            }
//        }

    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                let width: CGFloat = geo.size.width
              
                ScrollView {
                    ZStack {
                        //배경색
                        Color(uiColor: .white)
                        
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
                          
                            ForEach(reviewViewModel.reviews) { review in
                                NavigationLink{
                                    ReviewDetailView(reviewViewModel:reviewViewModel, selectedtedReview: review)
                                }label: {
                                    UserReview(reviewViewModel: reviewViewModel, scrollViewOffset: $scrollViewOffset, index: 2, review: review)
                                    
                                        .contextMenu{
                                            Button{
                                                reviewViewModel.removeReview(review: review)
                                            }label: {
                                                Text("삭제")
                                                Image(systemName: "trash")
                                            }
                                        }//contextMenu
                                }//NavigationLink
                                
                            }//FirstForEach
                            
                        }//VStack
                       // .padding(.bottom, 200)
                    }//ZStack
                }//ScrollView
                .overlay(
                    GeometryReader{ proxy -> Color in
                        DispatchQueue.main.async {
                            if startOffset == 0 {
                                self.startOffset = proxy.frame(in: .global).minY
                            }
                            let offset = proxy.frame(in: .global).minY
                            self .scrollViewOffset = offset - startOffset

                        //print("y축 위치 값: \(self.scrollViewOffset)")
                        }
                        return Color.clear
                    })
                
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
        .fullScreenCover(isPresented: $showingAddingSheet) {
            CreateReviewView(reviewViewModel: reviewViewModel, starStore: starStore,showingSheet: $showingAddingSheet )
        }
        .onAppear{
            reviewViewModel.fetchReviews()
            print("리뷰 이미지\(reviewViewModel.reviewImage)")
        }
//        .onDisappear{
//            reviewViewModel.fetchReviews()
//        }
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
            Group {
                Text("수요미식회에서 인정한 선릉역 찐 맛집! 이래도 안 먹을 것인지? 먹어주시겄어요? 제발제발! 줄은 서지만 기다릴만한 가치가 있는 맛집이입니다. 수요미식회에서 인정한 선릉역 찐 맛집! 이래도 안 먹을 것인지? ")
                }

            .lineLimit(isExpanded ? nil : 2)
            
            //.overlay가 문제인것을 알겠다.
                .overlay(
                    GeometryReader { proxy in
                        Button(action: {
                            isExpanded.toggle()
                        }) {
                            Text(isExpanded ? "접기" : "더보기")
                                .font(.caption).bold()
//                                .background(Color.white)
                                .foregroundColor(.blue)
                                .padding(.leading, 8.0)
                                .padding(.top, 4.0)
                        }
                        .frame(width: proxy.size.width, height: proxy.size.height+15, alignment: .bottomTrailing)
                    }
                )
            
//            if truncated {
//                            Button(action: {
//                                isExpanded.toggle()
//                            }, label: {
//                                HStack {
//                                    Spacer()
//                                    Text("")
//                                }.opacity(0)
//                            })
//                        }
            
                .lineLimit(10)
                .padding(.horizontal, 15)
                .padding(.vertical, 30)
            Divider()
        }
//        .background(Color.red)
    }
    
    var storeMenu: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("메뉴")
                    .font(.title2.bold())
                    .padding(.bottom)
                
                ForEach(menus.sorted(by: >), id: \.key) {menu, price in
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
                Text("테디베어님의 후기를 남겨주세요")
                    .fontWeight(.bold)
                
                Spacer()
                
                //별 재사용 예정
                
                GgakdugiRatingWide(selected: starStore.selectedStar, size: 40, spacing: 15) { ggakdugi in
                    starStore.selectedStar = ggakdugi
                    showingAddingSheet.toggle()
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
    
    var index: Int
    var review: Review
    
    var body: some View {
        VStack{
            HStack{
                Text("\(review.nickName)")
                    .foregroundColor(.black)
                    .padding()
                Spacer()
                Text("\(review.createdDate)")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding()
            }
            
            HStack(spacing: -30){
                ForEach(0..<5) { index in
                    Image(review.starRating >= index ? "Ggakdugi" : "Ggakdugi.gray")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .padding()
                }
                Spacer()
            }//HStack
            .padding(.top,-30)
                                
                ScrollView(.horizontal, showsIndicators: false){
                    HStack{
                        ForEach(Array(review.images!.enumerated()), id: \.offset) { index, imageData in
                                if let image = reviewViewModel.reviewImage[imageData] {
                                    
                                        Image(uiImage: image)
                                            .resizable()
                                            .frame(width: 180,height: 160)
                                            .cornerRadius(10)
                                    
                                            .overlay() {
                                                if ((review.images?.count ?? 0) > 2)  && index == 1 {
                                                    
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .fill(Color.black.opacity(0.2))
                                                    
                                                    let remainImages = (review.images?.count ?? 0) - 2
                                                    if -scrollViewOffset == 0 {
                                                        
                                                        Text("+\(remainImages)")
                                                            .font(.title)
                                                            .fontWeight(.heavy)
                                                            .foregroundColor(.white)
                                                    }
                                                }//Second 'if'
                                            }//overlay
                                }//if let

                            }// ForEach(review.images)
                    }
                }//scrollView
                .padding(.top,-15)
                .padding(.leading,15)
          
            HStack{
                Text("\(review.reviewText)")
                    .font(.footnote)
                    .foregroundColor(.black)
                    .padding()
                Spacer()
            }
            
            Divider()
        }//VStack
    }
}







struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(starStore: StarStore())
    }
}

