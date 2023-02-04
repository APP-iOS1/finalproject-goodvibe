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
    
    var image: Image {
        var name: String
        switch self {
        case .순대국밥: name = "SDGukbap"
        case .돼지국밥: name = "PigGukbap"
        case .내장탕: name = ""
        case .선지국: name = ""
        case .소머리국밥: name = "SMRGukbap"
        case .뼈해장국: name = "BHJGukbap"
        case .수구레국밥: name = ""
        case .굴국밥: name = "OysterGukbap"
        case .콩나물국밥: name = "KNMGukbap"
        case .설렁탕: name = ""
        case .평양온반: name = ""
        case .시레기국밥: name = ""
        }
        return Image(name)
    }
    
    var uiImage: UIImage? {
        var name: String
        switch self {
        case .순대국밥: name = "SDGukbap"
        case .돼지국밥: name = "PigGukbap"
        case .내장탕: name = ""
        case .선지국: name = ""
        case .소머리국밥: name = "SMRGukbap"
        case .뼈해장국: name = "BHJGukbap"
        case .수구레국밥: name = ""
        case .굴국밥: name = "OysterGukbap"
        case .콩나물국밥: name = "KNMGukbap"
        case .설렁탕: name = ""
        case .평양온반: name = ""
        case .시레기국밥: name = ""
        }
        
        return UIImage(named: name)
    }

}


