//
//  StoreModalView.swift
//  GukbapMinister
//
//  Created by TEDDY on 1/18/23.
//

import SwiftUI

struct StoreModalView: View {
    @EnvironmentObject private var storesViewModel: StoresViewModel
    @State private var isHeart : Bool = false
    
    var store: Store = .test
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                storeTitle
                divider
                    .padding(.top, 10)
                
                HStack(alignment: .top) {
                    imageOrPlaceholder
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
    }
    
    
    
    
}

extension StoreModalView {
    
    var storeTitle: some View {
        HStack {
            NavigationLink(destination: DetailView(store: store)) {
                Text(store.storeName)
                    .font(.title3)
                    .bold()
//                    .offset(y: 7)
            }
            Spacer()
        }
    }
    
    var divider: some View {
        Divider()
            .frame(width: Screen.searchBarWidth, height: 1)
            .overlay(Color.mainColor.opacity(0.5))
    }
    
    var imageOrPlaceholder: some View {
        NavigationLink(destination: DetailView(store: store)) {
            if let imageData = storesViewModel.storeTitleImage[store.storeImages.first ?? ""] {
                Image(uiImage: imageData)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 90, height: 90)
                    .cornerRadius(6)
            } else {
                Rectangle().fill(.gray.opacity(0.1))
                    .frame(width: 90, height: 90)
                    .cornerRadius(6)
            }
        }
    }
}



struct StoreModalView_Previews: PreviewProvider {
    static var previews: some View {
        StoreModalView()
            .environmentObject(StoresViewModel())
    }
}
