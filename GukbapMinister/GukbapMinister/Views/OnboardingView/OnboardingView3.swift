//
//  OnboardingView3.swift
//  GukbapMinister
//
//  Created by ㅇㅇ on 2023/02/09.
//

import SwiftUI

struct OnboardingView3: View {
    @Binding var isFirstLaunching: Bool
    var body: some View {
        ZStack{
            Color.mainColor.ignoresSafeArea()
            VStack{
                Image("1")
                    .padding(.top, 100)
                Text("맛집을 많이 알려주시고 리뷰도 많이 달아주세요!")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding()
                Text("계급이 올라가면 특별한 선물을 드립니다")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding()
                
                Button {
                    isFirstLaunching.toggle()
                } label: {
                    Text("입장하기")
                        .foregroundColor(.accentColor)
                }
                .font(.title3)
                .fontWeight(.bold)
                .frame(width: 340, height: 60)
                .background(Color.white)
                .cornerRadius(5)
                .padding(.bottom, 180)
                Spacer()
                
            }
        }
    }
}

//struct OnboardingView3_Previews: PreviewProvider {
//    static var previews: some View {
//        OnboardingView3()
//    }
//}
