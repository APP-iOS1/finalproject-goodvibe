//
//  SearchView.swift
//  GukbapMinister
//
//  Created by 전혜성 on 2023/01/20.
//

import SwiftUI

struct SearchView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var searchGukBap: String = ""
    
    @FocusState private var isFocused: Bool
    
    let gukbapShops = ["곰달래감자탕", "양천뼈다귀본점", "망원동돼지국밥", "양평해장국", "서울돼지국밥"]
    @State private var  result: [String] = []
    
    var body: some View {
        
            ScrollView{
                VStack {
                    HStack{
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.backward")
                        }
                        
                        VStack {
                            Section{
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(.secondary)
                                        .padding(.leading, 15)
                                    TextField("국밥집 검색",text: $searchGukBap, axis: .horizontal)
                                        .keyboardType(.default)
                                        .onChange(of: searchGukBap) { name in
                                            result = gukbapShops.filter{ $0.contains(name) }
                                        }
                                    
                                }
                            }
                            .frame(width: 250, height: 50)
                            .background(Capsule().fill(Color.white))
                            .overlay {
                                Capsule()
                                    .stroke(.yellow)
                            }
                        }
                        
                        Spacer()
                        
                        Button{
                            // TODO - 검색 확인을 눌렀을 때 검색 실행
                        } label: {
                            Text("확인")
                                .foregroundColor(.white)
                        }
                        .frame(width: 65, height: 50)
                        .background(.yellow)
                        .cornerRadius(25)
                    }
                    .padding(.horizontal, 18)
                    VStack {
                        List {
                            ForEach(result, id: \.self) { name in
                                Text("\(name)")
                            }
                            
                        }
                        
                    }
                }
            }
        
        .onAppear {
           //키보드 나타나게 하기 & 텍스트 필드 클릭된 상태 유지해야됨( seachView 전 View에서 텍스트필드 클릭한 값이 전달이 되질 않음
        }
        .onDisappear {
            hideKeyboard()
        }
        .onTapGesture {
            hideKeyboard()
        }
        .searchable(text: $searchGukBap, placement: .navigationBarDrawer(displayMode: .always))
        Spacer()
    }
    
        

}


// 키보드 내리는 함수
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

//struct SearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchView()
//    }
//}
