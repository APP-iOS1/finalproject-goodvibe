//
//  MainTabView.swift
//  GukbapMinister
//
//  Created by ㅇㅇ on 2023/01/17.
//

import SwiftUI

struct MainTabView: View {
    @State private var tabSelection: Int = 0
    @StateObject var storesViewModel: StoresViewModel = StoresViewModel()
   
    
    var body: some View {
        TabView(selection: $tabSelection) {
            MapView()
                .tabItem {
                    Label("지도", systemImage: "map")
                }
                .tag(0)
                .environmentObject(storesViewModel)
                
                
            ExploreView()
                .tabItem {
                    Label("둘러보기", image: "Ddukbaegi.fill")
                }
                .tag(1)
                .environmentObject(storesViewModel)
            CollectionView()
                .tabItem {
                    Label("내가 찜한 곳", systemImage: "heart.circle")
                }
                .toolbar(.visible, for: .tabBar)
                .toolbarBackground(Color.white, for: .tabBar)
                .tag(2)
                .environmentObject(storesViewModel)
                .environmentObject(UserViewModel())
            MyPageView()
                .tabItem {
                    Label("마이페이지", systemImage: "person")
                }
                .tag(3)
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
        MainTabView()
    }
}
