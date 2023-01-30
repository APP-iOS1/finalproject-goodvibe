//
//  ReviewDetailView.swift
//  GukbapMinister
//
//  Created by 이원형 on 2023/01/20.
//

import SwiftUI

struct ReviewDetailView: View {
    @StateObject var reviewViewModel: ReviewViewModel
    let selectedtedReview: Review
//
//    init(){
//        UIScrollView.appearance().bounces = false
//    }
    var body: some View {
        VStack{
            if let images = selectedtedReview.images{
                TabView() {
                   
                        ForEach(images, id: \.self) { imageKey in
                            if let image = reviewViewModel.reviewImage[imageKey] {
                                Image(uiImage: image)
                                    .resizable()
                                   // .scaledToFit()
                            }
                        }//ForEach
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode:.always))
                .frame(width: UIScreen.main.bounds.width)
            }
            VStack{
                Text(selectedtedReview.createdDate)
                    .fontWeight(.light)
                Text(selectedtedReview.reviewText)
                    .font(.title2)
                
            }
            Spacer()
        }
    }
}

//struct ReviewDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReviewDetailView()
//    }
//}
