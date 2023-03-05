//
//  StoreReportButton.swift
//  GukbapMinister
//
//  Created by Martin on 2023/02/06.
//

import SwiftUI

import PopupView
import Shimmer

struct StoreReportButton: View {
    @Environment(\.colorScheme) var scheme
    @State var showModal: Bool = false
    @State var showModal2: Bool = false
    @State var isShowingLoginView: Bool = false // 로그인뷰 트리거
    @State var isShowingAlert: Bool = false // alert 트리거
    @EnvironmentObject var userViewModel : UserViewModel
    
    var body: some View {
        if userViewModel.isLoggedIn == false {
            Button {
                self.isShowingAlert.toggle()
            } label: {
                VStack(spacing: 0) {
                    Text("국밥집 제보")
                        .font(.caption.bold())
                        .foregroundColor(.mainColorLight)
                        .frame(width: 70, height: 20)
                        .background {
                            Capsule().fill(Color.mainColorDark)
                                .shimmering(duration: 2, delay: 5)
                        }
                        .padding(.bottom, 4)
                    
                    Circle()
                        .frame(width: 45, height: 45)
                        .overlay {
                            GifImage("Ddukbaegi.boiling")
                                .frame(width: 45)
                                .clipShape(Circle())
                        }
                }
                .alert("로그인이 필요한 서비스입니다.", isPresented: $isShowingAlert) {
                    Button("아니요", role: .destructive) {
                        
                    }
                    .foregroundColor(.blue)
                    Button("예", role: .cancel) {
                        self.isShowingLoginView.toggle()
                    }
                    .foregroundColor(.red)
                } message: {
                    Text("로그인 하시겠습니까?")
                }
                .sheet(isPresented: $isShowingLoginView) {
                    LoginView()
                }
            }
        } else {
            Button {
                showModal.toggle()
            } label: {
                VStack(spacing: 0) {
                    Text("국밥집 제보")
                        .font(.caption.bold())
                        .foregroundColor(.mainColorLight)
                        .frame(width: 70, height: 20)
                        .background {
                            Capsule().fill(Color.mainColorDark)
                                .shimmering(duration: 2, delay: 5)
                        }
                        .padding(.bottom, 4)
                    
                    Circle()
                        .frame(width: 45, height: 45)
                        .overlay {
                            GifImage("Ddukbaegi.boiling")
                                .frame(width: 45)
                                .clipShape(Circle())
                        }
                }
            }
            .sheet(isPresented: $showModal) {
                NavigationStack{
                    StoreReportView()
                }
            }
        }
    }
}

struct StoreReportButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
            StoreReportButton()
        }
    }
}
