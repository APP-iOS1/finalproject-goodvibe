//
//  NoLoginView.swift
//  GukbapMinister
//
//  Created by ㅇㅇ on 2023/02/14.
//

import SwiftUI

struct NoLoginView: View {
    //    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var userVM: UserViewModel
    
    
    @State private var isSheetPresented: Bool = false
    @State private var isUpdateUserInfoPresented: Bool = false
    @State private var isMyReviewPresented: Bool = false
    @State private var isShowingAlert: Bool = false
    
    @State private var isShowingNotice: Bool = false
    @State private var isShowingTerms: Bool = false
    var body: some View {
        VStack{
            VStack {
                Image(systemName: "lock")
                    .resizable()
                    .frame(width: 100, height: 100)
            }
            .padding(.bottom, 20)
            
            Text("로그인 후 이용해주세요.")
                .padding()
            Button {
                userVM.state = .signedOut
            } label: {
                Text("로그인 하기")
            }
            
            //            NavigationLink {
            //                SignInView()
            //            } label: {
            //                Text("로그인 하기")
            //            }
        }
    }
}

struct NoLoginView_Previews: PreviewProvider {
    static var previews: some View {
        NoLoginView()
    }
}
