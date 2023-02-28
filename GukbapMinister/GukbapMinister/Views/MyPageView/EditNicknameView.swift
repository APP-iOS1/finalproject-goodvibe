//
//  EditNicknameView.swift
//  GukbapMinister
//
//  Created by 전혜성 on 2023/02/03.
//

import SwiftUI
import FirebaseAuth


enum NickNameTextField: Hashable {
    case nickNameTextFieldFocus
  }

struct EditNicknameView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    @State private var nickName: String = ""
    
    @FocusState private var focusField: NickNameTextField?
    
    let currentUser = Auth.auth().currentUser
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("\(userViewModel.userInfo.userNickname)", text: $nickName)
                    .focused($focusField, equals: .nickNameTextFieldFocus)
                    
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("닉네임")
            .toolbar {
                Button {
//                    userViewModel.updateUserNickname(nickName: nickName)
                    dismiss()
                } label: {
                    Text("완료")
                }

            }
        }
        .onAppear {
            focusField = .nickNameTextFieldFocus
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
}

//struct EditNicknameView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditNicknameView()
//    }
//}
