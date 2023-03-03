//
//  ExploreCategoryDetailView.swift
//  GukbapMinister
//
//  Created by Martin on 2023/02/08.
//

import SwiftUI
import Kingfisher

struct ExploreCategoryDetailView: View {
    @EnvironmentObject var storesViewModel: StoresViewModel
    var stores: [Store]
    
    let columns: [GridItem] = .init(repeating: .init(.flexible()), count: 2)
    var body: some View {
        ScrollView(.vertical) {
            GeometryReader{ geo in
                let width: CGFloat = geo.size.width
                let gridSize = width / 2
                let imageSize = gridSize * 0.925
                
                LazyVGrid(columns: columns) {
                    ForEach(stores) { store in
                        NavigationLink {
                            DetailView(store: store)
                        } label: {
                            StoreGridItem(manager: StoreImageManager(store: store), width: gridSize, imageSize: imageSize)
                        }
                    }
                }
            }
        }
        .padding(5)
        
    }
}



struct StoreGridItem: View{
    @Environment(\.colorScheme) var scheme
    @StateObject var manager = StoreImageManager(store: .test)
    
    var width: CGFloat
    var imageSize: CGFloat
    
    var body: some View{
        
        VStack{
            VStack{
                if let url = manager.imageURLs.first {
                    KFImage(url)
                        .placeholder {
                            if let gukbap = manager.store.foodType.first {
                                Gukbaps(rawValue: gukbap)?.placeholder
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: imageSize, height: imageSize)
                                    .cornerRadius(10)
                            }
                        }
                        .cacheMemoryOnly()
                        .fade(duration: 0.25)
                        .resizable()
                        .scaledToFill()
                        .frame(width: imageSize, height: imageSize)
                        .cornerRadius(10)
                } else {
                    Gukbaps(rawValue: "순대국밥")?.placeholder
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: imageSize, height: imageSize)
                        .cornerRadius(10)
                }
                
                VStack{
                    HStack {
                        Text("\(manager.store.storeName)")
                            .fontWeight(.bold)
                            .font(.callout)
                            .lineLimit(1)
                            .foregroundColor(scheme == .light ? .black : .white)
                        Spacer()
                    }
                    

                    HStack {
                        Text("\(manager.store.storeAddress)")
                            .font(.caption2)
                            .lineLimit(1)
                            .foregroundColor(scheme == .light ? .gray : .white)
                        Spacer()
                    }
                    .padding(.bottom, 5)
                    

                    HStack{
                        Text("\(manager.store.description)")
                            .font(.caption)
                            .lineLimit(1)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(scheme == .light ? .black : .white)
                        Spacer()
                    }
                    .padding(.bottom, 5)
                    
                }
                .frame(width: imageSize)
            } //VStack
            .frame(width: width, height: 300)
            .padding(1)
            
        } // var body
    }
}


struct ExploreCategoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ExploreCategoryDetailView(stores: [.test, .test2])
                .environmentObject(StoresViewModel())
        }
    }
}
