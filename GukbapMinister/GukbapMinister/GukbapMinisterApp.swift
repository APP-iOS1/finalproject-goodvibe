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

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct GukbapMinisterApp: App {
  // register app delegate for Firebase setup
    init(){
        let kakaoAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] ?? ""
        KakaoSDK.initSDK(appKey: kakaoAppKey as! String)
        print("kakaoAppKey: \(kakaoAppKey)")
    }
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var userViewModel = UserViewModel()

  var body: some Scene {
    WindowGroup {
      NavigationView {
          ContentView().onOpenURL { url in
              if(AuthApi.isKakaoTalkLoginUrl(url)){
                 _ = AuthController.handleOpenUrl(url: url)
              }
          }.environmentObject(userViewModel)
      }
    }
  }
    
}
