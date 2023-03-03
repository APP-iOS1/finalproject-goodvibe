//
//  StoreImageDetailView.swift
//  GukbapMinister
//
//  Created by 이원형 on 2023/02/07.
//

import SwiftUI
import Kingfisher

struct StoreImageDetailView: View {
    @StateObject var manager = StoreImageManager(store: .test)

    @Binding var isshowingStoreImageDetail : Bool
    

    var body: some View {
        NavigationStack{
            ZStack{
                Color.black
                    .ignoresSafeArea()
                VStack{
                    TabView {

                        ForEach(manager.imageURLs, id: \.self){ url in
                            Button {
                                isshowingStoreImageDetail = false
                            } label: {
                                KFImage(url)
                                    .placeholder {
                                        Gukbaps(rawValue: manager.store.foodType.first ?? "순대국밥")?.placeholder
                                            .resizable()
                                            .scaledToFill()
                                    }
                                    .cacheMemoryOnly()
                                    .fade(duration: 0.25)
                                    .resizable()
                                    .scaledToFill()
                            }
                        }
                    }
                    .offset(y:-30)
                    .frame(height:Screen.maxWidth * 1)
                    .tabViewStyle(.page(indexDisplayMode: .always))
                    
                }
                .navigationBarBackButtonHidden(true)
                
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            isshowingStoreImageDetail = false
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(Color.white)
                            
                        }
                    }
                }
            }
        }//NavigationStack
       
    }
}

//struct StoreImageDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        StoreImageDetailView()
//    }
//}
