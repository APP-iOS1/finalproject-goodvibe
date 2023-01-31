//
//  MapViewFilterButton.swift
//  GukbapMinister
//
//  Created by TEDDY on 1/30/23.
//

// MapView의 extension 이라서 파일명이 MapView + FilterButton

import SwiftUI

extension MapView {
  var filterButton: some View {
    HStack{
      Button{
        self.showingFilterModal = true
      } label: {
        Text(Image(systemName: "slider.horizontal.3")).foregroundColor(.gray) + Text("필터")
          .foregroundColor(.gray)
      }
      .padding(.horizontal, 10)
      .padding(.vertical, 5)
      .background(Capsule().fill(Color.white))
      .overlay {
        Capsule()
          .stroke(.yellow)
      }
      .sheet(isPresented: self.$showingFilterModal) {
        MapCategoryModalView(showModal: $showingFilterModal)
          .presentationDetents([.height(335)])
      }
      .padding(.horizontal, 18)
      
      Spacer()
    }
  }
}
