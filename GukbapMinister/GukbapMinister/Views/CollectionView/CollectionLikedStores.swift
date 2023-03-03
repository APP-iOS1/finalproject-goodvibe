//
//  CollectionLikedStores.swift
//  GukbapMinister
//
//  Created by Martin on 2023/03/03.
//

import SwiftUI

struct CollectionLikedStores: View {
    @ObservedObject var collectionViewModel: CollectionViewModel
    var stores: [Store] {
        collectionViewModel.stores
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("총 \(stores.count)개")
                    .font(.caption)
                    .fontWeight(.semibold)
                Spacer()
            }
            .padding()
            
            ForEach(stores, id: \.self) { store in
                CollectionStoreCell( viewModel: DetailViewModel(store: store),
                                     imageManager: StoreImageManager(store: store))
                    .frame(width: UIScreen.main.bounds.width-40, height: 90)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.gray.opacity(0.3))
                            .frame(width: UIScreen.main.bounds.width - 20, height: 120)
                    )
                
                    .padding(.vertical,5)
                Divider()
                
            }
        }
        .background(.white)
    }
}
