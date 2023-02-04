//
//  MapCategoryModalView.swift
//  GukbapMinister
//
//  Created by 기태욱 on 2023/01/17.
//

import SwiftUI

struct GukbapCategoryFilteringView: View {
    enum Mode {
        case map, myPage
    }
    
    @Binding var showModal: Bool
    @EnvironmentObject var mapViewModel: MapViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    
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
                getButtonsSlicedByRange(0,3)
                getButtonsSlicedByRange(4,6)
                getButtonsSlicedByRange(7,10)
                getButtonsSlicedByRange(11,11)
            }
            
            Spacer()
        }
        .toolbar {
            ToolbarItemGroup(placement: mode == .map ? .principal : .bottomBar) {
                toolbarItemContent
            }
        }
    }
}

extension GukbapCategoryFilteringView {
    
    @ViewBuilder
    private func getButtonsSlicedByRange(_ start: Int, _ end: Int) -> some View {
        HStack{
            ForEach(Array(Gukbaps.allCases.enumerated())[start...end], id: \.offset) { index, gukbap in
                Button{
                    handleFilteredGukbaps(index: index, gukbap: gukbap)
                } label: {
                    Text(gukbap.rawValue)
                        .modifier(CategoryButtonModifier(isChangedButtonStyle: didTap[index]))
                }
            }
        }
        .padding(4)
    }
    
    private var toolbarItemContent: some View {
            VStack {
                if mode == .myPage {
                    Divider()
                }
                
                HStack {
                    Button {
                        didTap = Array(repeating: false, count: Gukbaps.allCases.count)
                        switch mode {
                        case .map: mapViewModel.filterdGukbaps = []
                        case .myPage: userViewModel.filterdGukbaps = []
                        }
                    } label: {
                        Text("필터해제")
                    }
                    Spacer()
                    Button {
                        showModal.toggle()
                    } label: {
                        Text("확인")
                    }
                }
                
                if mode == .map {
                    Divider()
                }
                    
            }
    }
}



extension GukbapCategoryFilteringView {
    private func handleFilteredGukbaps(index: Int, gukbap: Gukbaps) {
        didTap[index].toggle()
        switch mode {
        case .map:
            if mapViewModel.filterdGukbaps.contains(gukbap) {
                mapViewModel.filterdGukbaps.remove(at: mapViewModel.filterdGukbaps.firstIndex(of: gukbap)!)
            } else {
                mapViewModel.filterdGukbaps.append(gukbap)
            }
        case .myPage: print("아직몰루")
        }
    }
}

struct GukbapCategoryFilteringView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            GukbapCategoryFilteringView(showModal: .constant(false), mode: .map)
        }
        .environmentObject(MapViewModel())
        .environmentObject(UserViewModel())
    }
}
