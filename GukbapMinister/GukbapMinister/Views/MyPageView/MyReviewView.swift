//
//  MyReviewView.swift
//  GukbapMinister
//
//  Created by 기태욱 on 2023/02/01.
//
import SwiftUI
import FirebaseAuth

struct MyReviewView: View {
    @StateObject private var reviewVM = ReviewViewModel()
    @EnvironmentObject private var userVM: UserViewModel
    //@StateObject private var storeVM : StoreViewModel
    @StateObject private var collectionVM: CollectionViewModel = CollectionViewModel()
    @EnvironmentObject private var storesViewModel: StoresViewModel
    
    var MyReview : [Review] {
        reviewVM.reviews2.filter{
            $0.userId == userVM.userInfo.id
        }
    }
    var body: some View {
        VStack{
            NavigationStack{
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 0){

                        if !self.MyReview.isEmpty {
                            ForEach(Array(MyReview.enumerated()), id: \.offset) { index, review in
                                NavigationLink {
                                    //내가쓴 리뷰의 상호와 디테일뷰 스토어네임 비교해서 같은조건인것으로 걸러서 보여주기
                                    //storeName 비교 하여 디테일뷰 가져오기
                                    ForEach(storesViewModel.stores, id: \.self) { store in
                                        if(review.storeName == store.storeName) {
                                            DetailView(detailViewModel: DetailViewModel(store: store))
                                        }
                                        
                                    }
                                    
                                } label: {
                                    UserReviewCell(reviewViewModel: reviewVM, review: review, isInMypage: true)
                                        .onAppear(){
                                   
                                            if (index == MyReview.count) || (index < MyReview.count) {
                                                if index == MyReview.count - 1{
                                                    if ((self.MyReview.last?.id) != nil) == true {
                                                        
                                                    }
                                                    reviewVM.updateReviews()
                                                    print("\(index+1)번째 리뷰 데이터 로딩중")
                                                }
                                            }
                                         
                                        
                                        }
                                
                                }
                                
                            }
                        }else {
//                                Image("Image")
//                                    .resizable()
//                                    .frame(width: UIScreen.main.bounds.width * 0.53,
//                                           height: UIScreen.main.bounds.height * 0.25 )
                     
                                    Text("작성된 리뷰가 없습니다.")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.secondary)
                                        .padding(.top,300)
                       
                        }
                        }

}
                }
                .navigationBarTitle("내가 쓴 리뷰보기", displayMode: .inline)
            }
            .onAppear{

//                userVM.fetchUserInfo(uid: Auth.auth().currentUser?.uid ?? "")
                reviewVM.fetchReviews()
            }
            .refreshable {
               // reviewVM.fetchReviews()
            }
            
        }
    }




