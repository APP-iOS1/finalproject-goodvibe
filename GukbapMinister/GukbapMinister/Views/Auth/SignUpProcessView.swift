//
//  SignUpProcessView.swift
//  GukbapMinister
//
//  Created by 전혜성 on 2023/01/18.
//

import SwiftUI

struct SignUpProcessView: View {
    
    var index: Int
    
    var body: some View {
        HStack(spacing: 0) {
            Circle()
                .fill(index == 1 ? Color("AccentColor") : .gray)
                .frame(width: 19, height: 19)
                .overlay {
                    Text(index == 1 ? "\(index)" : "")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.bold)
                }
            Rectangle()
                .fill(Color.gray)
                .frame(width: 28, height: 2)
            Circle()
                .fill(index == 2 ? Color("AccentColor") : .gray)
                .frame(width: 19, height: 19)
                .overlay {
                    Text(index == 2 ? "\(index)" : "")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.bold)
                }
            Rectangle()
                .fill(Color.gray)
                .frame(width: 28, height: 2)
            Circle()
                .fill(index == 3 ? Color("AccentColor") : .gray)
                .frame(width: 19, height: 19)
                .overlay {
                    Text(index == 3 ? "\(index)" : "")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.bold)
                }
        }
        .padding(30)
        .animation(Animation.easeInOut(duration: 0.5), value: index)
    }
    
}

//struct SignUpProcessView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignUpProcessView()
//    }
//}
