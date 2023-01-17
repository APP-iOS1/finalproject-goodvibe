//
//  ContentView.swift
//  GukbapMinister
//
//  Created by Martin on 2023/01/16.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: KakaoAuthViewModel
    var body: some View {
        switch viewModel.state{
        case .signedIn: MainTabView()
        case .signedOut: SignInView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(KakaoAuthViewModel())
    }
}
