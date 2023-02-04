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
            .padding(.vertical, 6)
        }
        .frame(maxWidth: .infinity)
        .scrollDisabled(mapViewModel.filteredGukbaps.isEmpty)
        
    }
    
    
    private var filterButton: some View {
        Button{
            self.isShowingFilterModal = true
        } label: {
            Label("필터",systemImage: "slider.horizontal.3")
                .foregroundColor(isFiltered ? .white : .gray)
                .padding(.horizontal, 10)
                .frame(height: 35)
        }
        .background{
            Capsule()
                .fill(isFiltered ? Color.mainColor: Color.white)
        }
        .overlay {
            Capsule()
                .stroke(Color.mainColor)
        }
        .overlay {
            if isFiltered {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.mainColor)
                    .background(Circle().fill(.white))
                    .offset(x: -30, y: -15)
            }
        }
        .padding(.leading, 26)
        .padding(.trailing, 6)
        .sheet(isPresented: self.$isShowingFilterModal) {
            NavigationStack {
                CategoryFilteringView(showModal: $isShowingFilterModal)
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
                .padding(.horizontal, 10)
                .frame(height: 35)
                .background(Capsule().fill(Color.white))
                .overlay {
                    Capsule()
                        .stroke(Color.mainColor)
                }
            }
        }
        .padding(.trailing, 26)
    }
    
    private var isFiltered: Bool {
        !mapViewModel.filteredGukbaps.isEmpty
    }
}


struct MapFilter_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
            .environmentObject(MapViewModel())
    }
}
