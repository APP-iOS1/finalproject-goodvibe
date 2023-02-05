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
import Firebase
@MainActor
final class UserViewModel: ObservableObject {
    
    @Published var status = ""
    
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
    @Published var filterdGukbaps: [String] = []
    @Published var logStatus: Bool = false {
        didSet{
            UserDefaults.standard.set(logStatus, forKey: "logStatus")
        }
    }
    
    init(){
        self.logStatus = UserDefaults.standard.bool(forKey: "logStatus")
        self.fetchUserInfo(uid: currentUser?.uid)
    }
    
    @Published var isLoading: Bool = false
    
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
    
    let nf = NumberFormatter()
    let currentUser = Auth.auth().currentUser

    
    // MARK: - 개인정보 수정 관련 함수
    // 1. 사용자 닉네임 수정
    func updateUserNickname(nickName: String?) {
        Task{
            do{
                let uid = Auth.auth().currentUser?.uid
                try await database.collection("User").document(uid ?? "").updateData([
                    "userNickname" : nickName ?? userInfo.userNickname,
                ])
            }catch let error {
                print("\(#function) : \(error)")
            }
        }
    }
    
    // 2. 사용자 선호하는 지역 수정
    func updateUserPreferenceArea(preferenceArea: String) {
        Task{
            do{
                let uid = Auth.auth().currentUser?.uid
                try await database.collection("User").document(uid ?? "").updateData([
                    "preferenceArea" : preferenceArea ?? userInfo.preferenceArea,
                ])
            }catch let error {
                print("\(#function) : \(error)")
            }
        }
    }
    
    // 업데이트된 사용자 정보 가져오는 함수
    func fetchUpdateUserInfo() {
        let uid = Auth.auth().currentUser?.uid
        database.collection("User").document(uid ?? "")
            .addSnapshotListener { documentSnapshot, error in
              guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
              }
              guard let data = document.data() else {
                print("Document data was empty.")
                return
              }
              print("Current data: \(data)")
                self.userInfo.userNickname = data["userNickname"] as? String ?? ""
                self.userInfo.preferenceArea = data["preferenceArea"] as? String ?? ""
            }
    }
    
    // MARK: - User 정보 불러오기
    func fetchUserInfo(uid: String?) {
        guard let uid else {
            return
        }
        
        let docRef = database.collection("User").document(uid)
        docRef.getDocument { document, error in
            if let document = document, document.exists {
                let dataDescription = document.data()
                
                let email: String = dataDescription?["userEmail"] as? String ?? ""
                let nickName: String = dataDescription?["userNickname"] as? String ?? ""
                let ageRange: Int = dataDescription?["userEmail"] as? Int ?? 2
                let gukbaps: [String] = dataDescription?["gukbaps"] as? [String] ?? []
                let preferenceArea: String = dataDescription?["preferenceArea"] as? String ?? ""
                let status : String = dataDescription?["status"] as? String ?? ""
                
                
                self.userInfo.id = uid
                self.userInfo.userEmail = email
                self.userInfo.userNickname = nickName
                self.userInfo.ageRange = ageRange
                self.userInfo.gukbaps = gukbaps
                self.userInfo.preferenceArea = preferenceArea
                self.userInfo.status = status
                
            } else {
                print("Document does not exist")
            }
        }
    }
    
    // MARK: - gukbaps 중복제거
    func gukbapsDeduplicate(_ gukbapName: String) {
        if !self.gukbaps.contains(gukbapName) {
            self.gukbaps.append(gukbapName)
            print("\(#function) : 배열요소추가성공")
        } else {
            self.gukbaps = self.gukbaps.filter{$0 != gukbapName}
            print("\(#function) : 배열요소중복")
        }
    }
    //MARK: - 국밥 필터기능
    func gukbapsFilter(_ filterdGukbapName: String) {
        if !self.filterdGukbaps.contains(filterdGukbapName) {
            self.filterdGukbaps.append(filterdGukbapName)
            print("\(#function) : 배열요소추가성공")
            Task{
                do{
                    let uid = Auth.auth().currentUser?.uid
                    try await database.collection("User").document(uid ?? "").updateData([
                        "filterdGukbaps" : filterdGukbaps,
                    ])
                }catch let error{
                    print("국밥 필터링 실패: \(error)")
                }
            }
            if filterdGukbaps.count > 1{
                filterdGukbaps = []
                self.filterdGukbaps.append(filterdGukbapName)
            }
            print("필터딘 국밥: \(filterdGukbaps)")
        } else {
            self.filterdGukbaps = self.filterdGukbaps.filter{$0 != filterdGukbapName}
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
                fetchUserInfo(uid: currentUser.uid)
                logStatus = true
            }catch{
                print("Sign In Failed")
            }
        }
    }//signInUser
    
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
                    "status" : "일반",
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
                self.state = .signedIn
                logStatus = true
            }catch let error {
                print("Sign Up Failed : \(error)")
            }
        }//Task
        //        self.state = .signedIn
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
                    logStatus = true
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
                    logStatus = true
                }
            }
        }
    }
    //MARK: - 로그아웃
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
                self.logStatus = false
            }
        }
        //MARK: - 이메일 로그아웃
        //        func signOutUser() {
        self.state = .signedOut
        print("SignInView로 이동 됨")
        try? Auth.auth().signOut()
        print("Firebase Auth에서 signOut 됨")
        logStatus = false
        print("UserDefaults 로그아웃 됨")
        //        }
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
                        self.state = .signedIn
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
                self.signUpNickname = (user?.kakaoAccount?.profile?.nickname)!
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
