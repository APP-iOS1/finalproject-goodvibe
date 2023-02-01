//
//  UpdateUserInfoView.swift
//  GukbapMinister
//
//  Created by 전혜성 on 2023/02/01.
//

import SwiftUI
import FirebaseAuth

struct UpdateUserInfoView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userViewModel: UserViewModel
    
    let currentUser = Auth.auth().currentUser
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section(content: {
                        Text("\(userViewModel.userInfo.userNickname)")
                    }, header: {
                        HStack {
                            Text("닉네임")
                            Spacer()
                            Button {
                                
                            } label: {
                                Text("수정")
                            }
                        }
                    })
                    
                    Section(header: Text("선호하는 국밥")) {
                        ForEach(userViewModel.userInfo.gukbaps, id: \.self) { gukbap in
                            Text("\(gukbap)")
                        }
                    }
                    Section(header: Text("선호하는 지역")) {
                        Text("\(userViewModel.userInfo.preferenceArea)")
                        
                    }
                }
                
                Button {
                    dismiss()
                } label: {
                    Text("뒤로")
                }
                
            }
            .navigationTitle("정보수정")
            .toolbar { EditButton() }
        }
    }
}

//struct UpdateUserInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        UpdateUserInfoView()
//    }
//}
