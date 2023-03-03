//
//  StoreModalView.swift
//  GukbapMinister
//
//  Created by TEDDY on 1/18/23.
//

import SwiftUI
import Kingfisher

struct StoreModalView: View {
    var store: Store
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                storeTitle
                divider
                    .padding(.top, 10)
                
                HStack(alignment: .top) {
                    StoreModalImage(manager: StoreImageManager(store: store))
                    VStack(alignment: .leading){
                        Menu {
                            Button {
                                let pasteboard = UIPasteboard.general
                                pasteboard.string = store.storeAddress
                            } label: {
                                Label("이 주소 복사하기", systemImage: "doc.on.clipboard")
                            }
                            Text(store.storeAddress)
                        } label: {
                            HStack {
                                Text(store.storeAddress)
                                    .padding(.leading, 5)
                                    .lineLimit(1)
                                    .fixedSize(horizontal: false, vertical: true)
                                Image(systemName: "ellipsis.circle")
                                
                                Spacer()
                            }
                            .font(.subheadline)
                        }
                        .frame(height: 20)
                        .padding(.top, 10)
                        Spacer()
                        GgakdugiRatingShort(rate: store.countingStar, size: 20)
                            .padding(.leading, 5)
                            .padding(.bottom, 10)
                    }
                }
                .frame(height: 90)
                .padding(.top, 10)
            }
        }
        .padding(.horizontal, 15)
        .frame(width: Screen.searchBarWidth, height: 160)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.mainColor.opacity(0.5))
        }
        .onAppear {
            print("모달이 나오겠습니다")
        }
    }
    
}

extension StoreModalView {
    var storeTitle: some View {
        HStack {
            NavigationLink(destination: DetailView(detailViewModel: DetailViewModel(store: store))) {
                Text(store.storeName)
                    .font(.title3)
                    .bold()
            }
            Spacer()
        }
    }
    
    var divider: some View {
        Divider()
            .frame(width: Screen.searchBarWidth, height: 1)
            .overlay(Color.mainColor.opacity(0.5))
    }
    
    
}


struct StoreModalImage: View {
    @StateObject var manager = StoreImageManager(store: .test)

    var body: some View {
        NavigationLink(destination: DetailView(detailViewModel: DetailViewModel(store: manager.store))) {
            if let url = manager.imageURLs.first
            {
                KFImage(url)
                    .placeholder {
                        Gukbaps(rawValue: manager.store.foodType.first ?? "순대국밥")?
                                .placeholder
                                .resizable()
                                .scaledToFit()
                                .modifier(StoreModalImageModifier())
                    }
                    .loadDiskFileSynchronously()
                    .cacheMemoryOnly() //Sets whether the image should only be cached in memory but not in disk.
                    .fade(duration: 0.5)
                    .resizable()
                    .scaledToFill()
                    .modifier(StoreModalImageModifier())
            } else {
                Gukbaps(rawValue: manager.store.foodType.first ?? "순대국밥")?.placeholder
                    .resizable()
                    .scaledToFit()
                    .modifier(StoreModalImageModifier())
            }
        }

    }
}

struct StoreModalImageModifier: ViewModifier {

    func body(content: Content) -> some View {
        content
            .frame(width: 90, height: 90)
            .cornerRadius(6)
            .overlay {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(.black.opacity(0.2))
            }
    }
}

