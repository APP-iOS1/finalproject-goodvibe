//
//  MapCategoryModalView.swift
//  GukbapMinister
//
//  Created by 기태욱 on 2023/01/17.
//

import SwiftUI

struct MapCategoryModalView: View {
    @State private var didTap: [Bool] = [false,false,false,false,false,false,false,false,false,false,false,false]

    
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
                
                Spacer()
            }
            .padding(.leading, 20)
            .padding(.top, 15)
            .padding(.bottom, 20)
            
            VStack(alignment: .center){
                HStack{
                    Button{
                        self.didTap[0].toggle()
                    } label: {
                        Text("순대국밥")
                            .modifier(CategoryButtonModifier(isChangedButtonStyle: didTap[0]))
                    }
                    Button{
                        self.didTap[1].toggle()
                    } label: {
                        Text("돼지국밥")
                            .modifier(CategoryButtonModifier(isChangedButtonStyle: didTap[1]))
                    }
                    Button{
                        self.didTap[2].toggle()
                    } label: {
                        Text("내장탕")
                            .modifier(CategoryButtonModifier(isChangedButtonStyle: didTap[2]))
                    }
                    Button{
                        self.didTap[3].toggle()
                    } label: {
                        Text("선지국")
                            .modifier(CategoryButtonModifier(isChangedButtonStyle: didTap[3]))
                    }
                }
                .padding(4)
                
                HStack{
                    Button{
                        self.didTap[4].toggle()
                    } label: {
                        Text("소머리국밥")
                            .modifier(CategoryButtonModifier(isChangedButtonStyle: didTap[4]))
                    }
                    Button{
                        self.didTap[5].toggle()
                    } label: {
                        Text("뼈해장국")
                            .modifier(CategoryButtonModifier(isChangedButtonStyle: didTap[5]))
                    }
                    Button{
                        self.didTap[6].toggle()
                    } label: {
                        Text("수구레국밥")
                            .modifier(CategoryButtonModifier(isChangedButtonStyle: didTap[6]))
                    }
                }
                .padding(4)

                
                HStack{
                    Button{
                        self.didTap[7].toggle()
                    } label: {
                        Text("굴국밥")
                            .modifier(CategoryButtonModifier(isChangedButtonStyle: didTap[7]))
                    }
                    Button{
                        self.didTap[8].toggle()
                    } label: {
                        Text("콩나물국밥")
                            .modifier(CategoryButtonModifier(isChangedButtonStyle: didTap[8]))
                    }
                    Button{
                        self.didTap[9].toggle()
                    } label: {
                        Text("설렁탕")
                            .modifier(CategoryButtonModifier(isChangedButtonStyle: didTap[9]))
                    }
                    Button{
                        self.didTap[10].toggle()
                    } label: {
                        Text("평양온반")
                            .modifier(CategoryButtonModifier(isChangedButtonStyle: didTap[10]))
                    }
                }
                .padding(4)

                
                HStack{
                    Button{
                        self.didTap[11].toggle()
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

struct MapCategoryModalView_Previews: PreviewProvider {
    static var previews: some View {
        MapCategoryModalView()
    }
}
