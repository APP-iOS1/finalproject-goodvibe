//
//  MyPageView.swift
//  GukbapMinister
//
//  Created by Martin on 2023/01/16.
//

import SwiftUI

struct MyPageView: View {
    @EnvironmentObject var userVM: UserViewModel
    
    
    @State private var isSheetPresented: Bool = false
    @State private var isUpdateUserInfoPresented: Bool = false
    @State private var isMyReviewPresented: Bool = false

    
    var body: some View {
        NavigationStack {
            HStack{
                VStack(alignment: .leading){
                    Text(userVM.userInfo.userNickname)
                        .font(.title)
                        .bold()
                        .padding()

                    
                    HStack{
                        Text("회원등급 :")
                        
                        Text(userVM.userInfo.status)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    .font(.body)
                }

                Spacer()
            }
            
            List {

                
                Button {
                    self.isMyReviewPresented.toggle()
                } label: {
                    Text("내가 쓴 리뷰보기")
                }
                .fullScreenCover(isPresented: $isMyReviewPresented) {
                    MyReviewView()
                        .environmentObject(ReviewViewModel())
                        .environmentObject(UserViewModel())
                }
                
                Button {
                    self.isUpdateUserInfoPresented.toggle()
                } label: {
                    Text("회원정보수정")
                }
                .fullScreenCover(isPresented: $isUpdateUserInfoPresented) {
                    UpdateUserInfoView()
                        .environmentObject(UserViewModel())
                    
                }
                
                Button {
                    userVM.isLoading = true
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2){
                        userVM.signOut()
                    }
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5){
                        userVM.isLoading = false
                    }
                } label: {
                    Text("로그아웃")
                }
                Button {
                    isSheetPresented.toggle()
                } label: {
                    Text("장소 제보하기(임시)")
                }
            }
            .listStyle(.grouped)
        }
        .overlay(content: {
            LoadingView(show: $userVM.isLoading)
        })
        .sheet(isPresented: $isSheetPresented) {
            NavigationStack {
                StoreRegistrationView(isOn: $isSheetPresented)
            }
            .tint(.mainColor)
        }
        .tint(.mainColor)
    }
}

// >>>>>>>>>>필독<<<<<<<<<< 프리뷰 써야하면 37번째 줄 .overlay부분 주석 시키기!!!!!! 문의->서현
//struct MyPageView_Previews: PreviewProvider {
//    static var previews: some View {
//        MyPageView()
//    }
//}
