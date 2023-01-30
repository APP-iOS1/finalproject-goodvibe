//
//  SignUpGukBabView.swift
//  GukbapMinister
//
//  Created by ishio on 2023/01/18.
//

import SwiftUI

struct SignUpGukBabView: View {
    @EnvironmentObject var viewModel: UserViewModel
    @State private var didTap: [Bool] = [false,false,false,false,false,false,false,false,false,false,false,false]
    
    var body: some View {
        
        VStack(alignment: .center) {
            
            Spacer()
            
            HStack {
                Text("선호하는 국밥을\n선택하세요.")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(30)
            
            HStack{
                Button{
                    self.didTap[0].toggle()
                    viewModel.gukbapsDeduplicate("순대국밥")
                } label: {
                    Text("순대국밥")
                        .modifier(CategoryButtonModifier(isChangedButtonStyle: didTap[0]))
                }
                Button{
                    self.didTap[1].toggle()
                    viewModel.gukbapsDeduplicate("돼지국밥")
                } label: {
                    Text("돼지국밥")
                        .modifier(CategoryButtonModifier(isChangedButtonStyle: didTap[1]))
                }
                Button{
                    self.didTap[2].toggle()
                    viewModel.gukbapsDeduplicate("내장탕")
                } label: {
                    Text("내장탕")
                        .modifier(CategoryButtonModifier(isChangedButtonStyle: didTap[2]))
                }
                Button{
                    self.didTap[3].toggle()
                    viewModel.gukbapsDeduplicate("선지국")
                } label: {
                    Text("선지국")
                        .modifier(CategoryButtonModifier(isChangedButtonStyle: didTap[3]))
                }
            }
            .padding(4)
            
            HStack{
                Button{
                    self.didTap[4].toggle()
                    viewModel.gukbapsDeduplicate("소머리국밥")
                } label: {
                    Text("소머리국밥")
                        .modifier(CategoryButtonModifier(isChangedButtonStyle: didTap[4]))
                }
                Button{
                    self.didTap[5].toggle()
                    viewModel.gukbapsDeduplicate("뼈해장국")
                } label: {
                    Text("뼈해장국")
                        .modifier(CategoryButtonModifier(isChangedButtonStyle: didTap[5]))
                }
                Button{
                    self.didTap[6].toggle()
                    viewModel.gukbapsDeduplicate("수구레국밥")
                } label: {
                    Text("수구레국밥")
                        .modifier(CategoryButtonModifier(isChangedButtonStyle: didTap[6]))
                }
            }
            .padding(4)
            
            
            HStack{
                Button{
                    self.didTap[7].toggle()
                    viewModel.gukbapsDeduplicate("굴국밥")
                } label: {
                    Text("굴국밥")
                        .modifier(CategoryButtonModifier(isChangedButtonStyle: didTap[7]))
                }
                Button{
                    self.didTap[8].toggle()
                    viewModel.gukbapsDeduplicate("콩나물국밥")
                } label: {
                    Text("콩나물국밥")
                        .modifier(CategoryButtonModifier(isChangedButtonStyle: didTap[8]))
                }
                Button{
                    self.didTap[9].toggle()
                    viewModel.gukbapsDeduplicate("설렁탕")
                } label: {
                    Text("설렁탕")
                        .modifier(CategoryButtonModifier(isChangedButtonStyle: didTap[9]))
                }
                Button{
                    self.didTap[10].toggle()
                    viewModel.gukbapsDeduplicate("평양온반")
                } label: {
                    Text("평양온반")
                        .modifier(CategoryButtonModifier(isChangedButtonStyle: didTap[10]))
                }
            }
            .padding(4)
            
            HStack{
                Button{
                    self.didTap[11].toggle()
                    viewModel.gukbapsDeduplicate("시레기국밥")
                } label: {
                    Text("시레기국밥")
                        .modifier(CategoryButtonModifier(isChangedButtonStyle: didTap[11]))
                }
            }
            .padding(4)
            
            Button {
                viewModel.isLoading = true
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2){
                    viewModel.signUpGukBap()
                }
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5){
                    viewModel.isLoading = false
                }
                print("state: \(viewModel.state)")
            } label: {
                Text("국밥선호 확인")
                    .font(.title3)
                    .fontWeight(.bold)
                    .frame(width: 340, height: 60)
                    .foregroundColor(.white)
                    .background(Color("AccentColor"))
                    .cornerRadius(5)
            }
            .padding(30)
            
            Spacer()
        }//VStack
        .overlay(content: {
            LoadingView(show: $viewModel.isLoading)
        })
    }
}

struct SignUpGukBabView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpGukBabView().environmentObject(UserViewModel())
    }
}
