//
//  ReviewDetailView.swift
//  GukbapMinister
//
//  Created by 이원형 on 2023/01/20.
//

import SwiftUI
import Kingfisher
struct ReviewDetailView: View {
    
    @StateObject var reviewViewModel: ReviewViewModel
    let selectedtedReview: Review
    @Binding var isShowingReviewDetailView : Bool

    //
    //    init(){
    //        UIScrollView.appearance().bounces = false
    //    }

    var body: some View {
        NavigationStack{
            ZStack{
                Color.black
                    .ignoresSafeArea()
                VStack{
                    
                    
                    if let images = selectedtedReview.images{
                        TabView {
                            
                            ForEach(images, id: \.self) { imageKey in
                                Button(action:{
                                    isShowingReviewDetailView.toggle()
                                }){
                                    KFImage(reviewViewModel.reviewImageURLs[imageKey])
                                        .placeholder{
                                            ProgressView()
                                        }
                                        .resizable()
                                        .scaledToFit()
                            
                                }
                            
                            }//ForEach
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode:.always))
                        .frame(width: UIScreen.main.bounds.width)
                        .padding(.top,-80)
                    }
                    VStack{
                        
                        Text(selectedtedReview.reviewText)
                            .font(.body)
                        
                    }
                    .foregroundColor(.white)
                    Spacer()
                }
            }
            //.navigationTitle(Text("/\(selectedtedReview.images!.count)"))



            
            .toolbar(.hidden, for:.tabBar)
            
            .navigationBarBackButtonHidden(true)
            .toolbar {
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isShowingReviewDetailView.toggle()
                    } label: {
                        Image(systemName: "xmark")
                            .tint(.white)
                    }
                    
                }
              
            }
            
       
               
        }
    }
       
}
