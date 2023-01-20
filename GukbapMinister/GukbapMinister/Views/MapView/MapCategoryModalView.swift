//
//  MapCategoryModalView.swift
//  GukbapMinister
//
//  Created by 기태욱 on 2023/01/17.
//

import SwiftUI

struct MapCategoryModalView: View {
    @State private var didTap: [Bool] = [false,false,false,false,false,false,false,false,false,false,false,false]
    @EnvironmentObject var viewModel: UserViewModel
    @Binding var showModal: Bool
    var body: some View {
        VStack{
            Capsule()
                .fill(Color.secondary)
                .frame(width: 50, height: 5)
                .padding(10)
            
            HStack{
                Text("국밥종류")
                    .font(.title2)
                    .bold()
                    .padding(.horizontal, 30)
                Button {
                    showModal.toggle()
                    
                } label: {
                    Text("저장")
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(width: 80, height: 40)
                        .foregroundColor(.white)
                        .background(Color("AccentColor"))
                        .cornerRadius(5)
                }
                Spacer()
                
            }
            .padding(.leading, 20)
            .padding(.top, 15)
            .padding(.bottom, 20)
            
            VStack(alignment: .center){
                HStack{
                    Button{
                        self.didTap[0].toggle()
                        viewModel.gukbapsFilter("순대국밥")
                        didTap[1] = false
                        didTap[2] = false
                        didTap[3] = false
                        didTap[4] = false
                        didTap[5] = false
                        didTap[6] = false
                        didTap[7] = false
                        didTap[8] = false
                        didTap[9] = false
                        didTap[10] = false
                        didTap[11] = false
                    } label: {
                        Text("순대국밥")
                            .modifier(CategoryButtonModifier(isChangedButtonStyle: didTap[0]))
                    }
                    Button{
                        self.didTap[1].toggle()
                        viewModel.gukbapsFilter("돼지국밥")
                        didTap[0] = false
                        didTap[2] = false
                        didTap[3] = false
                        didTap[4] = false
                        didTap[5] = false
                        didTap[6] = false
                        didTap[7] = false
                        didTap[8] = false
                        didTap[9] = false
                        didTap[10] = false
                        didTap[11] = false
                    } label: {
                        Text("돼지국밥")
                            .modifier(CategoryButtonModifier(isChangedButtonStyle: didTap[1]))
                    }
                    Button{
                        self.didTap[2].toggle()
                        viewModel.gukbapsFilter("내장탕")
                        didTap[0] = false
                        didTap[1] = false
                        didTap[3] = false
                        didTap[4] = false
                        didTap[5] = false
                        didTap[6] = false
                        didTap[7] = false
                        didTap[8] = false
                        didTap[9] = false
                        didTap[10] = false
                        didTap[11] = false
                    } label: {
                        Text("내장탕")
                            .modifier(CategoryButtonModifier(isChangedButtonStyle: didTap[2]))
                    }
                    Button{
                        self.didTap[3].toggle()
                        viewModel.gukbapsFilter("선지국")
                        didTap[0] = false
                        didTap[1] = false
                        didTap[2] = false
                        didTap[4] = false
                        didTap[5] = false
                        didTap[6] = false
                        didTap[7] = false
                        didTap[8] = false
                        didTap[9] = false
                        didTap[10] = false
                        didTap[11] = false
                    } label: {
                        Text("선지국")
                            .modifier(CategoryButtonModifier(isChangedButtonStyle: didTap[3]))
                    }
                }
                .padding(4)
                
                HStack{
                    Button{
                        self.didTap[4].toggle()
                        viewModel.gukbapsFilter("소머리국밥")
                        didTap[0] = false
                        didTap[1] = false
                        didTap[2] = false
                        didTap[3] = false
                        didTap[5] = false
                        didTap[6] = false
                        didTap[7] = false
                        didTap[8] = false
                        didTap[9] = false
                        didTap[10] = false
                        didTap[11] = false
                    } label: {
                        Text("소머리국밥")
                            .modifier(CategoryButtonModifier(isChangedButtonStyle: didTap[4]))
                    }
                    Button{
                        self.didTap[5].toggle()
                        viewModel.gukbapsFilter("뼈해장국")
                        didTap[0] = false
                        didTap[1] = false
                        didTap[2] = false
                        didTap[3] = false
                        didTap[4] = false
                        didTap[6] = false
                        didTap[7] = false
                        didTap[8] = false
                        didTap[9] = false
                        didTap[10] = false
                        didTap[11] = false
                    } label: {
                        Text("뼈해장국")
                            .modifier(CategoryButtonModifier(isChangedButtonStyle: didTap[5]))
                    }
                    Button{
                        self.didTap[6].toggle()
                        viewModel.gukbapsFilter("수구레국밥")
                        didTap[0] = false
                        didTap[1] = false
                        didTap[2] = false
                        didTap[3] = false
                        didTap[4] = false
                        didTap[5] = false
                        didTap[7] = false
                        didTap[8] = false
                        didTap[9] = false
                        didTap[10] = false
                        didTap[11] = false
                    } label: {
                        Text("수구레국밥")
                            .modifier(CategoryButtonModifier(isChangedButtonStyle: didTap[6]))
                    }
                }
                .padding(4)
                
                
                HStack{
                    Button{
                        self.didTap[7].toggle()
                        viewModel.gukbapsFilter("굴국밥")
                        didTap[0] = false
                        didTap[1] = false
                        didTap[2] = false
                        didTap[3] = false
                        didTap[4] = false
                        didTap[5] = false
                        didTap[6] = false
                        didTap[8] = false
                        didTap[9] = false
                        didTap[10] = false
                        didTap[11] = false
                    } label: {
                        Text("굴국밥")
                            .modifier(CategoryButtonModifier(isChangedButtonStyle: didTap[7]))
                    }
                    Button{
                        self.didTap[8].toggle()
                        didTap[0] = false
                        didTap[1] = false
                        didTap[2] = false
                        didTap[3] = false
                        didTap[4] = false
                        didTap[5] = false
                        didTap[6] = false
                        didTap[7] = false
                        didTap[9] = false
                        didTap[10] = false
                        didTap[11] = false
                    } label: {
                        Text("콩나물국밥")
                            .modifier(CategoryButtonModifier(isChangedButtonStyle: didTap[8]))
                    }
                    Button{
                        self.didTap[9].toggle()
                        viewModel.gukbapsFilter("설렁탕")
                        didTap[0] = false
                        didTap[1] = false
                        didTap[2] = false
                        didTap[3] = false
                        didTap[4] = false
                        didTap[5] = false
                        didTap[6] = false
                        didTap[7] = false
                        didTap[8] = false
                        didTap[10] = false
                        didTap[11] = false
                    } label: {
                        Text("설렁탕")
                            .modifier(CategoryButtonModifier(isChangedButtonStyle: didTap[9]))
                    }
                    Button{
                        self.didTap[10].toggle()
                        viewModel.gukbapsFilter("평양온반")
                        didTap[0] = false
                        didTap[1] = false
                        didTap[2] = false
                        didTap[3] = false
                        didTap[4] = false
                        didTap[5] = false
                        didTap[6] = false
                        didTap[7] = false
                        didTap[8] = false
                        didTap[9] = false
                        didTap[11] = false
                    } label: {
                        Text("평양온반")
                            .modifier(CategoryButtonModifier(isChangedButtonStyle: didTap[10]))
                    }
                }
                .padding(4)
                
                
                HStack{
                    Button{
                        self.didTap[11].toggle()
                        viewModel.gukbapsFilter("시레기국밥")
                        didTap[0] = false
                        didTap[1] = false
                        didTap[2] = false
                        didTap[3] = false
                        didTap[4] = false
                        didTap[5] = false
                        didTap[6] = false
                        didTap[7] = false
                        didTap[8] = false
                        didTap[9] = false
                        didTap[10] = false
                    } label: {
                        Text("시레기국밥")
                            .modifier(CategoryButtonModifier(isChangedButtonStyle: didTap[11]))
                    }
                }
                .padding(4)
                
                
            }
            
            Spacer()
        }
    }
}

//struct MapCategoryModalView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapCategoryModalView(showModal: false)
//    }
//}
