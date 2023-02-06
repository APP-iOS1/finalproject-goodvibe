//
//  CollectionView.swift
//  GukbapMinister
//
//  Created by Martin on 2023/01/16.
//

import SwiftUI
import FirebaseAuth

struct CollectionView: View {
    @EnvironmentObject private var storesViewModel: StoresViewModel
    
    @EnvironmentObject private var testVM : MapViewModel
    @EnvironmentObject private var userVM: UserViewModel
    
    @StateObject private var collectionVM: CollectionViewModel = CollectionViewModel()
    
    let currentUser = Auth.auth().currentUser
    
    
    @State var res : [Store] = []
    
    var body: some View {
        NavigationStack{
            ZStack{
                
                // 배경 색
                Color.gray.opacity(0.2)
                
                
                ScrollView{
                    if (collectionVM.stores != [] ) {
                        
                        VStack{
                            Rectangle()
                                .frame(width: UIScreen.main.bounds.width, height: 10)
                                .foregroundColor(.gray.opacity(0.2))

                            ForEach(collectionVM.stores, id: \.self) { store in
                                
                                let imageData = collectionVM.storeImages[store.storeImages.first ?? ""] ?? UIImage()
                                
                                cell(collectionVM: collectionVM, cellData: store, imagedata: imageData)
                                    .frame(width: UIScreen.main.bounds.width-40, height: 90)
                                    .padding()
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(.gray.opacity(0.3))
                                            .frame(width: UIScreen.main.bounds.width - 20, height: 120)
                                    )
                                    .padding(.vertical, 10)
                                
                                Divider()
                            }
                        }
                        .background(.white)
                        
                        
                    } else{
                        
                        VStack{
                            Spacer()
                            
                            VStack{
                                HStack{
                                    Text("찜한 가게가 아무 곳도 없네요, 이런 국밥집은 어떠신가요?")
                                        .font(.caption)
                                        .bold()
                                        .padding(.leading)
                                    Spacer()
                                }
                                .padding(.top, 20)
                                
                                ForEach(Array(storesViewModel.stores.enumerated()), id: \.offset){ (index, element) in

                                    if Int(index.description) == storesViewModel.countRan{
                                        let imageData = collectionVM.storeImages[element.storeImages.first ?? ""] ?? UIImage()
                                        
                                        cell(collectionVM: collectionVM, cellData: element, imagedata: imageData)
                                            .frame(width: UIScreen.main.bounds.width-40, height: 90)
                                            .padding()
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .stroke(.gray.opacity(0.3))
                                                    .frame(width: UIScreen.main.bounds.width - 20, height: 120)
                                            )
                                            .padding(.bottom, 15)
                                    }
                                }
                            }
                            .frame(width: UIScreen.main.bounds.width, height: 170)
                            .background(.white)
                            
                        }
                        
                    }
                }
                .toolbarBackground(Color.white, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .navigationTitle("내가 찜한 곳")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .onAppear {
            collectionVM.fetchLikedStore(userId: currentUser?.uid ?? "")
            print("\(collectionVM.stores)")
            Task{
                storesViewModel.subscribeStores()
                // 생성 시점 이슈로 인해 뷰모델에서 난수를 생성
                storesViewModel.getRandomNumber()
            }
            
        }
        .refreshable {
            collectionVM.fetchLikedStore(userId: currentUser?.uid ?? "")
            Task{
                storesViewModel.subscribeStores()
                // 생성 시점 이슈로 인해 뷰모델에서 난수를 생성
                storesViewModel.getRandomNumber()
            }
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
                HStack{
                    
                    Image(uiImage: imagedata)
                        .resizable()
                        .frame(width: 90, height: 90)
                        .cornerRadius(6)
                    
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
                            .padding(.trailing, 10)
                        }
                        
                        Text(cellData.storeAddress)
                            .font(.caption)
                            .bold()
                            .padding(.top, 2.5)
                        
                        Spacer()
                        
                        HStack(alignment: .bottom){
                            Text("깍두기 점수")
                            
                            HStack(alignment: .center, spacing: 1){
                                ForEach(0..<5) { index in
                                    Image(Int(cellData.countingStar) >= index ? "Ggakdugi" : "Ggakdugi.gray")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                }
                            }
                            
                            
                            Spacer()
                            
                        }
                        .frame(height: 40)
                        .padding(.bottom, -5)
                    }
                    .padding(.leading, 0)
                }
                
            }
        }
        
        .onAppear {
            collectionVM.isHeart = true

        }
    }
}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView()
            .environmentObject(UserViewModel())
    }
}
