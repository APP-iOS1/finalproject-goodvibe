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
                        // 내가 찜한 가게가 있을 시 보여준다
                        VStack{
                            Rectangle()
                                .frame(width: UIScreen.main.bounds.width, height: 10)
                                .foregroundColor(.gray.opacity(0.2))

                            ForEach(collectionVM.stores, id: \.self) { store in
                                
                                let imageData = collectionVM.storeImages[store.storeImages.first ?? ""] ?? UIImage()
                                
                                cellLiked(collectionVM: collectionVM, cellData: store, imagedata: imageData)
                                    .frame(width: UIScreen.main.bounds.width-40, height: 90)
                                    .padding()
                                    .padding(.vertical, 10)
                                
                                Divider()
                            }
                        }
                        .background(.white)
                        
                        
                    } else{
                        // 내가 찜한 가게가 없을 시 랜덤한 가게를 보여준다
                        VStack{
                            Spacer()
                            
                            VStack{
                                HStack{
                                    Text("찜한 가게가 아무 곳도 없네요, 이런 국밥집은 어떠신가요?")
                                        .font(.callout)
                                        .bold()
                                        .padding(.leading)
                                    Spacer()
                                }
                                .padding(.top, 20)
                                
                                ForEach(Array(storesViewModel.stores.enumerated()), id: \.offset){ (index, element) in

                                    if Int(index.description) == storesViewModel.countRan{
                                        let imageData = storesViewModel.storeTitleImage[element.storeImages.first ?? ""] ?? UIImage()
                                        
                                        cellRandom(collectionVM: collectionVM, cellData: element, imagedata: imageData)
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
                } // ScrollView
                .toolbarBackground(Color.white, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .navigationTitle("내가 찜한 곳")
                .navigationBarTitleDisplayMode(.inline)
            } // ZStack
        } // NavigationStack
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

// 내가 찜한 곳이 있을 시 보여주는 cell
struct cellLiked : View {
    @EnvironmentObject private var userVM: UserViewModel
    
    var collectionVM: CollectionViewModel
    var cellData : Store
    var imagedata: UIImage
    let currentUser = Auth.auth().currentUser
    var rowOne: [GridItem] = Array(repeating: .init(.fixed(50)), count: 1)

    @State var isLoading = true
    
    var body: some View {
        
        
        VStack {
            NavigationLink {
                DetailView(store : cellData)
            } label: {
                HStack{
                    HStack(alignment: .top){

                    Image(uiImage: imagedata)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 90, height: 90)
                        .cornerRadius(25)
                    
                        VStack(alignment: .leading, spacing: 1){
                            HStack{
                                Text(cellData.storeName)
                                    .font(.body)
                                    .bold()
                                    .padding(.top, 3)
                                
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
                            }
                            
                            
                            HStack(alignment: .bottom){
                                Text("깍두기 점수")
                                    .bold()
                                    .font(.caption2)
                                
                                HStack(alignment: .center, spacing: 1){
                                    ForEach(0..<5) { index in
                                        Image(Int(cellData.countingStar) >= index ? "Ggakdugi" : "Ggakdugi.gray")
                                            .resizable()
                                            .frame(width: 15, height: 15)
                                    }
                                }
                                
                                Spacer()
                                
                            }
                            .frame(height: 20)
                            .padding(.leading, 3)
                            .padding(.vertical, 3)
                            
                            
                            Text(cellData.storeAddress)
                                .font(.callout)
                                .padding(.top, 3)
                            
                            
                            HStack{
                                LazyHGrid(rows: rowOne) {
                                    ForEach(cellData.foodType, id: \.self) { foodType in
                                        Text("\(foodType)")
                                            .font(.caption)
                                            .padding(9)
                                            .background(Capsule().fill(Color.gray.opacity(0.15)))
                                    }
                                }
                            }
                            
                        }

                    }
                    .foregroundColor(.black)
                    .frame(height: 120)
                    .padding(.leading, 0)
                }
            }
        }
        .redacted(reason: isLoading ? .placeholder : [])
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isLoading = false
          }
        }
        .onAppear {
            collectionVM.isHeart = true

        }
    }
}


// 내가 찜한 곳이 없을 시 보여주는 cell
struct cellRandom : View {
    @EnvironmentObject private var userVM: UserViewModel
    
    var collectionVM: CollectionViewModel
    var cellData : Store
    var imagedata: UIImage
    let currentUser = Auth.auth().currentUser
    @State var isLoading = true
    @State var plusHeart = false
    var rowOne: [GridItem] = Array(repeating: .init(.fixed(50)), count: 1)

    
    var body: some View {
        
        
        VStack {
            NavigationLink {
                DetailView(store : cellData)
            } label: {
                HStack (alignment: .top){
                    
                    Image(uiImage: imagedata)
                        .resizable()
                        .frame(width: 90, height: 90)
                        .cornerRadius(25)
                    
                    VStack(alignment: .leading, spacing: 0){
                        HStack{
                            Text(cellData.storeName)
                                .font(.title3)
                                .bold()
                            
                            Spacer()
                            
                            Button{
                                collectionVM.isHeart = true
                                self.plusHeart = true

//                                    collectionVM.isHeart.toggle()
                                // 하트가 ture => LikeStore 스토어id만 append메서드 vs delte메서드
                                // append(cellData.sotreId)
                                collectionVM.manageHeart(userId: currentUser?.uid ?? "", store: cellData)
                                
                            } label: {
                                Image(systemName: plusHeart ? "heart.fill" : "heart")
                                    .foregroundColor(.red)
                            }
                        }
                        
                        Text(cellData.storeAddress)
                            .font(.caption)
                            .padding(.top, 2.5)
                        
                        
                        HStack(alignment: .center){
                            Text("깍두기 점수")
                                .bold()
                                .font(.caption)
                            HStack(alignment: .center, spacing: 1){
                                ForEach(0..<5) { index in
                                    Image(Int(cellData.countingStar) >= index ? "Ggakdugi" : "Ggakdugi.gray")
                                        .resizable()
                                        .frame(width: 12, height: 12)
                                }
                            }
                            Spacer()
                        }
                        .padding(.top, 5)
                        .frame(height: 20)
                        
                        
                        HStack{
                            LazyHGrid(rows: rowOne) {
                                ForEach(cellData.foodType, id: \.self) { foodType in
                                    Text("\(foodType)")
                                        .font(.caption)
                                        .padding(8)
                                        .background(Capsule().fill(Color.gray.opacity(0.15)))
                                }
                            }
                        }
                    }
                    .frame(height: 120)
                    .padding(.leading, 0)
                }
                .padding(.top,15)
                .foregroundColor(.black)
                
            }
        }
        .redacted(reason: isLoading ? .placeholder : [])
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isLoading = false
          }
        }
        .onAppear {
            collectionVM.isHeart = true

        }
    }
}

//struct CollectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        CollectionView()
//            .environmentObject(UserViewModel())
//    }
//}
