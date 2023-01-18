//
//  SignUpView.swift
//  GukbapMinister
//
//  Created by Martin on 2023/01/16.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) var returnSigninView
    
    @State var registerEmailID = ""
    @State var registerPassword = ""
    
    var body: some View {
        VStack {
            //MARK: - Email
            TextField("Email", text: $registerEmailID)
                .textContentType(.emailAddress)
                .border(1, .black.opacity(0.5))
                .textInputAutocapitalization(.never)
            //MARK: - Password
            SecureField("Password", text: $registerPassword)
                .textInputAutocapitalization(.never)
                .border(1, .black.opacity(0.5))
            //MARK: - Login Button
            Button {
                //Login 버튼
            } label: {
                Text("로그인")
            }
            .padding(.top, 20)
            //MARK: - Move to SignUpView()
            HStack {
                Text("이미 계정이 있는 경우")
                    .foregroundColor(.secondary)
                Button {
                    returnSigninView()
                } label: {
                    Text("로그인")
                }
                .fontWeight(.bold)
                .foregroundColor(.black)
            }//HStack
            .padding(.top,20)
        }//VStack
        .padding()
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
