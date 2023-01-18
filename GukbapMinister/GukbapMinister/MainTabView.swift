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
                    Label("둘러보기", systemImage: "person")
                }
                .tag(0)
            
            MapView()
                .tabItem {
                    Text("지도")
                }
                .tag(1)
            
            DetailView()
                .tabItem {
                    Text("내가 찜한 곳")
                }
                .tag(2)
            
            MyPageView()
                .tabItem {
                    Text("마이페이지")
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
