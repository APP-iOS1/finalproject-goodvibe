//
//  CollectionView.swift
//  GukbapMinister
//
//  Created by Martin on 2023/01/16.
//

import SwiftUI
import FirebaseAuth
import Kingfisher

struct CollectionView: View {
    @StateObject private var viewModel: CollectionViewModel = CollectionViewModel()
    @Environment(\.colorScheme) var scheme
    @EnvironmentObject private var storesViewModel: StoresViewModel
    @EnvironmentObject private var userViewModel: UserViewModel
    
    let currentUser = Auth.auth().currentUser
    
    var body: some View {
        NavigationStack {
            ZStack {
                if scheme == .light {
                    Color.gray.opacity(0.2)
                }
                if userViewModel.isLoggedIn == true {
                    ScrollView {
                        // 내가 찜한 가게가 있을 시 보여준다
                        if !viewModel.stores.isEmpty {
                            CollectionLikedStores(collectionViewModel: viewModel)
                                .background(scheme == .light ? .white : .black)
                        } else {
                            // 내가 찜한 가게가 없을 시 랜덤한 가게를 보여준다
                            CollectionRandomStores()
                                .environmentObject(storesViewModel)
                        }
                        
                    } // ScrollView
                    .navigationTitle("내가 찜한 가게")
                    .navigationBarTitleDisplayMode(.inline)
                    
                } else {
                    goLoginView()
                        .environmentObject(userViewModel)
                }
            } // ZStack
        } // NavigationStack
        .onAppear {
            viewModel.subscribeLikedStore()
        }
        .onDisappear {
            viewModel.unsubscribeLikedStores()
        }
    }
}

