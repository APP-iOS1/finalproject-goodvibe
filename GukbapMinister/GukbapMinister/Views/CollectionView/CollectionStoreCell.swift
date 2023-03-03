//
//  CollectionLikedStoreCell.swift
//  GukbapMinister
//
//  Created by Martin on 2023/03/03.
//

import SwiftUI
import Kingfisher

struct CollectionStoreCell: View {
    @StateObject var viewModel = DetailViewModel(store: .test)
    @StateObject var imageManager = StoreImageManager(store: .test)
    
    var rowOne: [GridItem] = Array(repeating: .init(.fixed(50)), count: 1)
    
    @State private var isLoading = true
    
    
    var body: some View {
        VStack {
            NavigationLink {
                DetailView(detailViewModel: DetailViewModel(store: viewModel.store))
            } label: {
                HStack {
                    HStack(alignment: .top) {
                        if let url = imageManager.imageURLs.first {
                            KFImage(url)
                                .placeholder {
                                    if let gukbap = viewModel.store.foodType.first {
                                        Gukbaps(rawValue: gukbap)?.placeholder
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 90, height: 90)
                                            .cornerRadius(25)
                                            .padding(.top, 7.5)
                                    }
                                }
                                .cacheMemoryOnly()
                                .fade(duration: 0.25)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 90, height: 90)
                                .cornerRadius(25)
                                .padding(.top, 7.5)
                        } else {
                            Gukbaps(rawValue: "순대국밥")?.placeholder
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 90, height: 90)
                                .cornerRadius(25)
                                .padding(.top, 7.5)
                        }
                        
                        VStack(alignment: .leading, spacing: 0) {
                            HStack{
                                Text(viewModel.store.storeName)
                                    .font(.title3)
                                    .bold()
                                    .padding(.top, 3)
                                Spacer()
                                
                                Button{
                                    Task {
                                        await viewModel.handleLikeButton()
                                    }
                                } label: {
                                    Image(systemName: viewModel.isLiked ? "heart.fill" : "heart")
                                        .foregroundColor(.red)
                                }
                            }
                            
                            Text(viewModel.store.storeAddress)
                                .font(.caption)
                                .padding(.top, 3)
                            
                            HStack(alignment: .center){
                                GgakdugiRatingShort(rate: viewModel.store.countingStar , size: 22)
                                Spacer()
                            }
                            .padding(.top, 5)
                            .frame(height: 20)
                            
                            HStack{
                                LazyHGrid(rows: rowOne) {
                                    ForEach(viewModel.store.foodType, id: \.self) { foodType in
                                        Text("\(foodType)")
                                            .font(.caption)
                                            .padding(8)
                                            .background(Capsule().fill(Color.gray.opacity(0.15)))
                                    }
                                }
                            }
                        }
                    }
                    .frame(height: 120)
                    .padding(.leading, 0)
                }
                .padding(.top,15)
                .foregroundColor(.black)
            }
        }
        .redacted(reason: isLoading ? .placeholder : [])
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.isLoading = false
            }
        }
    }
    
}


