//
//  MyPageView.swift
//  GukbapMinister
//
//  Created by Martin on 2023/01/16.
//

import SwiftUI

struct MyPageView: View {
    @EnvironmentObject var viewModel: UserViewModel
    var body: some View {
        Button {
            viewModel.signOut()
        } label: {
            Text("로그아웃")
        }

    }
}

struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView()
    }
}
