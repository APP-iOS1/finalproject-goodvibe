//
//  LoginViewModel.swift
//  GukbapMinister
//
//  Created by 전혜성 on 2023/02/23.
//

import Foundation
import Firebase
import FirebaseAuth
import GoogleSignIn
import FirebaseFirestore
import UIKit
import SwiftUI
import KakaoSDKAuth
import KakaoSDKUser

// MARK: - 주의사항
// 카카오로그인 진행시 로그인이 안될 때 카카오디벨로퍼 -> 플랫폼 -> 번들아이디 수정

// TODO: - 해야할 일
// 애플로그인

// MARK: - 로그인상태 열거형
enum LoginState {
    case googleLogin
    case kakaoLogin
    case appleLogin
    case logout
}

// MARK: -
class UserViewModel: ObservableObject {
    
    // MARK: - 프로퍼티
    let database = Firestore.firestore() // FireStore 참조 객체
    var currentUser = Auth.auth().currentUser
    
    // MARK: - @Published 변수
    @Published var loginState: LoginState = .logout // 로그인 상태 변수
    @Published var userInfo: User = User() // User 객체
    
    
    // MARK: - 자동로그인을 위한 UserDefaults 변수
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = UserDefaults.standard.bool(forKey: "isLoggedIn")
    @AppStorage("loginPlatform") var loginPlatform: String = (UserDefaults.standard.string(forKey: "loginPlatform") ?? "")
    
    init() {
        print("\(self.isLoggedIn)")
        print("\(self.loginPlatform)")
        if self.isLoggedIn && currentUser != nil {
            self.fetchUserInfo(uid: self.currentUser?.uid ?? "")
        }
    }
    
    // MARK: 사용자 정보 가져오기
    func fetchUserInfo(uid: String) {
        let docRef = database.collection("User").document(uid)
        docRef.getDocument { document, error in
            if let document = document, document.exists {
                let dataDescription = document.data()
                
                
                let email: String = dataDescription?["userEmail"] as? String ?? ""
                let nickName: String = dataDescription?["userNickname"] as? String ?? ""
                let userGrade : String = dataDescription?["userGrade"] as? String ?? ""
                let favoriteStoreId: [String] = dataDescription?["favoriteStoreId"] as? [String] ?? []
                let reviewCount: Int = dataDescription?["reviewCount"] as? Int ?? 0
                let storeReportCount: Int = dataDescription?["storeReportCount"] as? Int ?? 0
                
                self.userInfo.id = uid
                self.userInfo.userEmail = email
                self.userInfo.userNickname = nickName
                self.userInfo.favoriteStoreId = favoriteStoreId
                self.userInfo.userGrade = userGrade
                self.userInfo.reviewCount = reviewCount
                self.userInfo.storeReportCount = storeReportCount
                
                print("\(self.userInfo)")
                
            } else {
                print("Document does not exist")
            }
        }
    }
    
    // MARK: - FireStore에 유저 정보 추가하는 함수
    // googleLogin() 함수 내부에서 실행 됨.
    func insertUserInFireStore(uid: String, userEmail: String, userName: String) {
        Task{
            do{
                try await database.collection("User").document(uid).setData([
                    "userEmail" : userEmail,
                    "userNickname" : userName,
                    "reviewCount" : 0,
                    "storeReportCount" : 0,
                    "favoriteStoreId" : [],
                    "userGrade" : "깍두기"
                ])
            }catch let error {
                print("\(#function) 파이어베이스 에러 : \(error)")
            }
        }//Task
    }
    
    // MARK: - 구글
    // 구글 로그인
    func googleLogin() {
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
        
        // 구글 로그인 로직 실행
        GIDSignIn.sharedInstance.signIn(
            withPresenting: rootViewController) { signInResult, error in
                guard let result = signInResult else { return }
                
                let user = result.user // 로그인 한 유저
                let idToken = user.idToken?.tokenString // 유저 idToken
                let accessToken = user.accessToken.tokenString // 유저 accessToken
                
                // credential 생성
                let credential = GoogleAuthProvider.credential(withIDToken: idToken ?? "", accessToken: accessToken)
                
                // 위 cresential을 이용해서 FirebaseAuth 로그인
                Auth.auth().signIn(with: credential) { result, error in
                    // 사용자 uid
                    guard let uid = Auth.auth().currentUser?.uid else { return }
                    // 로그인 성공시 유저정보 FireStore에 저장
                    self.insertUserInFireStore(uid: uid, userEmail: user.profile?.email ?? "", userName: user.profile?.name ?? "")
                    self.fetchUserInfo(uid: uid)
                    print("로그인 후 : currentUser - \(self.currentUser)")
                }
                // 구글로그인 상태로 전환
                self.loginState = .googleLogin
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                UserDefaults.standard.set("googleLogin", forKey: "loginPlatform")
                print("asdfasdf \(self.isLoggedIn)")
            }
        
    }
    
