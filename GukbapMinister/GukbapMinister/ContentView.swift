//
//  ContentView.swift
//  GukbapMinister
//
//  Created by Martin on 2023/01/16.
//

import SwiftUI

struct ContentView: View {
    @State private var tabSelection: Int = 0
    var body: some View {
        TabView(selection: $tabSelection) {
            ExploreView()
                .tabItem {
                    Image(systemName: "binoculars.fill")
                    Text("둘러보기")
                }
                .tag(0)
            
            MapView()
                .tabItem {
                    Image(systemName: "binoculars.fill")
                    Text("지도")
                }
                .tag(1)
            
            CollectionView()
                .tabItem {
                    Image(systemName: "binoculars.fill")
                    Text("내가 찜한 곳")
                }
                .tag(2)
            
            MyPageView()
                .tabItem {
                    Image(systemName: "binoculars.fill")
                    Text("마이페이지")
                }
                .tag(3)
        }
        .tint(Color.systemYellow)
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
