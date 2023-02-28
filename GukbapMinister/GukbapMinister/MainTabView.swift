//
//  MainTabView.swift
//  GukbapMinister
//
//  Created by ㅇㅇ on 2023/01/17.
//

import SwiftUI

struct MainTabView: View {
    @StateObject var storesViewModel: StoresViewModel = StoresViewModel()
    @StateObject private var userViewModel: UserViewModel = UserViewModel()
    
    @State private var tabSelection: Int = 0
    @State private var showModal: Bool = false
    
    var body: some View {
        TabView(selection: $tabSelection) {
            MapView()
                .tabItem {
                    Label("지도", image: "GBmapIcon")
                }
                .tag(0)
                .environmentObject(storesViewModel)
            
            
            ExploreView()
                .tabItem {
                    Label("둘러보기", image: "GBexploreIcon")
                }
                .tag(1)
                .environmentObject(storesViewModel)
                .environmentObject(userViewModel)


//            if userViewModel.state == .noSigned{
//                //                CollectionView()
//                NoLoginView()
//                    .tabItem {
//                        Label("내가 찜한 곳", image: "GBcollectionIcon")
//                    }
//                    .toolbar(.visible, for: .tabBar)
//                    .toolbarBackground(Color.white, for: .tabBar)
//                    .tag(2)
//                //                    .environmentObject(storesViewModel)
//                    .environmentObject(userViewModel)
//                    .fullScreenCover(isPresented: $showModal, content: {
//                        SignInView2()
//                    })
//                    .onAppear {
//                        DispatchQueue.main.async {
//                            self.showModal = true
//                        }
//                    }
//                //                MyPageView()
//                NoLoginView2()
//                    .tabItem {
//                        Label("마이페이지", image: "GBmypageIcon")
//                    }
//                    .tag(3)
//                    .environmentObject(userViewModel)
//                    .fullScreenCover(isPresented: $showModal, content: {
//                        SignInView2()
//                    })
//                    .onAppear {
//                        DispatchQueue.main.async {
//                            self.showModal = true
//                        }
//                    }
//            }else{
                CollectionView()
                    .tabItem {
                        Label("내가 찜한 곳", image: "GBcollectionIcon")
                    }
                    .toolbar(.visible, for: .tabBar)
                    .toolbarBackground(Color.white, for: .tabBar)
                    .tag(2)
                    .environmentObject(storesViewModel)
                    .environmentObject(userViewModel)
                MyPageView()
                    .tabItem {
                        Label("마이페이지", image: "GBmypageIcon")
                    }
                    .tag(3)
                    .environmentObject(userViewModel)
//            }

        }
        .accentColor(.mainColor)
        .onAppear {
            storesViewModel.subscribeStores()
        }
        .onDisappear {
            storesViewModel.unsubscribeStores()
        }
        
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView(storesViewModel: StoresViewModel())
            
    }
}
