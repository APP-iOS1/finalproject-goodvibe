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
    var body: some View {
        NavigationStack {
            List {
                Button {
                    viewModel.isLoading = true
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2){
                        viewModel.signOut()
                    }
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 7){
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
            .overlay(content: {
                LoadingView(show: $viewModel.isLoading)
            })
            .sheet(isPresented: $isSheetPresented) {
                NavigationStack {
                    TempManagementView(isOn: $isSheetPresented)
                }
            }
        }
    }
}

struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView()
    }
}
