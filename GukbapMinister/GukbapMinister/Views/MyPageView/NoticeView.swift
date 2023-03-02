//
//  NoticeView.swift
//  GukbapMinister
//
//  Created by 김요한 on 2023/02/13.
//

import SwiftUI

struct NoticeView: View {

    //관리자앱과 연동 필요
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section {
                        Text("국밥부 장관을 다운받아 주셔서 감사합니다.")
                    }
                    
                }
              
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("공지")
        }
    }
}

struct NoticeView_Previews: PreviewProvider {
    static var previews: some View {
        NoticeView()
    }
}
