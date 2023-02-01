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
                self.isShowingFilterModal = true
            } label: {
                Label("필터",systemImage: "slider.horizontal.3")
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 7)
            }
            .background(Capsule().fill(Color.white))
            .overlay {
                Capsule()
                    .stroke(Color.mainColor)
            }
            
            Spacer()
        }
        .padding(.horizontal, 32)
        .sheet(isPresented: self.$isShowingFilterModal) {
            MapCategoryModalView(showModal: $isShowingFilterModal)
                .presentationDetents([.height(335)])
        }
    }
}
