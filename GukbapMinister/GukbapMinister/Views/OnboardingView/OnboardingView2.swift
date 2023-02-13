//
//  OnboardingView2.swift
//  GukbapMinister
//
//  Created by ㅇㅇ on 2023/02/09.
//

import SwiftUI

struct OnboardingView2: View {
    var body: some View {
        ZStack{
            Color.mainColor.ignoresSafeArea()
            VStack{
                Image("1")
                    .padding(.top, 100)
                Text("나만 아는 맛집도 공유할 수 있어요!")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding()
                Spacer()
            }
        }
    }
}
struct OnboardingView2_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView2()
    }
}