    // MARK: - 카카오
    // 카카오 로그인
    func kakaoLogin() {
        // 카카오톡 간편로그인이 실행 가능한지 확인
        if UserApi.isKakaoTalkLoginAvailable() {
            // 간편로그인 실행 가능할 경우
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                if let error = error {
                    print(error)
                } else {
                    // 로그인 성공시
                    // 카카오 로그인으로 전환
                    self.loginState = .kakaoLogin
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    UserDefaults.standard.set("kakaoLogin", forKey: "loginPlatform")
                    // firebase에 저장
                    self.loginFirebase()
                }
            }
        } else { // 간편로그인이 실행 불가능할 경우
            // 로그인 웹페이지를 띄우고 쿠키기반 로그인 진행
            UserApi.shared.loginWithKakaoAccount { [self](oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    if let token = oauthToken {
                        print("kakao token: \(token)")
                    }
                    // 로그인 성공시
                    // 카카오 로그인으로 전환
                    self.loginState = .kakaoLogin
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    UserDefaults.standard.set("kakaoLogin", forKey: "loginPlatform")
                    // firebase에 저장
                    self.loginFirebase()
                }
            }
        }
    }
    
    // Firebas Auth, Store 저장
    // kakaoLogin() 함수 내에서 사용
    private func loginFirebase() {
        // 사용자 정보 가져오기
        UserApi.shared.me { kuser, error in
            if let error = error {
                print(error)
            } else {
                // 사용자 정보로 FirebaseAuth 계정 생성 진행
                Auth.auth().createUser(withEmail: (kuser?.kakaoAccount?.email ?? ""), password: "\(String(describing: kuser?.id))") { fuser, error in
                    if let error = error {
                        print("\(error) : \(#function)")
                        // 계정 생성이 실패한경우 계정이 있다고 가정하고 로그인 진행
                        Auth.auth().signIn(withEmail: (kuser?.kakaoAccount?.email ?? ""), password: "\(String(describing: kuser?.id))", completion: nil)

                        guard let uid = Auth.auth().currentUser?.uid else { return }// 사용자 uid
                        print("if uid : \(uid)")
                        guard let kuser = kuser else { return } // 사용자 옵셔널 바인딩,
                        let email = kuser.kakaoAccount?.email // 사용자 이메일
                        let name = kuser.kakaoAccount?.profile?.nickname // 사용자 닉네임
                        self.insertUserInFireStore(uid: uid ?? "", userEmail: email!, userName: name!)
                        self.fetchUserInfo(uid: uid)
                    } else {
                        guard let uid = Auth.auth().currentUser?.uid else { return }// 사용자 uid
                        print("else uid : \(uid)")
                        guard let kuser = kuser else { return } // 사용자 옵셔널 바인딩
                        let email = kuser.kakaoAccount?.email // 사용자 이메일
                        let name = kuser.kakaoAccount?.profile?.nickname // 사용자 닉네임
                        // 로그인 성공시 FireStore User 컬렉션에 저장
                        self.insertUserInFireStore(uid: uid ?? "", userEmail: email!, userName: name!)
                        self.fetchUserInfo(uid: uid)
                    }
                }
            }
        }
    }
    
    // MARK: - 로그아웃(공통)
    // 로그인 상태 열거형 변수를 참조하여 해당하는 플랫폼 로그아웃 로직 실행
    func logoutByPlatform() {
        
        print("현재 로그인 플랫폼 - \(String(describing: self.loginState))")
        
        switch loginPlatform {
        case "googleLogin": // 구글로그인일때
            do {
                UserDefaults.standard.set(false, forKey: "isLoggedIn")
                UserDefaults.standard.set("noLoginPlatform", forKey: "loginPlatform")
                try Auth.auth().signOut()
                self.loginState = .logout // 로그아웃 상태로 전환
                print("\(#function) - 구글 로그아웃 성공")
                print("\(self.isLoggedIn)")
                print("로그아웃 후 : currentUser - \(self.currentUser)")
            } catch let signOutError as NSError {
              print("Error signing out: %@", signOutError)
            }
//            GIDSignIn.sharedInstance.signOut() // 구글 로그아웃
//            do {
//                UserDefaults.standard.set(false, forKey: "isLoggedIn")
//                UserDefaults.standard.set("noLoginPlatform", forKey: "loginPlatform")
//                try Auth.auth().signOut() // FirebaseAuth 로그아웃
//                self.loginState = .logout // 로그아웃 상태로 전환
//                print("\(#function) - 구글 로그아웃 성공")
//                print("\(self.isLoggedIn)")
//            } catch {
//                print("\(error.localizedDescription)")
//            }
            
        case "kakaoLogin": // 카카오로그인일때
//            UserApi.shared.unlink { error in
//                if let error = error {
//                    print(error.localizedDescription)
//                }
//            }
            UserApi.shared.logout {(error) in
                if let error = error {
                    print(error)
                }
                else {
                    do {
                        try Auth.auth().signOut()
                        UserDefaults.standard.set(false, forKey: "isLoggedIn")
                        UserDefaults.standard.set("noLoginPlatform", forKey: "loginPlatform")
                        self.loginState = .logout // 로그아웃 상태로 전환
                        print("\(#function) - 카카오 로그아웃 성공")
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            // case "appleLogin": // 애플로그인일때
        default: return
        }
    }
}

