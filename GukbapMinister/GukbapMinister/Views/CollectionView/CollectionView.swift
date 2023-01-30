//
//  CollectionView.swift
//  GukbapMinister
//
//  Created by Martin on 2023/01/16.
//

import SwiftUI

struct CollectionView: View {
    @EnvironmentObject private var testVM : LocationViewModel
    
    
    var body: some View {
        NavigationStack{
            ScrollView{
                ForEach(testVM.locations, id: \.self) { testData in
                    cell(cellData: testData)
                        .zIndex(1)
                    Divider()
                }
            }
            
            .navigationTitle("내가 찜한 곳")
            .navigationBarTitleDisplayMode(.inline)
            
        }
        
    }
}

struct cell : View {
    @State private var isHeart : Bool = false
    
    var cellData : Store
    
    var body: some View {
        
        
        VStack {
            NavigationLink {
                DetailView()
            } label: {
                HStack (alignment: .center){
                    
                    AsyncImage(url: URL(string: cellData.storeImages[0])) { image in
                        image
                            .resizable()
                        //.scaledToFit()
                    } placeholder: {
                        Color.gray.opacity(0.1)
                    }
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
                                isHeart.toggle()
                            } label: {
                                Image(systemName: isHeart ? "heart.fill" : "heart")
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
    }
}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView()
    }
}
