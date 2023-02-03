//
//  MapCategoryModalView.swift
//  GukbapMinister
//
//  Created by 기태욱 on 2023/01/17.
//

import SwiftUI

//enum Gukbaps: String, CaseIterable {
//    case 순대국밥 = "순대국밥"
//    case 돼지국밥
//    case 내장탕
//    case 선지국
//    case 소머리국밥
//    case 뼈해장국
//    case 굴국밥
//    case 콩나물국밥
//    case 설렁탕
//    case 평양온반
//    case 시레기국밥
//}



struct GukbapCategoryFilteringView: View {
    enum Mode {
        case map, myPage
    }
    
    @Binding var showModal: Bool
    @State private var didTap: [Bool] = Array(repeating: false, count: Gukbaps.allCases.count)
    var mode: Mode = .map
    
    var body: some View {
        VStack{
            HStack{
                Text("국밥종류")
                    .font(.title2)
                    .bold()
                Spacer()
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 12)
            
            VStack(alignment: .center){
                buttonsSlicedByRange(0,3)
                buttonsSlicedByRange(4,6)
                buttonsSlicedByRange(7,10)
                buttonsSlicedByRange(11,11)
            }
            
            Spacer()
        }
        .toolbar {
            ToolbarItemGroup(placement: .principal) {
                VStack {
                    HStack {
                        Button {
                            didTap = Array(repeating: false, count: Gukbaps.allCases.count)
                            
                        } label: {
                            Text("필터해제")
                        }
                        Spacer()
                        Button {
                            showModal.toggle()
                        } label: {
                            Text("저장")
                        }
                    }
                    Divider()
                }
            }
        }
    }
}

extension GukbapCategoryFilteringView {
    
    @ViewBuilder
    private func buttonsSlicedByRange(_ start: Int, _ end: Int) -> some View {
        HStack{
            ForEach(Array(Gukbaps.allCases.enumerated())[start...end], id: \.offset) { index, gukbap in
                Button{
                    didTap[index].toggle()
                } label: {
                    Text(gukbap.rawValue)
                        .modifier(CategoryButtonModifier(isChangedButtonStyle: didTap[index]))
                }
            }
        }
        .padding(4)
    }
}

struct GukbapCategoryFilteringView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            GukbapCategoryFilteringView(showModal: .constant(false), mode: .map)
        }
    }
}
