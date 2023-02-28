//
//  MyReviewView.swift
//  GukbapMinister
//
//  Created by 기태욱 on 2023/02/01.
//
import SwiftUI
import FirebaseAuth

struct MyReviewView: View {
    @Environment(\.dismiss) var dismiss

    @StateObject private var reviewVM = ReviewViewModel()
    @EnvironmentObject private var userVM: UserViewModel
    //@StateObject private var storeVM : StoreViewModel

    // 디테일뷰를 보여줘야하는데 어떤 디테일뷰를 말하는지 살짞 이해가 되지 않음?
    var body: some View {
        VStack{
            NavigationStack{
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0){
                        // review 컬렉션의 유저 아이디와 현재 유저 아이디를 비교하여 같으면 '내가 쓴 리뷰'로 보여준다
                        ForEach(reviewVM.reviews, id: \.self) { review in
                            if(review.userId == userVM.userInfo.id){
                                UserReviewCell(reviewViewModel: reviewVM, review: review, isInMypage: true)
                                    
                            }
                        }
                    }
                }
                .navigationBarTitle("내가 쓴 리뷰보기", displayMode: .inline)
            }
            .onAppear{
                userVM.fetchUserInfo(uid: Auth.auth().currentUser?.uid ?? "")
              //  reviewVM.fetchReviews()
            }
            .refreshable {
               // reviewVM.fetchReviews()
            }
            
            
            Button {
                dismiss()
            } label: {
                Text("뒤로")
            }
        }
    }
}



struct ReviewCell : View {
    var reviewData : Review
    var reviewImg : UIImage
    
    var body: some View{
        VStack {
//            NavigationLink {
//                //DetailView()
//            } label: {
                VStack{
                    

                    HStack{
                        Text("\(reviewData.nickName)")
                            .foregroundColor(.black)
                            .font(.caption)
                            .bold()
                            .padding()
                        Spacer()
                        Text("\(reviewData.createdDate)")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .padding()
                    }
                    VStack(alignment: .leading){
                        Text("\(reviewData.storeName)")
                            .foregroundColor(.black)
                            .padding(.leading)
                        HStack(spacing: -30){
                            ForEach(0..<5) { index in
                                Image(reviewData.starRating >= index ? "Ggakdugi" : "Ggakdugi.gray")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                    .padding()
                            }
                            Spacer()
                        }//HStack
                        .padding(.top,-25)
                    }
                    if reviewImg != UIImage(){
                        Image(uiImage: reviewImg)
                            .resizable()
                            .frame(width: 75, height: 75)
                            .cornerRadius(6)
                            .padding(.leading, 20)
                    }
                    HStack{
                        Text("\(reviewData.reviewText)")
                            .font(.caption)
                            .foregroundColor(.black)
                            .padding()
                        
                        Spacer()
                        
                    }
                    
                    Divider()

                }
            
           //}
            
        }
        .background(.white)
    }
}
//struct MyReviewView_Previews: PreviewProvider {
//    static var previews: some View {
//        MyReviewView()
//    }
//}
