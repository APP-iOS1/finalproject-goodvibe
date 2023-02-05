//
//  Enums.swift
//  GukbapMinister
//
//  Created by Martin on 2023/02/03.
//

import Foundation
import SwiftUI
import UIKit

enum Gukbaps: String, CaseIterable {
    case 순대국밥 = "순대국밥"
    case 돼지국밥
    case 내장탕
    case 선지국
    case 소머리국밥
    case 뼈해장국
    case 수구레국밥
    case 굴국밥
    case 콩나물국밥
    case 설렁탕
    case 평양온반
    case 시레기국밥
    
    
    var imageName: String {
        switch self {
        case .순대국밥: return "SDGukbap"
        case .돼지국밥: return "PigGukbap"
        case .내장탕: return ""
        case .선지국: return ""
        case .소머리국밥: return "SMRGukbap"
        case .뼈해장국: return "BHJGukbap"
        case .수구레국밥: return ""
        case .굴국밥: return "OysterGukbap"
        case .콩나물국밥: return "KNMGukbap"
        case .설렁탕: return "SRTGukbap"
        case .평양온반: return ""
        case .시레기국밥: return ""
        }
    }
    
    var image: Image {
        Image(imageName)
    }
    
    var uiImage: UIImage? {
        UIImage(named: imageName)
    }

}


