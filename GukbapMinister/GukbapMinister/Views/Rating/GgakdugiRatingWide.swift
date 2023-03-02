//
//  GgakdugiRatingWide.swift
//  GukbapMinister
//
//  Created by Martin on 2023/01/23.
//

import SwiftUI

struct GgakdugiRatingWide: View {
    let selected: Int
    let size: CGFloat
    let spacing: CGFloat
    let perform: ((Int) -> Void)?
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var showModal: Bool = false
    @State private var showingAlert = false
    @State private var showingLoginView = false
    init(selected: Int, size: CGFloat, spacing: CGFloat, perform: @escaping (Int) -> Void) {
        self.selected = selected
        self.size = size
        self.spacing = spacing
        self.perform = perform
    }
    
    var body: some View {
        if userViewModel.isLoggedIn == false {
            HStack(spacing: spacing) {
                ForEach(0..<5) { index in
                    Image(selected >= index ? "Ggakdugi" : "Ggakdugi.gray")
                        .resizable()
                        .scaledToFit()
                        .frame(width: size, height: size)
                        .onTapGesture {
                            showingAlert.toggle()
                        }
                        .alert("로그인이 필요한 서비스입니다.", isPresented: $showingAlert) {
                            Button("아니요", role: .destructive) {
                                
                            }
                            .foregroundColor(.blue)
                            Button("예", role: .cancel) {
                                self.showingLoginView.toggle()
                            }
                            .foregroundColor(.red)
                        } message: {
                            Text("로그인 하시겠습니까?")
                        }
                        .sheet(isPresented: $showingLoginView) {
                            LoginView()
                        }
                }
            }
        }else{
            HStack(spacing: spacing) {
                ForEach(0..<5) { index in
                    Image(selected >= index ? "Ggakdugi" : "Ggakdugi.gray")
                        .resizable()
                        .scaledToFit()
                        .frame(width: size, height: size)
                        .onTapGesture { _ in
                            perform?(index)
                        }
                }
            }
        }

    }
}

