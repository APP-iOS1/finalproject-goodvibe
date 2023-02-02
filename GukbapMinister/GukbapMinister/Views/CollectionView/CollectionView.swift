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

                   let imageData = collectionVM.storeImages[store.storeImages.first ?? ""] ?? UIImage()

                    cell(collectionVM: collectionVM, cellData: store, imagedata: imageData)
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
            print("\(collectionVM.stores)")
            
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
    var imagedata: UIImage
    let currentUser = Auth.auth().currentUser
    
    var body: some View {
        
        
        VStack {
            NavigationLink {
                DetailView(store : cellData)
            } label: {
                HStack (){

                    Image(uiImage: imagedata)
                        .resizable()
                        .frame(width: 90, height: 90)
                        .cornerRadius(6)
                        .padding(.leading,40)
                    
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
                            .padding(.trailing, 40)
                        }
                        
                        Text(cellData.storeAddress)
                            .font(.caption)
                            .bold()

                            .padding(.top, 2.5)
                        
                        Spacer()
                        HStack(alignment: .bottom){
                            Text("깍두기 지수")
                            
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
            
            }
        }
       
        .onAppear {
            collectionVM.isHeart = true
//            print("\(#function) : \(cellData.storeImages.first ?? "")")
        }
    }
}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView()
            .environmentObject(UserViewModel())
    }
}
