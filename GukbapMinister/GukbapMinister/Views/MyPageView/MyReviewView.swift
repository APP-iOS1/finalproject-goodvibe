//
//  MyReviewView.swift
//  GukbapMinister
//
//  Created by 기태욱 on 2023/02/01.
//

import SwiftUI
import FirebaseAuth

struct MyReviewView: View {
    @EnvironmentObject private var reviewVM: ReviewViewModel
    @EnvironmentObject private var userVM: UserViewModel
    
    var body: some View {
        ZStack{
            
            Color.gray.opacity(0.2)
            
            NavigationStack{
                ScrollView(showsIndicators: false) {
                    ForEach(reviewVM.reviews, id: \.self) { review in
                        if(review.userId == userVM.userInfo.id){
                            var reviewImg = reviewVM.reviewImage[review.images?.first ?? ""] ?? UIImage()
                            ReviewCell(reviewData: review, reviewImg: reviewImg)
                            
                        }
                    }
                }
                //.padding(.top, 10)
            }
            
            
            .onAppear{
                userVM.fetchUserInfo(uid: Auth.auth().currentUser?.uid ?? "")
                reviewVM.fetchReviews()
            }
            .refreshable {
                reviewVM.fetchReviews()
            }
        }
        .background(.white)
    }
}



struct ReviewCell : View {
    var reviewData : Review
    var reviewImg : UIImage
    
    var body: some View{
        VStack {
            NavigationLink {
                DetailView()
            } label: {
                VStack {
                    HStack{
                        Text("\(reviewData.nickName)")
                            .foregroundColor(.black)
                            .padding()
                        Spacer()
                        Text("\(reviewData.createdDate)")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .padding()
                    }
                    
                    HStack(spacing: -30){
                        ForEach(0..<5) { index in
                            Image(reviewData.starRating >= index ? "Ggakdugi" : "Ggakdugi.gray")
                                .resizable()
                                .frame(width: 15, height: 15)
                                .padding()
                        }
                        Spacer()
                    }//HStack
                    .padding(.top,-30)
                    
                    if reviewImg != UIImage(){
                        Image(uiImage: reviewImg)
                            .resizable()
                            .frame(width: 75, height: 75)
                            .cornerRadius(6)
                            .padding(.leading, 20)
                    }
                    HStack{
                        Text("\(reviewData.reviewText)")
                            .font(.footnote)
                            .foregroundColor(.black)
                            .padding()
                        
                        Spacer()
                        
                    }
                    
                    //                    Rectangle()
                    //                        .frame(width: 400, height: 10)
                    //                        .foregroundColor(.gray)
                    //                        .opacity(0.20)
                }
                .onAppear {
                    //            collectionVM.isHeart = true
                    //            print("\(#function) : \(cellData.storeImages.first ?? "")")
                }
            }
            
        }
        .background(.white)
    }
}
//struct MyReviewView_Previews: PreviewProvider {
//    static var previews: some View {
//        MyReviewView()
//    }
//}
