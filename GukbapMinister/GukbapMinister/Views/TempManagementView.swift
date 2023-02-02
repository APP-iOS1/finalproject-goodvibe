//
//  TempManagementView.swift
//  GukbapMinister
//
//  Created by Martin on 2023/01/20.
//

import SwiftUI
import PhotosUI
import Shimmer



enum ManagementAction {
    case delete
    case done
    case cancel
}


struct StoreRegistrationView: View {
    @Binding var isOn: Bool
    
    @ObservedObject var viewModel: StoreRegistrationViewModel = StoreRegistrationViewModel()
    
    @State private var menuCount: Int = 1
    @State private var menuName: String = ""
    @State private var menuPrice: String = ""
    

    
    
    var completionHandler: ((Result<ManagementAction, Error>) -> Void)?
    
    
    let formatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter
        }()
    
    let amountFormatter: NumberFormatter = {
              let formatter = NumberFormatter()
              formatter.zeroSymbol = ""
              return formatter
         }()
    
    var body: some View {
        Form {
            Section {
                TextField("상호명을 입력해 주세요", text: $viewModel.store.storeName)
                TextField("주소를 입력해 주세요", text: $viewModel.store.storeAddress)
            } header: {
                Text("국밥집 정보")
                    .font(.headline)
            }
            
            Section {
                HStack {
                    Text("위도")
                        .font(.headline)
                    TextField("위도를 입력해 주세요", text: $viewModel.latitude)
                        
                    Text("경도")
                        .font(.headline)
                    TextField("경도를 입력해 주세요", text: $viewModel.longitude)
                        
                }
            } header: {
                Text("좌표(임시)")
                    .font(.headline)
            }
            
            Section {
                storeImageUpload
            } header: {
                Text("국밥집 사진")
                    .font(.headline)
            }
            
            Section {
                HStack {
                    VStack(alignment: .leading) {
                        Text("메뉴")
                            .font(.headline)
                        TextField("메뉴이름 입력", text: $menuName )
                    }
                    VStack(alignment: .leading) {
                        Text("가격")
                            .font(.headline)
                        HStack {
                            TextField("가격 입력", text: $menuPrice)
                            Text("원")
                        }
                    }
                }
                
                HStack {
                    Spacer()
                    Button {
                        viewModel.store.menu[menuName] =  menuPrice + "원"
                        menuName = ""
                        menuPrice = ""
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle")
                            Text("메뉴 추가하기")
                        }
                    }
                    .disabled(menuName.isEmpty || menuPrice.isEmpty)
                    Spacer()
                }
            } header: {
                Text("메뉴")
                    .font(.headline)
            }
            
            Section {
                ForEach(viewModel.store.menu.sorted(by: >), id: \.key) { menu, price in
                    HStack {
                        Text(menu)
                        Spacer()
                        Text(price)
                        Spacer()
                        Button {
                            viewModel.store.menu.removeValue(forKey: menu)
                        } label: {
                            Image(systemName: "x.circle.fill")
                                .foregroundColor(.black)
                        }
                    }
                }
            }
            
            Section {
                TextField("국밥집 설명 입력하기", text: $viewModel.store.description)
            } header: {
                Text("국밥집 설명")
                    .font(.headline)
            }
            
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("취소") {
                    isOn.toggle()
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("등록") {
                    viewModel.handleDoneTapped()
                    isOn.toggle()
                }
            }
        }
        
        
    }
}


extension StoreRegistrationView {
    var storeImageUpload: some View {
        HStack {
            VStack(alignment: .center){
                PhotosPicker(
                    selection: $viewModel.selectedImages,
                    maxSelectionCount: 5,
                    matching: .images,
                    photoLibrary: . shared()){
                        Image(systemName: "camera")
                            .foregroundColor(.mainColor)
                            .font(.system(size: 25))
                            .frame(width:70, height: 40, alignment: .center)
                        
                        
                        
                    }//photoLibrary
                HStack{
                    if viewModel.selectedImages.count == 0{
                        Text("\(viewModel.selectedImages.count)")
                            .font(.callout)
                            .foregroundColor(viewModel.selectedImages.count == 0 ? .gray : .mainColor)
                            .fontWeight(.regular)
                            .padding(.trailing,-8)
                        Text("/5")
                            .font(.callout)
                            .fontWeight(.regular)
                    }
                    else {
                        Text("\(viewModel.selectedImages.count)")
                            .font(.callout)
                            .foregroundColor(viewModel.selectedImages.count == 0 ? .gray : .black)
                            .fontWeight(.regular)
                            .padding(.trailing,-8)
                            .shimmering(
                                animation: .easeInOut(duration: 2).repeatCount(20, autoreverses: false).delay(1)
                            )
                        Text("/5")
                            .font(.callout)
                            .fontWeight(.regular)
                    }
                }
                .tracking(5)
                .padding(.bottom,10)
                .padding(.top,-10)
                .padding(.leading,4)
            }
            .background(RoundedRectangle(cornerRadius: 5.0).stroke(Color.mainColor,lineWidth: 1.5))
            .onChange(of: viewModel.selectedImages) { items in
                //선택된 이미지 없으면 배열 초기화
                if items.isEmpty { viewModel.selectedImageData = [] }
                
                for item in items {
                    Task {
                        viewModel.selectedImageData = []
                        if let data = try? await
                            item.loadTransferable(type: Data.self) {
                            viewModel.selectedImageData.append(data)
                            
                        }
                    }//Task
                }//for
            }//.onChanged
            .padding(.leading,7)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    // 선택된 이미지 출력.
                  //  ForEach(selectedImageData, id: \.self) { imageData in
                    ForEach(Array(viewModel.selectedImageData.enumerated()), id: \.offset) { index, imageData in
                            if let image = UIImage(data: imageData) {
                                NavigationLink {
                                    ImageDetailView()
                                }
                                label:{
                                    Image(uiImage: image)
                                        .resizable()
                                        .cornerRadius(4)
                                    // .scaledToFit()
                                        .frame(width: 70,height: 70)
                                        .overlay(alignment: .topTrailing) {
                                            Button(action: {
                                                viewModel.selectedImageData.remove(at:index)
                                                viewModel.selectedImages.remove(at: index)
                                                
                                            }) {
                                                Circle()
                                                    .frame(width: 17, height: 17)
                                                    .foregroundColor(.black)
                                                    .overlay {
                                                        Image(systemName: "xmark")
                                                            .font(.system(size: 12))
                                                            .foregroundColor(.white)
                                                    }
                                                
                                                
                                            }
                                            
                                        }//overlay
                                }
                               
                                
                                 //.offset(x: 5, y: -5)
                                
                                    .overlay(alignment: .bottom) {
                                        if (viewModel.selectedImages.first != nil) {
                                            if (viewModel.selectedImageData.first != nil) {
                                                if index == 0 {
                                                    Text("대표 사진")
                                                        .font(.system(size:12))
                                                        .fontWeight(.regular)
                                                        .frame(maxWidth: .infinity)
                                                        .frame(height: 20)
                                                        .foregroundColor(Color.white)
                                                        .background { Color.black }
                                                        .cornerRadius(4)
                                                }
                                            }
                                        }
                                    }
                            } // if let
                        
                    } // FirstForEach

                } // HStack
            }//ScrollView
            .frame(height: 70)
        } // HStack
    }
}

struct StoreRegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        StoreRegistrationView(isOn: .constant(true) ,viewModel: StoreRegistrationViewModel())
    }
}
