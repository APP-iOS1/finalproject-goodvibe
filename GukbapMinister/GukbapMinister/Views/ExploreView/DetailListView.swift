//
//  DetailListView.swift
//  GukbapMinister
//
//  Created by 기태욱 on 2023/02/09.
//
//
//  CollectionView.swift
//  GukbapMinister
//
//  Created by Martin on 2023/01/16.
//

import SwiftUI
import FirebaseAuth

struct DetailListView: View {
    @EnvironmentObject private var storesViewModel: StoresViewModel
    @EnvironmentObject private var userVM: UserViewModel
    @StateObject private var collectionVM: CollectionViewModel = CollectionViewModel()
    
    let currentUser = Auth.auth().currentUser

    
    var listName : String
    var list : [Store]
    var images : [String : UIImage]
    
    var body: some View {
        NavigationStack{
            ZStack{
                // 배경 색
                Color.gray.opacity(0.2)
                
                ScrollView{
                        
                        VStack{
                            Rectangle()
                                .frame(width: UIScreen.main.bounds.width, height: 10)
                                .foregroundColor(.gray.opacity(0.2))
                            
                            ForEach(Array(list.enumerated()), id: \.offset){ (index, element) in
                                
                                let imageData = images[element.storeImages.first ?? ""] ?? UIImage()
                                
                                ListCell(cellData: element, imagedata: imageData)
                                    .frame(width: UIScreen.main.bounds.width-40, height: 90)
                                    .padding()
                                    .padding(.vertical, 10)
                                
                                Divider()

                            }
                        }
                        .background(.white)
                        
                    
                } // ScrollView
                .toolbarBackground(Color.white, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .navigationTitle("\(listName)")
                .navigationBarTitleDisplayMode(.inline)
            } // ZStack
        } // NavigationStack

        
    }
}

// cell
struct ListCell : View {
    
    var cellData : Store
    var imagedata: UIImage
    @State var isLoading = true
    
    var rowOne: [GridItem] = Array(repeating: .init(.fixed(50)), count: 1)
    
    
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
                            .overlay(RoundedRectangle(cornerRadius: 25)
                                .stroke(Color("MainColor"), lineWidth: 0.2))
                        
                        
                        VStack(alignment: .leading, spacing: 1){
                            HStack{
                                Text(cellData.storeName)
                                    .font(.body)
                                    .bold()
                                    .padding(4)
                                
                                Spacer()
                                

                            }
                            
                            
                            HStack(alignment: .center){
                                Text("깍두기 점수")
                                    .bold()
                                    .font(.caption2)
                                
                                HStack(alignment: .center, spacing: 0){
                                    Image("Ggakdugi")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                        .padding(.trailing, 5)

                                    
                                    Text("\(String(format: "%.1f", cellData.countingStar))")
                                        .font(.caption)
                                        .bold()
                                }
                                
                                Spacer()
                                
                            }
                            .frame(height: 20)
                            .padding(.leading, 5)
                            
                            
                            HStack{
                                Text(cellData.storeAddress)
                                    .font(.callout)
                                    .lineLimit(1)
                                    .padding(.top, 3)
                                Spacer()
                            }
                            .padding(.leading, 4)

                            
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

    }
}


//struct DetailListView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailListView()
//    }
//}
