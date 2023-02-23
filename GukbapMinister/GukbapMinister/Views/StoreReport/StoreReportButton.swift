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
    @EnvironmentObject var userViewModel : UserViewModel
    
    var body: some View {
        if userViewModel.state == .noSigned{
            Button {
                showModal2.toggle()
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
            }.fullScreenCover(isPresented: $showModal2, content: {
                SignInView2()
            })
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
