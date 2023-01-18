//
//  SignUpInfoView.swift
//  GukbapMinister
//
//  Created by ishio on 2023/01/18.
//

import SwiftUI

struct SignUpInfoView: View {
    @StateObject var viewModel: UserViewModel = UserViewModel()
    @State var isGenderSelected: [Bool] = [false, false, false]
    @State var isAgeRangeSelected: [Bool] = [false, false, false, false, false]
    @State var isPreferenceAreaSelected: [Bool] = [false, false, false]
    
    @Binding var selection: Int
    
    var body: some View {
        VStack {
            SignUpProcessView(index: 2)
            VStack(alignment: .leading) {
                Text("안녕하세요 [닉네임]님!")
                    .font(.title)
                    .padding(.top, 70)
                Text("나머지 정보를 입력해주세요.")
                    .font(.title)
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("성별")
                        Text("선택사항")
                            .foregroundColor(.gray)
                            .font(.system(size: 12))
                    }
                    HStack {
                        Button {
                            isGenderSelected[1].toggle()
                            isGenderSelected[2] = false
                        } label: {
                            Text("남자")
                        }
                        .modifier(CategoryButtonModifier(isChangedButtonStyle: isGenderSelected[1]))
                        Button {
                            isGenderSelected[2].toggle()
                            isGenderSelected[1] = false
                        } label: {
                            Text("여자")
                        }
                        .modifier(CategoryButtonModifier(isChangedButtonStyle: isGenderSelected[2]))
                    }
                }
                .padding(.vertical)
                
                VStack(alignment: .leading){
                    HStack{
                        Text("연령대")
                        Text("선택사항")
                            .foregroundColor(.gray)
                            .font(.system(size: 12))
                    }
                    VStack(alignment: .leading){
                        HStack{
                            Button {
                                isAgeRangeSelected[0].toggle()
                                isAgeRangeSelected[1] = false
                                isAgeRangeSelected[2] = false
                                isAgeRangeSelected[3] = false
                                isAgeRangeSelected[4] = false
                            } label: {
                                Text("10대")
                            }
                            .frame(width: 60)
                            .modifier(CategoryButtonModifier(isChangedButtonStyle: isAgeRangeSelected[0]))
                            Button {
                                isAgeRangeSelected[1].toggle()
                                isAgeRangeSelected[0] = false
                                isAgeRangeSelected[2] = false
                                isAgeRangeSelected[3] = false
                                isAgeRangeSelected[4] = false
                            } label: {
                                Text("20대")
                            }
                            .frame(width: 60)
                            .modifier(CategoryButtonModifier(isChangedButtonStyle: isAgeRangeSelected[1]))
                            Button {
                                isAgeRangeSelected[2].toggle()
                                isAgeRangeSelected[0] = false
                                isAgeRangeSelected[1] = false
                                isAgeRangeSelected[3] = false
                                isAgeRangeSelected[4] = false
                            } label: {
                                Text("30대")
                            }
                            .frame(width: 60)
                            .modifier(CategoryButtonModifier(isChangedButtonStyle: isAgeRangeSelected[2]))
                        }
                        HStack{
                            Button {
                                isAgeRangeSelected[3].toggle()
                                isAgeRangeSelected[0] = false
                                isAgeRangeSelected[1] = false
                                isAgeRangeSelected[2] = false
                                isAgeRangeSelected[4] = false
                            } label: {
                                Text("40대")
                            }
                            .frame(width: 60)
                            .modifier(CategoryButtonModifier(isChangedButtonStyle: isAgeRangeSelected[3]))
                            Button {
                                isAgeRangeSelected[4].toggle()
                                isAgeRangeSelected[0] = false
                                isAgeRangeSelected[1] = false
                                isAgeRangeSelected[2] = false
                                isAgeRangeSelected[3] = false
                            } label: {
                                Text("50대이상")
                            }
                            .frame(width: 65)
                            .modifier(CategoryButtonModifier(isChangedButtonStyle: isAgeRangeSelected[4]))
                        }
                    }
                }
                .padding(.bottom)
                VStack(alignment: .leading){
                    HStack{
                        Text("선호 지역")
                        Text("현재는 서울, 부산 지역에서 정보를 제공합니다.")
                            .foregroundColor(.gray)
                            .font(.system(size: 12))
                    }
                    TextField("선호 지역", text: $viewModel.preferenceArea)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    HStack{
                        Button {
                            isPreferenceAreaSelected[0].toggle()
                        } label: {
                            Text("강남구")
                        }
                        .modifier(CategoryButtonModifier(isChangedButtonStyle: isPreferenceAreaSelected[0]))
                        Button {
                            isPreferenceAreaSelected[1].toggle()
                        } label: {
                            Text("강서구")
                        }
                        .modifier(CategoryButtonModifier(isChangedButtonStyle: isPreferenceAreaSelected[1]))
                        Button {
                            isPreferenceAreaSelected[2].toggle()
                        } label: {
                            Text("부산진구")
                        }
                        .modifier(CategoryButtonModifier(isChangedButtonStyle: isPreferenceAreaSelected[2]))
                    }
                }
            }
            .padding()
            Button {
                SignUpGukBabView()
                viewModel.signUpInfo()
                self.selection = 2
            } label: {
                Text("다음 단계로 넘어가기")
                    .foregroundColor(.black)
            }
            .frame(width: 300, height: 40)
            .modifier(CategoryButtonModifier(isChangedButtonStyle: true))
            //            .modifier(CategoryButtonModifier(color: .yellow))
            .padding(.vertical)
            Spacer()
        }
    }
}

//struct SignUpInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignUpInfoView()
//    }
//}
