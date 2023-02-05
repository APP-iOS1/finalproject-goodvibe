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
                        let imageData = storesViewModel.storeTitleImage[store.storeImages.first ?? ""] ?? UIImage()
                        NavigationLink{
                            DetailView(store: store)
                        } label:{
                            StoreView(store:store, imagedata: imageData)
                        }
                        .padding(.bottom, 10)
                    }
                    //ForEach
                }
                //VStack
                
                
            }
        }
        .onAppear {
            Task{
                storesViewModel.subscribeStores()
                //            storeViewModel.fetchStore()
            }
        }
        .onDisappear {
            storesViewModel.unsubscribeStores()
        }
    }
}//ExploreView


struct StoreView: View{
    var store :Store
    var imagedata: UIImage
    var body: some View{
        
            VStack{
                
//                Image("ExampleImage")
//                    .resizable()
//                    .frame(width: 353, height: 250)
//                    .padding(.top, 25)
                
                Image(uiImage: imagedata)
                    .resizable()
                    .frame(width: 353, height: 250)
                    .padding(.top, 25)
                
                
                Image(systemName: "heart")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(.secondary)
                    .fontWeight(.bold)
                    .offset(x: 140, y: -235)
                    .padding(.bottom, -25)
                
                
                VStack{
                    HStack {
                        Image(systemName: "mappin")
                        Text("\(store.storeName)")
                        
                            .fontWeight(.bold)
                            .font(.title2)
                        Spacer()
                    }
                    .padding(.bottom,5)
                    HStack {
                        Text("\(store.storeAddress)")
                        Spacer()
                    }
                    .padding(.bottom, 10)
                    HStack {
                        Text("\(store.description)")
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    .padding(.bottom, 10)
                    
                    HStack {
                        Text("평점 4.9")
                        Text("조회수 24150")
                        Spacer()
                    }
                    .font(.callout)
                }
                .padding()
            }
            .background {
                Rectangle()
                    .stroke(Color.mainColor)
            }
            .padding(10)
        
        
    } // var body
}


