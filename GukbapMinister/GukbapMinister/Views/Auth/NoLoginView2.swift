//
//  NoLoginView2.swift
//  GukbapMinister
//
//  Created by ㅇㅇ on 2023/02/14.
//

import SwiftUI

struct NoLoginView2: View {
    @EnvironmentObject var userVM: UserViewModel
    
    
    @State private var isSheetPresented: Bool = false
    @State private var isUpdateUserInfoPresented: Bool = false
    @State private var isMyReviewPresented: Bool = false
    @State private var isShowingAlert: Bool = false
    
    @State private var isShowingNotice: Bool = false
    @State private var isShowingTerms: Bool = false
    var body: some View {
        VStack{
            Spacer()
            NoLoginView()
            VStack(alignment: .leading){
                VStack (alignment: .leading, spacing: 25) {
                    //공지사항도 있어야할것같아서 버튼만 우선 만들었습니다.
                    Button {
                        self.isShowingNotice.toggle()
                    } label: {
                        HStack{
                            Image(systemName: "exclamationmark.bubble")
                            Text("공지")
                            Spacer()
                        }
                    }
                    .fullScreenCover(isPresented: $isShowingNotice) {
                        NoticeView()
                    }
                    
                    //이용약관 페이지로 넘어가는 버튼
                    Button {
                        self.isShowingTerms.toggle()
                    } label: {
                        HStack{
                            Image(systemName: "captions.bubble")
                            Text("앱 정보")
                            Spacer()
                        }
                    }
                    .fullScreenCover(isPresented: $isShowingTerms) {
                        PolicyView()
                    }
                }
                .foregroundColor(.black)
                .padding()
                .padding(.top, 5)
                .font(.title3)
            }
            .padding(.bottom, 125)
        }

    }
}

struct NoLoginView2_Previews: PreviewProvider {
    static var previews: some View {
        NoLoginView2()
    }
}
