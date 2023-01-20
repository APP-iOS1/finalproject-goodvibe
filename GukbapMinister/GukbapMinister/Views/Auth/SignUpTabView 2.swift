//
//  SignUpTapView.swift
//  GukbapMinister
//
//  Created by 전혜성 on 2023/01/18.
//

import SwiftUI

struct SignUpTabView: View {
    
    @State private var selection: Int = 1
    
    var body: some View {
        VStack {
            SignUpProcessView(index: selection)
            TabView(selection: $selection) {
                SignUpView(selection: $selection)
                    .tag(1)
                SignUpInfoView(selection: $selection)
                    .tag(2)
                SignUpGukBabView()
                    .tag(3)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(Animation.easeInOut(duration: 0.5), value: selection)
        }
    }
}

struct SignUpTabView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpTabView()
    }
}
