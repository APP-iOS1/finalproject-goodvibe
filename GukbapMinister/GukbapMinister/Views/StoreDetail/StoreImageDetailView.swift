//
//  StoreImageDetailView.swift
//  GukbapMinister
//
//  Created by 이원형 on 2023/02/07.
//

import SwiftUI

struct StoreImageDetailView: View {
    @StateObject  var storesViewModel: StoresViewModel

    @Binding var isshowingStoreImageDetail : Bool
    var store : Store

    var body: some View {
        NavigationStack{
            ZStack{
                Color.black
                    .ignoresSafeArea()
                VStack{
                    TabView {

                        ForEach(Array(store.storeImages.enumerated()), id: \.offset){ index, imageData in
                            Button(action: {
                                isshowingStoreImageDetail.toggle()
                            }){
                                if let image = storesViewModel.storeTitleImage[imageData] {
                                    
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
             
                                }
                                //if let
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
                            isshowingStoreImageDetail.toggle()
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
