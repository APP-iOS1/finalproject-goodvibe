//
//  ExploreView.swift
//  GukbapMinister
//
//  Created by Martin on 2023/01/16.
//

import SwiftUI

struct ExploreView: View {
    @StateObject var storesViewModel: StoresViewModel = StoresViewModel()
    @EnvironmentObject var userViewModel: UserViewModel
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            VStack{
                ForEach(storesViewModel.stores){ store in
                    NavigationLink{
                        DetailView()
                    } label:{
                        StoreView(store: store)
                    }
                    
                    
                }//ForEach
            }
        })
    }
}

struct StoreView: View{
    var store: Store
    
    var body: some View{
        VStack(spacing: 15) {
            HStack{
                Text("\(store.storeName)")
                Text("\(store.storeAddress)")
                Text("\(store.description)")
            }
        }
    }
}
