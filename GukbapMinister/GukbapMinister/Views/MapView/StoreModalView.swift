//
//  StoreModalView.swift
//  GukbapMinister
//
//  Created by TEDDY on 1/18/23.
//

import SwiftUI

struct StoreModalView: View {
    @EnvironmentObject private var mapViewModel: MapViewModel
    
    
    @State private var isHeart : Bool = false
    
    var body: some View {
        var store: Store = .test
        NavigationStack {
            VStack {
                HStack{
                    Text(store.storeName)
                        .font(.title2)
                        .bold()
                        .padding(.leading, 20)
                    Spacer()
                }
                
                NavigationLink(destination: DetailView(store: store)) {
                    HStack {
                        AsyncImage(url: URL(string: store.storeImages.isEmpty ? "이미지 없음" : store.storeImages[0])) { image in
                            image
                                .resizable()
                            //.scaledToFit()
                        } placeholder: {
                            Color.gray.opacity(0.1)
                        }
                        .frame(width: 100, height: 100)
                        .cornerRadius(6)
                        .padding(.leading, 20)
                        
                        
                        VStack{
                            HStack(alignment: .top){
                                Text(store.storeAddress)
                                    .bold()
                                
                                Spacer()
                                
                                Button{
                                    isHeart.toggle()
                                } label: {
                                    Image(systemName: isHeart ? "heart.fill" : "heart")
                                        .foregroundColor(.red)
                                }
                                .padding(.top, 2.5)
                            }
                            .padding(.trailing, 20)
                            .padding(.bottom, 20)
                            HStack {
                                Text("깍두기지수")
                                Image("Ggakdugi")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width:10, height: 10)
                                Text("\(store.countingStar)")
                                Spacer()
                            }
                        }
                        .padding(.horizontal, 5)
                        
                        
                    }
                    .background {
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: 375, height: 120)
                            .foregroundColor(.gray)
                            .opacity(0.2)
                    }
                }
                
            }
        }
        .onAppear {
            
            store = mapViewModel.selectedStore ?? .test
        }
        
    }
}

//struct StoreModalView_Previews: PreviewProvider {
//  static var previews: some View {
//    StoreModalView()
//  }
//}
