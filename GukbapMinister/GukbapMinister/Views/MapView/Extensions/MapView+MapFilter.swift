//
//  MapView+MapFilter.swift
//  GukbapMinister
//
//  Created by Martin on 2023/02/04.
//

import SwiftUI

extension MapView {
    var mapFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                filterButton
                filteredElements
            }
            .padding(.vertical, 8)
        }
        .frame(maxWidth: .infinity)
        .scrollDisabled(mapViewModel.filteredGukbaps.isEmpty)
    }
    
    private var filterButton: some View {
        Button {
            self.isShowingFilterModal = true
        } label: {
            Label("필터",systemImage: "slider.horizontal.3")
                .foregroundColor(buttonFontColor)
                .padding(.horizontal, 10)
                .frame(height: 35)
        }
        .background {
            RoundedCorners(color: buttonBackgroundColor, strokeColor: buttonBorderColor, tl: 8, tr: 18, bl: 8, br: 18)
        }
        .overlay {
            if isFiltered {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(buttonFontColor)
                    .background(Circle().fill(buttonBackgroundColor))
                    .offset(x: -30, y: -15)
            }
        }
        .padding(.leading, 25)
        .padding(.trailing, 6)
        .sheet(isPresented: self.$isShowingFilterModal) {
            NavigationStack {
                CategoryFilteringView(showModal: $isShowingFilterModal, mapViewModel: mapViewModel)
                    .presentationDetents([.height(335)])
            }
        }
    }
    
    private var filteredElements: some View {
        HStack {
            ForEach(mapViewModel.filteredGukbaps, id:\.self) { gukbap in
                HStack(spacing: 2) {
                    gukbap.image
                        .resizable()
                        .scaledToFill()
                        .frame(width:28, height: 28)
                    Text("\(gukbap.rawValue)")
                }
                .categoryCapsule()
            }
        }
        .padding(.trailing, 26)
    }
    
    private var isFiltered: Bool {
        !mapViewModel.filteredGukbaps.isEmpty
    }
    
    private var buttonFontColor: Color {
        switch scheme {
        case .light: return self.isFiltered ? .white : .gray
        case .dark:  return self.isFiltered ? .black : .white
        @unknown default: return self.isFiltered ? .white : .gray
        }
    }
    
    private var buttonBorderColor: Color {
        switch scheme {
        case .light: return .mainColor.opacity(0.5)
        case .dark:  return .white.opacity(0.5)
        @unknown default: return .mainColor.opacity(0.5)
        }
    }
    
    private var buttonBackgroundColor: Color {
        switch scheme {
        case .light: return self.isFiltered ? .mainColor : .white
        case .dark:  return self.isFiltered ? .white : .black
        @unknown default: return self.isFiltered ? .mainColor : .white
        }
    }
    
}



