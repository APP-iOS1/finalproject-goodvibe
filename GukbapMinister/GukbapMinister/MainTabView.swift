//
//  MainTabView.swift
//  GukbapMinister
//
//  Created by ㅇㅇ on 2023/01/17.
//

import SwiftUI

struct MainTabView: View {
    @State private var tabSelection: Int = 0
    var body: some View {
        TabView(selection: $tabSelection) {
            ExploreView()
                .tabItem {
                    Label("둘러보기", image: "DRdukbaegi.fill")
                }
                .tag(0)
            
            MapView()
                .tabItem {
                    Label("지도", systemImage: "map")
                }
                .tag(1)
            
            CollectionView()
                .tabItem {
                    Label("내가 찜한 곳", systemImage: "heart.circle")
                }
                .tag(2)
            
            MyPageView()
                .tabItem {
                    Label("마이페이지", systemImage: "person")
                }
                .tag(3)
        }
        .accentColor(.yellow)
        

    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
