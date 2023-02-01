//
//  MyPageView.swift
//  GukbapMinister
//
//  Created by Martin on 2023/01/16.
//

import SwiftUI

struct MyPageView: View {
    @EnvironmentObject var viewModel: UserViewModel
    
    
    
    @State private var isSheetPresented: Bool = false
    @State private var isUpdateUserInfoPresented: Bool = false
    var body: some View {
        NavigationStack {
            List {
                
                NavigationLink{
                    MyReviewView()
                        .environmentObject(ReviewViewModel())
                        .environmentObject(UserViewModel())
                } label: {
                    Text("내가 쓴 리뷰보기")
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
                    viewModel.isLoading = true
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2){
                        viewModel.signOut()
                    }
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5){
                        viewModel.isLoading = false
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
        }
        .overlay(content: {
            LoadingView(show: $viewModel.isLoading)
        })
        .sheet(isPresented: $isSheetPresented) {
            NavigationStack {
                TempManagementView(isOn: $isSheetPresented)
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
