//
//  Ex+UIColor.swift
//  GukbapMinister
//
//  Created by 전혜성 on 2023/03/03.
//

import Foundation
import UIKit

extension UIColor {
    static var defaultLabelColor: UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                // UITraitCollection 의 userInterfaceStyle : 라이트인지 다크인지 알려준다.
                if traitCollection.userInterfaceStyle == .light {
                    return .black
                } else {
                    return .white
                }
            }
        } else {
            return .black
        }
    }
    static var defaultBackGroundColor: UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                // UITraitCollection 의 userInterfaceStyle : 라이트인지 다크인지 알려준다.
                if traitCollection.userInterfaceStyle == .light {
                    return .systemGray5
                } else {
                    return .black
                }
            }
        } else {
            return .black
        }
    }
}
