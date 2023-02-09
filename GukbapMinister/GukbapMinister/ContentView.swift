//
//  ContentView.swift
//  GukbapMinister
//
//  Created by Martin on 2023/01/16.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: UserViewModel
    @State private var isMoving: Bool = false
    @State  var isLoading: Bool = true
    @AppStorage("isFirstLaunching") var isFirstLaunching: Bool = true
    var body: some View {
        ZStack{
            if isLoading{
                launchScreen.transition(.opacity).zIndex(1)
            }
            
            if viewModel.logStatus{
                MainTabView()
                    .fullScreenCover(isPresented: $isFirstLaunching) {
                        OnboardingTabView(isFirstLaunching: $isFirstLaunching)
                    }
            }else{
                switch viewModel.state{
                case .signedIn: MainTabView()
                case .kakaoSign: SignUpTabView(selection: viewModel.selection)
                case .signedOut, .main: SignInView()
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                isLoading.toggle()
            })
        }
    }
}
extension ContentView{
    var launchScreen: some View{
        ZStack(alignment: .center) {
            Color(.white).ignoresSafeArea()
            Image("AppIcon.noBg")
                .resizable()
                .frame(width: 200, height: 200)
                .zIndex(1)
                .offset(x: isMoving ? 0 : -0 , y: isMoving ? 45 : -240)
                .animation(Animation.easeInOut(duration: 2.2).repeatForever(),
                           value: isMoving)
            
        }
        .onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                isMoving = true
            })
        })
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(UserViewModel())
            
    }
}




