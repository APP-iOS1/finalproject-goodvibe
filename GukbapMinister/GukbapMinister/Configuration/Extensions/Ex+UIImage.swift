//
//  Ex+UIImage.swift
//  GukbapMinister
//
//  Created by Martin on 2023/02/02.
//

import Foundation
import UIKit


extension UIImage {
    func getMarkerImage(foodType: String) -> UIImage? {
        var imageName: String
        
        switch foodType {
        case "순대국밥": imageName = "SDGukbap"
        case "돼지국밥": imageName = "PigGukbap"
//        case "내장탕": imageName = ""
//        case "선지국": imageName = ""
        case "소머리국밥": imageName = "SMRGukbap"
        case "뼈해장국": imageName = "BHJGukbap"
        case "굴국밥": imageName = "OysterGukbap"
        case "콩나물국밥": imageName = "KNMGukbap"
//        case "설렁탕": imageName = ""
//        case "평양온반": imageName = ""
//        case "시레기국밥": imageName = ""
        default: imageName = "SDGukbap"
        }
        
        return UIImage(named: imageName)
    }
    
    func resizeImageTo(size: CGSize) -> UIImage {
            UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
            self.draw(in: CGRect(origin: CGPoint.zero, size: size))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            return resizedImage
    }
}
