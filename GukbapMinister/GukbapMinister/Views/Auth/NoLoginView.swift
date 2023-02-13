//
//  NoLoginView.swift
//  GukbapMinister
//
//  Created by ㅇㅇ on 2023/02/14.
//

import SwiftUI

struct NoLoginView: View {
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
            NavigationLink {
                SignInView()
            } label: {
                Text("로그인 하기")
            }

        }
    }
}

struct NoLoginView_Previews: PreviewProvider {
    static var previews: some View {
        NoLoginView()
    }
}
