//
//  GukbapMinisterApp.swift
//  GukbapMinister
//
//  Created by Martin on 2023/01/16.
//

import SwiftUI
import FirebaseCore
import KakaoSDKCommon
import KakaoSDKAuth
import GoogleSignIn


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any])
      -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }
}

@main
struct GukbapMinisterApp: App {
   
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var userViewModel = UserViewModel()
    @State private var selectedViewIndex = Int.random(in: 0...2)
  // register app delegate for Firebase setup
    init(){
        let kakaoAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] ?? ""
        KakaoSDK.initSDK(appKey: kakaoAppKey as! String)
        print("kakaoAppKey: \(kakaoAppKey)")
    }
  

  var body: some Scene {
    WindowGroup {

              NavigationView{
                  ContentView(selectedViewIndex: $selectedViewIndex)
                //  MainTabView()
                      .onAppear {
                  GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                      // Check if `user` exists; otherwise, do something with `error`
                  }
              }
              // onOpenURL()을 사용해 커스텀 URL 스킴 처리
              .onOpenURL { url in
                  if(AuthApi.isKakaoTalkLoginUrl(url)){
                      _ = AuthController.handleOpenUrl(url: url)
                  }
                  GIDSignIn.sharedInstance.handle(url)
              }.environmentObject(userViewModel)
      }//Nav
    }//Window
  }
    
}
