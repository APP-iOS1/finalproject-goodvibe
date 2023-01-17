////
////  KakaoAuthViewModel.swift
////  GukbapMinister
////
////  Created by ㅇㅇ on 2023/01/17.
////
//
//import Foundation
//import Combine
//import KakaoSDKAuth
//import KakaoSDKUser
//import FirebaseCore
//import FirebaseAuth
//import FirebaseFirestore
//
//class KakaoAuthViewModel: ObservableObject {
//    
//    //로그인 상태
//    enum SignInState{
//        case signedIn
//        case signedOut
//    }
//    //state 옵저빙
//    @Published var state: SignInState = .signedOut
//    @Published var userInfo: User = User()
//    
//    
//    //MARK: - 로그인
//    func kakaoSignIn(){
//        // 카카오톡 실행 가능 여부 확인
//        if (UserApi.isKakaoTalkLoginAvailable()) {
//            UserApi.shared.loginWithKakaoTalk { [self](oauthToken, error) in
//                if let error = error {
//                    print(error)
//                }
//                else {
//                    print("loginWithKakaoTalk() success.")
//                    
//                    //do something
//                    if let token = oauthToken {
//                        print("kakao token: \(token)")
//                        fetchingFirebase()
//                    }
//                    self.state = .signedIn
//                }
//            }
//        } else {
//            UserApi.shared.loginWithKakaoAccount { [self](oauthToken, error) in
//                if let error = error {
//                    print(error)
//                }
//                else {
//                    print("loginWithKakaoAccount() success.")
//                    if let token = oauthToken {
//                        print("kakao token: \(token)")
//                        fetchingFirebase()
//                    }
//                    //do something
//                    //                    _ = oauthToken
//                    
//                    self.state = .signedIn
//                }
//            }
//        }
//    }
//    //MARK: - 로그아웃
//    func signOut() {
//        
////        // MARK: - 구글 로그아웃
////        GIDSignIn.sharedInstance.signOut()
////        do {
////            try Auth.auth().signOut()
////            state = .signedOut
////        } catch {
////            print(error.localizedDescription)
////        }
////
//        // MARK: - 카카오 로그아웃
//        UserApi.shared.logout {(error) in
//            if let error = error {
//                print(error)
//            }
//            else {
//                print("logout() success.")
//                self.state = .signedOut
//                
//            }
//        }
//    }
//    //MARK: - 파이어베이스 연동
//    func fetchingFirebase(){
//        UserApi.shared.me() {(user, error) in
//            if let error = error {
//                print(error)
//            }
//            else {
//                print("me() success.")
//                
//                Auth.auth().createUser(withEmail: (user?.kakaoAccount?.email)!, password: "\(String(describing: user?.id))") { authResult, error in
//                    if let error = error {
//                        print("Firebase 사용자 생성 실패: \(error.localizedDescription)")
//                        Auth.auth().signIn(withEmail: (user?.kakaoAccount?.email)!, password: "\(String(describing: user?.id))")
//                    } else {
//                        print("Firebase 사용자 생성 성공")
//                        let authResult = authResult?.user
//                        let currentKakao = user?.kakaoAccount
//                        Firestore.firestore().collection("User").document(authResult?.uid ?? "").setData([
//                            "userEmail" : currentKakao?.email ?? "",
//                            "userNickname" : currentKakao?.profile?.nickname ?? "",
//                        ])
//                    }
//                }
//                
//                self.userInfo.userEmail = (user?.kakaoAccount?.email)!
//                self.userInfo.userNickname = (user?.kakaoAccount?.profile?.nickname)!
////                self.userInfo.profileImage = (user?.kakaoAccount?.profile?.profileImageUrl)!
//                
//                print("===================")
//                print(self.userInfo.userEmail)
//                print(self.userInfo.userNickname)
////                print(self.userInfo.profileImage)
//                print("===================")
//            }
//        }
//    }
//}
