//
//  ExploreCategoryIconsView.swift
//  GukbapMinister
//
//  Created by Martin on 2023/02/08.
//

import SwiftUI

struct ExploreCategoryIconsView: View {
    @Environment(\.colorScheme) var scheme
    @EnvironmentObject var storesViewModel: StoresViewModel
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 4)
    var body: some View {
            LazyVGrid(columns: columns) {
                ForEach(Gukbaps.allCases, id: \.self) { gukbap in
                    let stores: [Store] = storesViewModel.stores.filter {
                        $0.foodType.contains(gukbap.rawValue)
                    }
                    NavigationLink {
                        ExploreCategoryDetailView(stores: stores)
                            .navigationTitle(gukbap.rawValue)
                            .navigationBarTitleDisplayMode(.inline)
                    } label: {
                        VStack(spacing: 4) {
                            gukbap.image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                            Text(gukbap.rawValue)
                                .font(.footnote)
//                                .fontWeight(.semibold)
                                .fixedSize()
                                .tint(scheme == .light ? .black : .white)
                        }
                    }
                }
            }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(scheme == .light ? .white : .black)
    }
}

struct ExploreCategoryIconsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ExploreCategoryIconsView()
                .environmentObject(StoresViewModel())
        }
    }
}
