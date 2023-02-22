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
    @Binding var selection: Int
    @State var signUpPassword: String = ""
    @State var passwordValidationString: String = ""
    @State var isPasswordValidation: Bool = false
    
    @State var userRulesView: Bool = false
    @State var appRulesView: Bool = false
    
    var body: some View {
        GeometryReader { proxy in
            
            let width = proxy.size.width
            let height = proxy.size.height
            
            VStack {
                HStack {
                    Text("회원가입")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }//HStack
                .padding(.bottom, 15)
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
                    SecureField("영문, 숫자 포함 6자 이상", text: $signUpPassword)
                        .textInputAutocapitalization(.never)
                        .border(1, .black.opacity(0.5))
                }
                .padding(.bottom, 5)
                //MARK: - Password Agin
                VStack {
                    HStack {
                        Text("비밀번호 확인")
                        Spacer()
                        Text(passwordValidationString)
                            .foregroundColor(self.isPasswordValidation ? .green : .red)
                    }
                    SecureField("비밀번호 확인", text: $viewModel.signUpPassword)
                        .textInputAutocapitalization(.never)
                        .border(1, .black.opacity(0.5))
                        .onChange(of: viewModel.signUpPassword) { newValue in
                            if self.signUpPassword == newValue {
                                self.passwordValidationString = "비밀번호가 일치합니다."
                                self.isPasswordValidation = true
                            } else {
                                self.passwordValidationString = "비밀번호가 일치하지 않습니다."
                                self.isPasswordValidation = false
                            }
                        }
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
                    Spacer()
                    Button {
                        userRulesView.toggle()
                    } label: {
                        Text("개인정보 처리방침")
                    }
                    Button {
                        appRulesView.toggle()
                    } label: {
                        Text(" 약관")
                    }
                }
                .padding(.top, -5)
                .foregroundColor(.secondary)
                .font(.footnote)
                .fontWeight(.bold)
                
                //MARK: - Register Button
                VStack {
                    Button {
                        //회원가입 버튼
                        viewModel.signUpUser()
                        //
                        self.selection = 2
                    } label: {
                        Text("회원가입")
                            .fontWeight(.bold)
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 340, height: 60)
                            .background(Color("AccentColor"))
                            .cornerRadius(7)
                    }
                    .disableWithOpacity(viewModel.signUpEmailID == "" || viewModel.signUpPassword == "" || viewModel.signUpNickname == "" || viewModel.signUpPassword != signUpPassword)
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
            .fullScreenCover(isPresented: $userRulesView) {
                UserRulesView()
            }
            .fullScreenCover(isPresented: $appRulesView) {
                AppRulesView()
            }
        }
    }
}

//struct SignUpView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignUpView().environmentObject(UserViewModel())
//    }
//}

//MARK: - Extension

extension View{
    func disableWithOpacity(_ condition: Bool) -> some View{
        self
            .disabled(condition)
            .opacity(condition ? 0.6 : 1)
    }
}
