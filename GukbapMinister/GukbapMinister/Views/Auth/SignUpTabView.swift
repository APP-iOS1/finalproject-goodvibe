//
//  SignUpTapView.swift
//  GukbapMinister
//
//  Created by 전혜성 on 2023/01/18.
//

import SwiftUI

struct SignUpTabView: View {
    
    @State private var selection: Int = 0
    
    var body: some View {
        
        TabView(selection: $selection) {
            SignUpView(selection: $selection)
                .tag(0)
            SignUpInfoView(selection: $selection)
                .tag(1)
            SignUpGukBabView()
                .tag(2)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
}

struct SignUpTabView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpTabView()
    }
}
