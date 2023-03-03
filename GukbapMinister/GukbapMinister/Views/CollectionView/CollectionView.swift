//
//  CollectionView.swift
//  GukbapMinister
//
//  Created by Martin on 2023/01/16.
//

import SwiftUI
import FirebaseAuth
import Kingfisher

struct CollectionView: View {
    @StateObject private var viewModel: CollectionViewModel = CollectionViewModel()
    @EnvironmentObject private var storesViewModel: StoresViewModel
    @EnvironmentObject private var userViewModel: UserViewModel
    
    let currentUser = Auth.auth().currentUser

    var body: some View {
        NavigationStack {
            if userViewModel.isLoggedIn == true {
                ZStack {
                    Color.gray.opacity(0.2)
                    
                    ScrollView {
                        // 내가 찜한 가게가 있을 시 보여준다
                        if !viewModel.stores.isEmpty {
                          CollectionLikedStores(collectionViewModel: viewModel)
                        } else {
                            // 내가 찜한 가게가 없을 시 랜덤한 가게를 보여준다
                           CollectionRandomStores()
                                .environmentObject(storesViewModel)
                        }
                        
                    } // ScrollView
                    .toolbarBackground(Color.white, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .navigationTitle("내가 찜한 가게")
                    .navigationBarTitleDisplayMode(.inline)
                } // ZStack
            } else {
                    goLoginView()
                        .environmentObject(userViewModel)
            }
        } // NavigationStack
        .onAppear {
            viewModel.subscribeLikedStore()
        }
        .onDisappear {
            viewModel.unsubscribeLikedStores()
        }
    }
}


// 내가 찜한 곳이 있을 시 보여주는 cell



// 내가 찜한 곳이 없을 시 보여주는 cell
struct cellRandom : View {
    @EnvironmentObject private var userVM: UserViewModel
    
    var viewModel: CollectionViewModel
    var cellData : Store
    var imagedata: UIImage
    let currentUser = Auth.auth().currentUser
    @State var isLoading = true
    @State var plusHeart = false
    var rowOne: [GridItem] = Array(repeating: .init(.fixed(50)), count: 1)
    
    
    var body: some View {
        
        
        VStack {
            NavigationLink {
                DetailView(detailViewModel: DetailViewModel(store: cellData))
            } label: {
                HStack (alignment: .top){
                    
                    Image(uiImage: imagedata)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 90, height: 90)
                        .cornerRadius(25)
                        .padding(.top,7.5)
                    
                    VStack(alignment: .leading, spacing: 0){
                        HStack{
                            Text(cellData.storeName)
                                .font(.title3)
                                .bold()
                                .padding(.top, 3)

                            
                            Spacer()
                        }
                        
                        Text(cellData.storeAddress)
                            .font(.caption)
                            .padding(.top, 3)
                        

                        HStack(alignment: .center){
                           
                            GgakdugiRatingShort(rate: cellData.countingStar , size: 22)
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

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isLoading = false
          }

        }
      
    }
}

//struct CollectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        CollectionView()
//            .environmentObject(UserViewModel())
//    }
//}
