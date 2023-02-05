//
//  SignUpInfoView.swift
//  GukbapMinister
//
//  Created by ishio on 2023/01/18.
//

import SwiftUI

struct SignUpInfoView: View {
    @EnvironmentObject var viewModel: UserViewModel
    @State var isGenderSelected: [Bool] = [false, false, false]
    @State var isAgeRangeSelected: [Bool] = [false, false, false, false]
    @State var isPreferenceAreaSelected: [Bool] = [false, false, false]
    
    @Binding var selection: Int
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("안녕하세요 \(viewModel.signUpNickname)님!")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 70)
                Text("나머지 정보를 입력해주세요.")
                    .font(.title)
                    .fontWeight(.bold)
                
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
                            viewModel.gender = "남자"
                        } label: {
                            Text("남자")
                        }
                        .categoryCapsule(isChanged: isGenderSelected[1])

                        Button {
                            isGenderSelected[2].toggle()
                            isGenderSelected[1] = false
                            viewModel.gender = "여자"
                        } label: {
                            Text("여자")
                        }
                        .categoryCapsule(isChanged: isGenderSelected[2])
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
                                viewModel.ageRange = 0
                            } label: {
                                Text("10대")
                            }
                            .frame(width: 60)
                            .categoryCapsule(isChanged: isAgeRangeSelected[0])
                            
                            Button {
                                isAgeRangeSelected[1].toggle()
                                isAgeRangeSelected[0] = false
                                isAgeRangeSelected[2] = false
                                isAgeRangeSelected[3] = false
                                viewModel.ageRange = 1
                            } label: {
                                Text("20 ~ 30대")
                            }
                            .frame(width: 95)
                            .categoryCapsule(isChanged: isAgeRangeSelected[1])
                            Button {
                                isAgeRangeSelected[2].toggle()
                                isAgeRangeSelected[0] = false
                                isAgeRangeSelected[1] = false
                                isAgeRangeSelected[3] = false
                                viewModel.ageRange = 2
                            } label: {
                                Text("40 ~ 50대")
                            }
                            .frame(width: 95)
                            .categoryCapsule(isChanged: isAgeRangeSelected[2])
                        }
                        HStack{
                            Button {
                                isAgeRangeSelected[3].toggle()
                                isAgeRangeSelected[0] = false
                                isAgeRangeSelected[1] = false
                                isAgeRangeSelected[2] = false
                                viewModel.ageRange = 3
                            } label: {
                                Text("60대 이상")
                            }
                            .frame(width: 90)
                            .categoryCapsule(isChanged: isAgeRangeSelected[3])
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
                        .categoryCapsule(isChanged: isPreferenceAreaSelected[0])
                       
                        Button {
                            isPreferenceAreaSelected[1].toggle()
                        } label: {
                            Text("강서구")
                        }
                        .categoryCapsule(isChanged: isPreferenceAreaSelected[1])
                        Button {
                            isPreferenceAreaSelected[2].toggle()
                        } label: {
                            Text("부산진구")
                        }
                        .categoryCapsule(isChanged: isPreferenceAreaSelected[2])
                    }
                }
            }
            .padding()
            Button {
                SignUpGukBabView()
                viewModel.signUpInfo()
                self.selection = 3

            } label: {
                Text("다음 단계로 넘어가기")
                    .foregroundColor(.white)
            }
            .font(.title3)
            .fontWeight(.bold)
            .frame(width: 340, height: 60)
            .background(Color("AccentColor"))
            .cornerRadius(5)
            .padding(.bottom, 180)
            Spacer()
        }
        
    }
}

//struct SignUpInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignUpInfoView()
//    }
//}
