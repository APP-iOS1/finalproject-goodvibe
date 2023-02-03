//
//  EditNicknameView.swift
//  GukbapMinister
//
//  Created by 전혜성 on 2023/02/03.
//

import SwiftUI
import FirebaseAuth


enum Field: Hashable {
    case searchBar
  }

struct EditNicknameView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    @State private var nickName: String = ""
    
    @FocusState private var focusField: Field?
    
    let currentUser = Auth.auth().currentUser
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("\(userViewModel.userInfo.userNickname)", text: $nickName)
                    .focused($focusField, equals: .searchBar)
                    
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("닉네임")
            .toolbar {
                Button {
                    
                } label: {
                    Text("완료")
                }

            }
        }
        .onAppear {
            focusField = .searchBar
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
