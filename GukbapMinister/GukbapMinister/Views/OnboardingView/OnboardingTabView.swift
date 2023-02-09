//
//  OnboardingTabView.swift
//  GukbapMinister
//
//  Created by ㅇㅇ on 2023/02/09.
//

import SwiftUI

struct OnboardingTabView: View {
    @Binding var isFirstLaunching: Bool
    var body: some View {
        ZStack {
            Color.mainColor.ignoresSafeArea()
            TabView{
                OnboardingView1()
                OnboardingView2()
                OnboardingView3(isFirstLaunching: $isFirstLaunching)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        }
    }
}

//struct OnboardingTabView_Previews: PreviewProvider {
//    static var previews: some View {
//        OnboardingTabView()
//    }
//}
