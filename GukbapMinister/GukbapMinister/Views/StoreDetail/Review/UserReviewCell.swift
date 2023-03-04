//
//  UserReviewCell.swift
//  GukbapMinister
//
//  Created by Martin on 2023/02/14.
//
import SwiftUI
import Kingfisher

//MARK: 가게 리뷰
struct UserReviewCell:  View {
    @Environment(\.colorScheme) var scheme
    
    @StateObject var reviewViewModel: ReviewViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    
    
    @State private var isShowingReportView = false
    @State private var isshowingReviewDetailView = false
    @State var reportEnter = false
    @State var selectedReportButton = ""
    
    //리뷰 삭제 알림
    @State private var isDeleteAlert: Bool = false
    
    var review: Review
    var isInMypage: Bool = false
    var body: some View {
        VStack(spacing: 0){
            
            HStack(spacing: 0){
                
                Text("\(review.nickName)")
                    .foregroundColor(.black)
                    .fontWeight(.semibold)
                    .padding(.vertical)
                //                        .padding(.leading)
                
                if (userViewModel.currentUser?.uid ?? "" == review.userId) && !isInMypage {
                    Text("(내 리뷰)")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                }
                Text(" 리뷰 \(userViewModel.userInfo.reviewCount)")
                    .foregroundColor(.secondary)
                    .font(.caption2)
                
                if isInMypage {
                    Text("\(review.storeName)")
                        .font(.caption)
                        .foregroundColor(scheme == .light ? .secondary : .white)
                        .padding(.leading, 5)
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
                            Task {
                                await reviewViewModel.removeReview(review: review)
                            }
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
                    .padding(.trailing)
                    .foregroundColor(.secondary)
                }
                
            }//HStack
            .padding(.leading)
            .padding(.trailing, 5)
            .padding(.top, -10)

            let columns = Array(repeating: GridItem(.flexible(),spacing: -8), count: 2)
            LazyVGrid(columns: columns, alignment: .leading, spacing: 4, content: {
                
                //                ForEach(Array(review.images!.enumerated()), id: \.offset) { index, imageData in
                //                    Button(action:{
                //                        isshowingReviewDetailView.toggle()
                //                    }){
                //                        if let image = reviewViewModel.reviewImage[imageData] {
                //
                //                            Image(uiImage: image)
                //                                .resizable()
                //                                .aspectRatio(contentMode: .fill)
                //                                .frame(width: getWidth(index: index), height: getHeight(index: index))
                //                                .cornerRadius(5)
                //                        }//if let
                //                    }
                //
                //                }
                //                // ForEach(review.images)
                //
                //
                //            })
                ForEach(Array(review.images!.enumerated()), id: \.offset) { index, imageURL in
                    Button(action:{
                        isshowingReviewDetailView.toggle()
                    }){
                        KFImage(reviewViewModel.reviewImageURLs[imageURL])
                            .placeholder{
                                ProgressView()
                            }
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: getWidth(index: index), height: getHeight(index: index))
                            .cornerRadius(5)
                    }
                    
                }
                // ForEach(review.images)
                
                
            })
            .padding(.leading,10)
            .padding(.top)
            
            
            HStack{
                Text("\(review.reviewText)")
                    .foregroundColor(.black)
                    .font(.body)
                    .padding()
                Spacer()
            }
            
            Divider()
        }//VStack
        .onAppear{
            //            userViewModel.fetchUpdateUserInfo()
            
        }
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
        let width = getRect().width * 0.9347
        
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
        let height = getRect().height * 0.33
        
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
