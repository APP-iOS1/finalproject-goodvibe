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
                ForEach(storesViewModel.stores){ storeList in
                    NavigationLink{
                        DetailView()
                    } label:{
                        StoreView()
                    }
                }//ForEach
            }
        })
    }
}
