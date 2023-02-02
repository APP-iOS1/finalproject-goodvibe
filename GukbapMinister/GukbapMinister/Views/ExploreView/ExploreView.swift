//
//  ExploreView.swift
//  GukbapMinister
//
//  Created by Martin on 2023/01/16.
//

import SwiftUI

struct ExploreView: View {
    @StateObject var storeViewModel: StoreViewModel = StoreViewModel()
    @StateObject var storesViewModel: StoresViewModel = StoresViewModel()
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    
    let titles: [String] = ["조회수순", "평점순"]
    @State private var selectedIndex: Int = 0
    
    var body: some View {
        
        NavigationStack{
            ScrollView {
                VStack{
                    SearchBarButton()
                    
                    HStack {
                        SegmentedPicker(
                            titles,
                            selectedIndex: Binding(
                                get: { selectedIndex },
                                set: { selectedIndex = $0 ?? 0 }),
                            content: { item, isSelected in
                                Text(item)
                                    .foregroundColor(isSelected ? Color.black : Color.gray )
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                            },
                            selection: {
                                VStack(spacing: 0) {
                                    Spacer()
                                    Rectangle()
                                        .fill(Color.black)
                                        .frame(height: 1)
                                }
                            })
                        .animation(.easeInOut(duration:0.3), value: selectedIndex)
                    }
                    .frame(height: 70)
                    ForEach(storesViewModel.stores, id: \.self){ store in
                        NavigationLink{
                            DetailView()
                        } label:{
                            StoreView(store:store, storeViewModel: storeViewModel)
                        }
                        .padding(.bottom, 10)
                    }
                    //ForEach
                }
                //VStack
                
                
            }
        }
        .onAppear {
            storesViewModel.subscribeStores()
            print("\(storesViewModel.stores)")
            
        }
        .onDisappear {
            storesViewModel.unsubscribeStores()
        }
    }
}//ExploreView




