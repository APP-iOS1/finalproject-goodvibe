//
//  CreateReviewView.swift
//  GukbapMinister
//
//  Created by 이원형 on 2023/01/17.
//

import SwiftUI
import PhotosUI
import PopupView

struct CreateReviewView: View {
    @State private var selectedImages: [PhotosPickerItem] = []
    @State private var selectedImageData: [Data] =  []
    @State private var isReviewAdded: Bool = false
    @State private var reviewText: String = ""
    
    @State var selected = 0
    
    var trimReviewText: String {
        reviewText.trimmingCharacters(in: .whitespaces)
    }
    var images: [UIImage]  {
        var uiImages: [UIImage] = []
        if !selectedImageData.isEmpty {
            for imageData in selectedImageData {
                if let image = UIImage(data: imageData) {
                    uiImages.append(image)
                }
            }
        }
        return uiImages
    }
    
    var body: some View {
        NavigationStack {
            VStack{
                VStack{
                    HStack{
                        Spacer()
                        Text("")
                        Spacer()
                    }
                    HStack(spacing: 25){
                        Spacer()
                        ForEach(0..<5){ i in
                            Image(systemName: "star.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(self.selected >= i ? .yellow : .gray)
                                .onTapGesture {
                                    self.selected = i
                                    
                                }
                        }
                        Spacer()
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                    Text("\(selected + 1) / \(5)")
                        .font(.system(size: 17))
                        .fontWeight(.semibold)
                }
                .padding(.top,30)
                HStack {
                    
                    PhotosPicker(
                        selection: $selectedImages,
                        matching: .images,
                        photoLibrary: . shared()){
                            
                            Image(systemName: "camera")
                                .foregroundColor(.yellow)
                                .font(.system(size: 30))
                                .frame(width:70, height: 70, alignment: .center)
                            
                        }//photoLibrary
                        .background(RoundedRectangle(cornerRadius: 5.0).stroke(Color.yellow,lineWidth: 1.5))
                        .onChange(of: selectedImages) { items in
                            //선택된 이미지 없으면 배열 초기화
                            if items.isEmpty { selectedImageData = [] }
                            
                            for item in items {
                                Task {
                                    selectedImageData = []
                                    if let data = try? await
                                        item.loadTransferable(type: Data.self) {
                                        selectedImageData.append(data)
                                        
                                    }
                                }//Task
                            }//for
                        }//.onChanged
                        .padding(.leading,7)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            // 선택된 이미지 출력.
                            ForEach(selectedImageData, id: \.self) { imageData in
                                if let image = UIImage(data: imageData) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .cornerRadius(4)
                                    // .scaledToFit()
                                        .frame(width: 80,height: 80)
                                } // if let
                            } // ForEach
                        } // HStack
                    }//ScrollView
                } // HStack
                .padding(EdgeInsets(top: 30, leading: 20, bottom: 50, trailing: 20))
                VStack {
                    Section {

                        TextField("작성된 리뷰는 장소상세에서 우리 모두가 확인할 수 있습니다.국밥 같은 따듯한 마음을 나눠주세요.", text: $reviewText, axis: .vertical)
                            .frame(width: 300, height: 250, alignment: .center)
                            .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
                            .background(RoundedRectangle(cornerRadius: 5.0).stroke(Color.yellow, lineWidth:1.5))
                            .multilineTextAlignment(.leading)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                      
                            .lineLimit(11...)
                           
                        
                    }
                    
                    
                    .navigationTitle("농민백암순대")
                    .navigationBarTitleDisplayMode(.inline)
                  
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("취소") {
                            }
                        }
                        if trimReviewText.count > 0 {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("등록") {
                                    Task{
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                            NavigationLink {
                                                ExploreView()
                                            }
                                        label:{
                                            ExploreView()
                                        }
                                        }
                                        isReviewAdded.toggle()
                                    }
                                }
                            }
                        }//if
                    }//toolbar
                    
                }//VStack
                Spacer()
                .popup(isPresented: $isReviewAdded) {
                    HStack {
                        Image(systemName: "checkmark")
                            .foregroundColor(.white)
                        Text("리뷰가 작성되었습니다.")
                            .foregroundColor(.white)
                            .font(.footnote)
                            .bold()
                    }
                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                    .background(Color.yellow)
                    .cornerRadius(100)
                } customize: {
                    $0
                        .autohideIn(2)
                        .type(.floater())
                        .position(.top)
                } // popup
            }
        }
    }
}
//struct CreateReviewView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateReviewView()
//    }
//}
