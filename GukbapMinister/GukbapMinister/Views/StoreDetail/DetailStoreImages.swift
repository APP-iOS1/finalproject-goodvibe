//
//  DetailStoreImages.swift
//  GukbapMinister
//
//  Created by Martin on 2023/03/02.
//

import SwiftUI

import Kingfisher
import FirebaseStorage

struct DetailStoreImages: View {
    
    @StateObject var viewModel = DetailStoreImageViewModel(store: .test)
    @Binding var showDetail: Bool
    
    var body: some View {
        TabView {
            ForEach(viewModel.imageURLs, id: \.self){ url in
                Button(action: {
                    showDetail.toggle()
                }){
                    KFImage(url)
                        .placeholder {
                            Gukbaps(rawValue: viewModel.store.foodType.first ?? "순대국밥")?.placeholder
                                .resizable()
                                .scaledToFill()
                        }
                        .resizable()
                        .scaledToFill()
                }
            }
        }
        .frame(height:Screen.maxWidth * 0.8)
        .tabViewStyle(.page(indexDisplayMode: .always))
    }
    
    
    
}


final class DetailStoreImageViewModel: ObservableObject {
    @Published var store: Store = .test {
        willSet(newValue) {
            getImageURLs(newValue)
        }
    }
    @Published var imageURLs: [URL] = []
    private var storage = Storage.storage()
    
    init(store: Store) {
        self.store = store
    }
    
    
    func getImageURLs(_ store: Store) {
        storage.reference().child("storeImages/\(store.storeName)").listAll { result, error in
            if let error {
                print(error.localizedDescription)
            }
            if let result {
                for ref in result.items {
                    ref.downloadURL { url, error in
                        if let error {
                            print( error.localizedDescription)
                        }
                        if let url {
                            self.imageURLs.append(url)
                        }
                    }
                }
            }
        }
    }
    
}
