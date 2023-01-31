//
//  MapViewSearch.swift
//  GukbapMinister
//
//  Created by TEDDY on 1/30/23.
//

import SwiftUI

extension MapView {
    var search: some View {
      // Command + Option + 화살표: Folding
      HStack{
        VStack {
          HStack {
            Image(systemName: "magnifyingglass")
              .foregroundColor(.secondary)
              .padding(.leading, 15)
            TextField("국밥집 검색",text: $searchGukBap)
              .onTapGesture {
                self.isPresentedSearchView.toggle()
                UIView.setAnimationsEnabled(false)
              }
              .fullScreenCover(isPresented: $isPresentedSearchView) {
                SearchView()
              }
              .onAppear {
                UIView.setAnimationsEnabled(true)
              }
            
          }
          .frame(width: 280, height: 50)
          .background(Capsule().fill(Color.white))
          .overlay {
            Capsule()
              .stroke(.yellow)
          }
        }
      }
    }
}
