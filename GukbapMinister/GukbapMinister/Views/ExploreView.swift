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
                ForEach(storesViewModel.stores){ store2 in
                    NavigationLink{
                        DetailView()
                    } label:{
                        StoreView(store2: store2)
                    }
                    
                    
                }//ForEach
            }
        })
    }
}

struct StoreView: View{
    var store2: Store
    
    var body: some View{
        VStack(spacing: 15) {
            HStack{
                Text("\(store2.storeName)")
                Text("\(store2.storeAddress)")
                Text("\(store2.description)")
            }
        }
    }
}
