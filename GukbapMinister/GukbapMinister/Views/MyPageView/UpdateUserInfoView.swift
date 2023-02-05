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
                        NavigationLink {
                            EditNicknameView()
                                .environmentObject(userViewModel)
                        } label: {
                            Text("\(userViewModel.userInfo.userNickname)")
                        }
                    }, header: {
                            Text("닉네임")
                                .font(.title3)
                    })
                    
                    Section(header: Text("선호하는 국밥").font(.title3)) {
                        NavigationLink {
                            EditGukbapView()
                        } label: {
                            
                                VStack {
                                    ForEach(userViewModel.userInfo.gukbaps, id: \.self) { gukbap in
                                        Text("\(gukbap)")
                                            .font(.subheadline)
                                            .lineLimit(1)
                                            .padding(7.5)
                                            .padding(.horizontal, 5)
                                            .cornerRadius(30)
                                            .overlay{
                                                RoundedRectangle(cornerRadius: 30)
                                                    .stroke(.yellow, lineWidth: 1)
                                            }
                                    }
                                }
                        }
                    }
                    
                    Section(header: Text("선호하는 지역").font(.title3)) {
                        NavigationLink {
                            EditPreferenceAreaView()
                        } label: {
                            Text("\(userViewModel.userInfo.preferenceArea)")
                        }
                    }
                }
                
                Button {
                    dismiss()
                } label: {
                    Text("뒤로")
                }
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("개인정보")
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
