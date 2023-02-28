//
//  UpdateUserInfoView.swift
//  GukbapMinister
//
//  Created by 전혜성 on 2023/02/01.
//

import SwiftUI
import FirebaseAuth

struct UpdateUserInfoView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
        
    let currentUser = Auth.auth().currentUser
    
    var body: some View {
        
        NavigationStack {
            VStack {
                List {
                    Section(content: {
                        NavigationLink {
                            EditNicknameView()
//                                .environmentObject(userViewModel)
                        } label: {
                            Text("\(userViewModel.userInfo.userNickname)")
                        }
                    })
                    
//
                    Section(content: {
                        NavigationLink {
                            EditGukbapView()
                        } label: {
                            Text("선호하는 국밥")
                        }
                    })
                    
                    Section(content: {
                        NavigationLink {
                            EditPreferenceAreaView()
                        } label: {
                            Text("선호하는 지역")
                        }
                    })
                    
                    Section(content: {
                        NavigationLink {
                            DeleteAccountView()
                        } label: {
                            Text("더보기")
                        }
                    })
                }
                
           
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("개인정보수정")
        }
        .onAppear {
            userViewModel.fetchUpdateUserInfo()
        }
    }
}

//struct UpdateUserInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        UpdateUserInfoView()
//    }
//}
