//
//  SignInView.swift
//  GukbapMinister
//
//  Created by Martin on 2023/01/16.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var viewModel: UserViewModel
//    @State var isLoading: Bool = false
    @State var signUpView: Bool = false
    
    var body: some View {
        GeometryReader { proxy in
            
            let width = proxy.size.width
            let height = proxy.size.height
            
            VStack {
                Spacer()
                //MARK: - App LOGO
                VStack {
                    //                Text("LOGO")
                    //                Rectangle()
                    //                    .foregroundColor(.secondary)
                    Spacer()
                    Image("AppIcon.noBg")
                        .resizable()
                        .frame(width: width * 0.5 , height: width * 0.5)
                }
                .frame(width: width * 0.5, height: height *  0.5)
//                .padding(.bottom, 20)
                //MARK: - Email
                VStack {
                    HStack {
                        Text("이메일")
                        Spacer()
                    }
                    TextField("Email", text: $viewModel.signInEmailID)
                        .textContentType(.emailAddress)
                        .border(1, .black.opacity(0.5))
                        .textInputAutocapitalization(.never)
                } //Email TextField
                .padding(.bottom, 5)
                //MARK: - Password
                VStack {
                    HStack {
                        Text("비밀번호")
                        Spacer()
                    }
                    SecureField("Password", text: $viewModel.signInPassword)
                        .textInputAutocapitalization(.never)
                        .border(1, .black.opacity(0.5))
                }
                .padding(.bottom, 30)
                //MARK: - Login Button
                VStack{
                    Button {
                        //Login 버튼
                        viewModel.isLoading = true
                        viewModel.signInUser()
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5){
                            viewModel.isLoading = false
                        }
                    } label: {
                        VStack {
                            Text("이메일로 계속하기")
                                .fontWeight(.semibold)
                                .font(.title3)
                                .foregroundColor(.white)
                                .frame(height: 40)
                                .frame(maxWidth: .infinity)
                                .background(Color("AccentColor"))
                                .cornerRadius(7)
                        }//VStack
                    }
                    Button {
                        //Login 버튼
                        viewModel.state = .noSigned
                    } label: {
                        VStack {
                            Text("로그인 없이 이용하기")
                                .fontWeight(.semibold)
                                .font(.title3)
                                .foregroundColor(.white)
                                .frame(height: 40)
                                .frame(maxWidth: .infinity)
                                .background(Color("AccentColor"))
                                .cornerRadius(7)
                        }//VStack
                    }
                }//VStack
                .padding(.bottom, 30)
                //MARK: - KAKAO Login Button
                HStack {
                    Button {
                        viewModel.kakaoSignIn()
                    } label: {
                        Text("K")
                            .frame(width: width * 0.15, height: width * 0.15)
                            .fontWeight(.bold)
                            .font(.title2)
                            .foregroundColor(.black)
                            .background(.yellow)
                            .clipShape(Circle())
                    }// KAKAO LOGIN
//                    Button {
//                        //NAVER LOGIN 추가 해야함
//                        viewModel.kakaoSignIn()
//                    } label: {
//                        Text("N")
//                            .frame(width: 50, height: 50)
//                            .fontWeight(.bold)
//                            .font(.title2)
//                            .foregroundColor(.white)
//                            .background(.green)
//                            .clipShape(Circle())
//                    }// NAVER LOGIN
                }
                
                //MARK: - Move to SignUpView()
                Spacer()
                HStack {
                    Text("아직 회원이 아니신가요?")
                        .foregroundColor(.secondary)
                    Button {
                        signUpView.toggle()
                    } label: {
                        Text("회원가입")
                    }
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                }//HStack
                .padding(.bottom, 15)
                
            }//VStack
            .padding()
            .overlay(content: {
                LoadingView(show: $viewModel.isLoading)
            })
            .fullScreenCover(isPresented: $signUpView) {
                SignUpTabView()
            }
            .frame(width: proxy.size.width, height: proxy.size.height * 0.9)
            .ignoresSafeArea()
            .onAppear {
                print("\(proxy.size)")
            }
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    //    static let userViewModel: UserViewModel()
    static var previews: some View {
        SignInView().environmentObject(UserViewModel())
    }
}

extension View{
    func border(_ width: CGFloat, _ color: Color) -> some View{
        self
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background{
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .stroke(color, lineWidth: width)
            }
    }
}//extension
