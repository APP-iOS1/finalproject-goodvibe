//
//  SignUpView.swift
//  GukbapMinister
//
//  Created by Martin on 2023/01/16.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) var returnSigninView
    @EnvironmentObject var viewModel: UserViewModel
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Text("회원가입")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
            }//HStack
            .padding(.bottom, 25)
            //MARK: - Email
            VStack {
                HStack {
                    Text("이메일")
                    Spacer()
                }
                TextField("example@gukbab.com", text: $viewModel.signUpEmailID)
                    .textContentType(.emailAddress)
                    .border(1, .black.opacity(0.5))
                    .textInputAutocapitalization(.never)
            }
            .padding(.bottom, 5)
            //MARK: - Password
            VStack {
                HStack {
                    Text("비밀번호")
                    Spacer()
                }
                SecureField("영문, 숫자 포함 6자 이상", text: $viewModel.signUpPassword)
                    .textInputAutocapitalization(.never)
                    .border(1, .black.opacity(0.5))
            }
            .padding(.bottom, 5)
            //MARK: - Password Agin
            VStack {
                HStack {
                    Text("비밀번호 확인")
                    Spacer()
                }
                SecureField("비밀번호 확인", text: $viewModel.signUpPassword)
                    .textInputAutocapitalization(.never)
                    .border(1, .black.opacity(0.5))
            }
            .padding(.bottom, 5)
            //MARK: - User Nickname
            VStack {
                HStack {
                    Text("닉네임")
                    Spacer()
                }
                TextField("프로필 이름", text: $viewModel.signUpNickname)
                    .border(1, .black.opacity(0.5))
                    .textInputAutocapitalization(.never)
            }
            .padding(.bottom, 30)
            HStack {
                Text("국밥부장관의 이용약관과 개인정보 처리방침에 동의합니다.")
                    .foregroundColor(.black)
                    .font(.footnote)
                    .fontWeight(.bold)
                Spacer()
            }
            //MARK: - Register Button
            VStack {
                Button {
                    //회원가입 버튼
                    viewModel.signUpUser()
                } label: {
                    VStack {
                        Text("회원가입")
                            .fontWeight(.bold)
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 360, height: 60)
                            .background(.yellow)
                            .cornerRadius(7)
                    }
                }// Button VStack
            }
            //MARK: - Move to SignUpView()
            Spacer()
            HStack {
                Text("이미 계정이 있으신가요?")
                    .foregroundColor(.secondary)
                Button {
                    returnSigninView()
                } label: {
                    Text("로그인")
                }
                .fontWeight(.bold)
                .foregroundColor(.black)
            }//HStack
            //            .padding(.top,200)
        }//VStack
        .padding()
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView().environmentObject(UserViewModel())
    }
}
