//
//  CommentUnit.swift
//  GukbapMinister
//
//  Created by Martin on 2023/01/17.
//

import SwiftUI

struct CommentUnit: View {
    var nickname: String = "써니"
    var date: String = "2023.01.17"
    var starRate: Double = 3.5
    var comment: String = "여기 외 않와? 꼭 가세요"
    var images: [String] = ["Test"]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(nickname)
                    .font(.headline)
                    .padding(.bottom, 10)
                Spacer()
                Text(date)
                    .font(.caption)
                    .foregroundColor(.gray)
                
            }
            //별점
            HStack(spacing: 0){
                ForEach(1..<6) { index in
                    let indexToDouble = Double(index)
                    if indexToDouble <= starRate {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)
                            .padding(.trailing, 2)
                    } else if indexToDouble == starRate + 0.5 {
                        Image(systemName: "star.leadinghalf.filled")
                            .foregroundColor(.yellow)
                            .font(.caption)
                            .padding(.trailing, 2)
                    } else {
                        Image(systemName: "star")
                            .foregroundColor(.yellow)
                            .font(.caption)
                            .padding(.trailing, 2)
                    }
                }
            }
            .padding(.bottom, 15)
            
            Text(comment)
                .lineLimit(3)
                .font(.footnote)
                .padding(.bottom, 15)
            
            if images.count > 0 {
                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach(Array(images.enumerated()), id: \.offset) { (index, image) in
                            Text("\(index)")
                                .frame(width: 100, height: 100)
                                .background(.yellow)
                        }
                    }
                    
                }
                .scrollIndicators(.hidden)
                .frame(height:100)
            }
            
        }
        .padding()
        .background(.white)
    }
}

struct CommentUnit_Previews: PreviewProvider {
    static var previews: some View {
        CommentUnit()
    }
}
