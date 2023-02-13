//
//  OnboardingView1.swift
//  GukbapMinister
//
//  Created by ㅇㅇ on 2023/02/09.
//

import SwiftUI

struct OnboardingView1: View {
    var body: some View {
        
        ZStack {
            Color.mainColor.ignoresSafeArea()
            VStack{
                Image("1")
                    .padding(.top, 100)
                Text("주변에 있는 많은 종류의 국밥 맛집을 검색해보세요!")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding()
                Spacer()
            }
        }
    }
}

struct OnboardingView1_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView1()
    }
}
