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
          VStack {
            HStack {
              Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
                .padding(.leading, 15)
              TextField("국밥집 검색",text: $searchString)
                .onTapGesture {
                  self.isShowingSearchView.toggle()
                  UIView.setAnimationsEnabled(false)
                }
                .fullScreenCover(isPresented: $isShowingSearchView) {
                  SearchView()
                }
                .onAppear {
                  UIView.setAnimationsEnabled(true)
                }
            }
            .frame(width: width - 36, height: 50)
            .background(Capsule().fill(Color.white))
            .overlay {
              Capsule()
                .stroke(.yellow)
              
            }
          }
        }
      }
    }
