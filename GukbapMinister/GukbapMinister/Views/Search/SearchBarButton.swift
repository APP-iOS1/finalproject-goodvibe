//
//  SearchBarButton.swift
//  GukbapMinister
//
//  Created by Martin on 2023/02/02.
//

import SwiftUI

struct SearchBarButton: View {
    @State var isShowingSearchView: Bool = false
    
    var body: some View {
        HStack{
            Button {
                isShowingSearchView.toggle()
                UIView.setAnimationsEnabled(false)
            } label: {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .padding(.leading, 15)
                    Text("국밥집 검색")
                    Spacer()
                }
                .foregroundColor(.gray)
                .frame(width: Screen.searchBarWidth, height: 50)
                .background(Capsule().fill(Color.white))
                .overlay {
                    Capsule()
                        .stroke(Color.mainColor)
                }
            }
        }
        .fullScreenCover(isPresented: $isShowingSearchView) {
            SearchView()
                .onAppear {
                    UIView.setAnimationsEnabled(true)
                }
        }
    }
}

