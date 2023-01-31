//
//  CollectionView.swift
//  GukbapMinister
//
//  Created by Martin on 2023/01/16.
//

import SwiftUI
import FirebaseAuth

struct CollectionView: View {
    @EnvironmentObject private var testVM : MapViewModel
    @EnvironmentObject private var userVM: UserViewModel
    
    @StateObject private var collectionVM: CollectionViewModel = CollectionViewModel()
    
    let currentUser = Auth.auth().currentUser
    
    var body: some View {
        NavigationStack{
            ScrollView{
                ForEach(collectionVM.stores, id: \.self) { store in
                    cell(collectionVM: collectionVM, cellData: store)
                        .zIndex(1)
                        .contextMenu {
                            Button {
                                collectionVM.removeLikedStore(userId: currentUser?.uid ?? "", store: store)
                            } label: {
                                Text("삭제")
                            }
                            }
                    Divider()
                }
            }
            
            .navigationTitle("내가 찜한 곳")
            .navigationBarTitleDisplayMode(.inline)
            
        }
        .onAppear {
           
            collectionVM.fetchLikedStore(userId: currentUser?.uid ?? "")
            
        }
        .refreshable {
            collectionVM.fetchLikedStore(userId: currentUser?.uid ?? "")
        }
        
    }
}

struct cell : View {
    @EnvironmentObject private var userVM: UserViewModel
    
    var collectionVM: CollectionViewModel
    var cellData : Store
    
    let currentUser = Auth.auth().currentUser
    
    var body: some View {
        
        
        VStack {
            NavigationLink {
                DetailView()
            } label: {
                HStack (alignment: .center){
                    
//                    AsyncImage(url: URL(string: cellData.storeImages[0])) { image in
//                        image
//                            .resizable()
//                        //.scaledToFit()
//                    } placeholder: {
//                        Color.gray.opacity(0.1)
//                    }
//                    .frame(width: 90, height: 90)
//                    .cornerRadius(6)
//                    .padding(.leading, 20)
                    
                    Image(uiImage: collectionVM.storeImages[cellData.storeImages.first ?? ""] ?? UIImage())
                        .resizable()
                        .frame(width: 90, height: 90)
                        .cornerRadius(6)
                        .padding(.leading, 20)
                    
                    VStack(alignment: .leading, spacing: 1){
                        HStack{
                            Text(cellData.storeName)
                                .font(.title3)
                                .bold()
                            
                            Spacer()
                            
                            Button{
                                collectionVM.isHeart.toggle()
                                // 하트가 ture => LikeStore 스토어id만 append메서드 vs delte메서드
                                // append(cellData.sotreId)
                                collectionVM.manageHeart(userId: currentUser?.uid ?? "", store: cellData)
                                
                            } label: {
                                Image(systemName: collectionVM.isHeart ? "heart.fill" : "heart")
                                    .foregroundColor(.red)
                            }
                            .padding(.trailing, 25)
                        }
                        
                        Text(cellData.storeAddress)
                            .font(.caption)
                            .bold()
                        
                        
                        
                            .padding(.top, 2.5)
                        
                        Spacer()
                        HStack(alignment: .bottom){
                            Text("별점")
                            
                            HStack(alignment: .center, spacing: 1){
                                ForEach(0..<5) { index in
                                    Image(Int(cellData.countingStar) >= index ? "Ggakdugi" : "Ggakdugi.gray")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                }
                            }
                            
                            
                            Spacer()
                            
                        }
                        .frame(width: 300, height: 40)
                        .padding(.bottom, -5)
                    }
                    
                }
                .padding(.vertical, 5)
                .padding(.horizontal, 5)
            }
        }
        .onAppear {
            collectionVM.isHeart = true
            print("\(#function) : \(cellData.storeImages.first ?? "")")
        }
    }
}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView()
    }
}
