//
//  SignInView.swift
//  GukbapMinister
//
//  Created by Martin on 2023/01/16.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var viewModel: UserViewModel
    
    @State var signUpView: Bool = false
    
    var body: some View {
        VStack {
            //MARK: - Email
            TextField("Email", text: $viewModel.signInEmailID)
                .textContentType(.emailAddress)
                .border(1, .black.opacity(0.5))
                .textInputAutocapitalization(.never)
            //MARK: - Password
            SecureField("Password", text: $viewModel.signInPassword)
                .textInputAutocapitalization(.never)
                .border(1, .black.opacity(0.5))
            //MARK: - Login Button
            VStack{
                Button {
                    //Login 버튼
                    viewModel.signInUser()
                } label: {
                    Text("이메일 로그인")
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
                Text("아직 계정이 없는 경우")
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
//    static let userViewModel: UserViewModel()
    static var previews: some View {
        SignInView().environmentObject(UserViewModel())
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
