//
//  UserViewModel.swift
//  GukbapMinister
//
//  Created by Martin on 2023/01/16.
//

import Foundation
import Combine
import KakaoSDKAuth
import KakaoSDKUser
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

@MainActor
final class UserViewModel: ObservableObject {
    //MARK: - SignIn
    @Published var signInEmailID: String = ""
    @Published var signInPassword: String = ""
    //MARK: - SignUp
    @Published var signUpEmailID: String = ""
    @Published var signUpPassword: String = ""
    @Published var signUpNickname: String = ""
    @Published var preferenceArea: String = ""
    @Published var gender: String = ""
    @Published var ageRange: Int = 0
    @Published var gukbaps: [String] = []
    @Published var selection: Int = 0
    //로그인 상태
    enum SignInState{
        case signedIn
        case signedOut
        case kakaoSign
    }
    //state 옵저빙
    @Published var state: SignInState = .signedOut
    @Published var userInfo: User = User()
    
    let database = Firestore.firestore()
    
    // MARK: - gukbaps 중복제거
    func gukbapsDeduplication(_ gukbapName: String) {
        if !self.gukbaps.contains(gukbapName) {
            self.gukbaps.append(gukbapName)
            print("\(#function) : 배열요소추가성공")
        } else {
            self.gukbaps = self.gukbaps.filter{$0 != gukbapName}
            print("\(#function) : 배열요소중복")
        }
    }
    
    //MARK: - Email Login(signIn)
    func signInUser(){
        Task{
            do{
                let authDataResult = try await Auth.auth().signIn(withEmail: signInEmailID, password: signInPassword)
                let currentUser = authDataResult.user
                print("Signed In As User \(currentUser.uid), with Email: \(String(describing: currentUser.email))")
                self.state = .signedIn
            }catch{
                print("Sign In Failed")
            }
        }
    }//signInUser
    
    //MARK: - Email LogOut(signOut)
    func signOutUser() {
        self.state = .signedIn
        print("SignInView로 이동 됨")
        try? Auth.auth().signOut()
        print("Firebase Auth에서 signOut 됨")
    }
    
    //MARK: - Email Register(signUp)
    func signUpUser(){
        Task{
            do{
                let authDataResult = try await Auth.auth().createUser(withEmail: signUpEmailID, password: signUpPassword)
                let currentUser = authDataResult.user
                try await database.collection("User").document(currentUser.uid).setData([
                    "userEmail" : signUpEmailID,
                    "userNickname" : signUpNickname,
//                    "preferenceArea" : preferenceArea,
                ])
//                self.state = .signedIn
            }catch let error {
                print("Sign Up Failed : \(error)")
            }
        }//Task
    }//registerUser()
    
    //MARK: - 성별, 연령대, 선호지역 업데이트
    func signUpInfo(){
        Task{
            do{
                let uid = Auth.auth().currentUser?.uid
                try await database.collection("User").document(uid ?? "").updateData([
                    "gender" : gender,
                    "ageRange" : ageRange,
                    "preferenceArea" : preferenceArea,
                ])
//                self.state = .signedIn
            }catch let error {
                print("Sign Up Failed : \(error)")
            }
        }//Task
    }
    //MARK: - 선호 국밥 업데이트
    func signUpGukBap(){
        Task{
            do{
                let uid = Auth.auth().currentUser?.uid
                try await database.collection("User").document(uid ?? "").updateData([
                    "gukbaps" : gukbaps,
                ])
//                self.state = .signedIn
            }catch let error {
                print("Sign Up Failed : \(error)")
            }
        }//Task
        self.state = .signedIn
    }
    
    //MARK: - KAKAO
    
    //MARK: - Kakao SignIn
    func kakaoSignIn(){
        // 카카오톡 실행 가능 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk { [self](oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoTalk() success.")
                    
                    //do something
                    if let token = oauthToken {
                        print("kakao token: \(token)")
                        fetchingFirebase()
                    }
                    self.state = .kakaoSign
                    self.selection = 2
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { [self](oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoAccount() success.")
                    if let token = oauthToken {
                        print("kakao token: \(token)")
                        fetchingFirebase()
                    }
                    //do something
                    //                    _ = oauthToken
                    
                    self.state = .kakaoSign
                    self.selection = 2
                }
            }
        }
    }
    //MARK: - Kakao SignOut
    func signOut() {
        
//        // MARK: - 구글 로그아웃
//        GIDSignIn.sharedInstance.signOut()
//        do {
//            try Auth.auth().signOut()
//            state = .signedOut
//        } catch {
//            print(error.localizedDescription)
//        }
//
        // MARK: - 카카오 로그아웃
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            }
            else {
                print("logout() success.")
                self.state = .signedOut
                
            }
        }
    }
    //MARK: - KaKao Auth, Firestore
    func fetchingFirebase(){
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
            }
            else {
                print("me() success.")
                
                Auth.auth().createUser(withEmail: (user?.kakaoAccount?.email)!, password: "\(String(describing: user?.id))") { authResult, error in
                    if let error = error {
                        print("Firebase 사용자 생성 실패: \(error.localizedDescription)")
                        Auth.auth().signIn(withEmail: (user?.kakaoAccount?.email)!, password: "\(String(describing: user?.id))")
                    } else {
                        print("Firebase 사용자 생성 성공")
                        let authResult = authResult?.user
                        let currentKakao = user?.kakaoAccount
                        Firestore.firestore().collection("User").document(authResult?.uid ?? "").setData([
                            "userEmail" : currentKakao?.email ?? "",
                            "userNickname" : currentKakao?.profile?.nickname ?? "",
                        ])
                    }
                }
                
                self.userInfo.userEmail = (user?.kakaoAccount?.email)!
                self.userInfo.userNickname = (user?.kakaoAccount?.profile?.nickname)!
//                self.userInfo.profileImage = (user?.kakaoAccount?.profile?.profileImageUrl)!
                
                print("===================")
                print(self.userInfo.userEmail)
                print(self.userInfo.userNickname)
//                print(self.userInfo.profileImage)
                print("===================")
            }
        }
    }
    
}
