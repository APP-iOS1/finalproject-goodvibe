//
//  SignInView.swift
//  GukbapMinister
//
//  Created by Martin on 2023/01/16.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var viewModel: KakaoAuthViewModel
    @State var emailID: String = ""
    @State var password: String = ""
    
    @State var signUpView: Bool = false
    
    var body: some View {
        VStack {
            //MARK: - Email
            TextField("Email", text: $emailID)
                .textContentType(.emailAddress)
                .border(1, .black.opacity(0.5))
                .textInputAutocapitalization(.never)
            //MARK: - Password
            SecureField("Password", text: $password)
                .textInputAutocapitalization(.never)
                .border(1, .black.opacity(0.5))
            //MARK: - Login Button
            HStack{
                Button {
                    //Login 버튼
                } label: {
                    Text("로그인")
                }
                Button {
                    viewModel.kakaoSignIn()
                } label: {
                    Text("카카오로그인")
                }
                Button {
                    viewModel.signOut()
                } label: {
                    Text("로그아웃")
                }

            }

            //MARK: - Move to SignUpView()
            HStack {
                Text("아직 계정이 업는 경우")
                    .foregroundColor(.secondary)
                Button {
                    signUpView.toggle()
                } label: {
                    Text("회원가입")
                }
                .fontWeight(.bold)
                .foregroundColor(.black)
            }//HStack
            .padding(.top,20)
        }//VStack
        .padding()
        .fullScreenCover(isPresented: $signUpView) {
            SignUpView()
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}

extension View{
    func border(_ width: CGFloat, _ color: Color) -> some View{
        self
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background{
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .stroke(color, lineWidth: width)
            }
    }
}//extension
