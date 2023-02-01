//
//  MapViewSearch.swift
//  GukbapMinister
//
//  Created by TEDDY on 1/30/23.
//

import SwiftUI

extension MapView {
    func search(width: CGFloat, height: CGFloat) -> some View {
        // Command + Option + 화살표: Folding
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
                .foregroundColor(.secondary)
                .frame(width: width - 64, height: 50)
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

