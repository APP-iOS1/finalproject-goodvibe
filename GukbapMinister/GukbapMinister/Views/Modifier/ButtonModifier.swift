//
//  ButtonModifier.swift
//  GukbapMinister
//
//  Created by 기태욱 on 2023/01/17.
//

import Foundation
import SwiftUI


struct CategoryCapsuleModifier: ViewModifier {
    @Environment(\.colorScheme) var scheme
    
    var isChangedCapsuleStyle: Bool
    
    init(isChanged: Bool) {
        isChangedCapsuleStyle = isChanged
    }
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(fontColor)
            .padding(.vertical, 5)
            .padding(.horizontal, 10)
            .background(backgroundColor)
            .cornerRadius(30)
            .overlay {
                Capsule()
                    .stroke(Color.mainColor.opacity(0.5), lineWidth: 1)
            }
    }
    
    private var fontColor: Color {
        
        switch scheme {
        case .light:
            return isChangedCapsuleStyle ? .white : .black
        case .dark:
            return isChangedCapsuleStyle ? .black : .white
        @unknown default:
            return isChangedCapsuleStyle ? .white : .black
        }
    }
    
    private var backgroundColor: Color {
        switch scheme {
        case .light:
            return isChangedCapsuleStyle ? .mainColor : .white
        case .dark:
            return isChangedCapsuleStyle ? .white : .black
        @unknown default:
            return isChangedCapsuleStyle ? .mainColor : .white
        }
    }
}

extension View {
    func categoryCapsule(isChanged: Bool = false) -> some View {
            modifier(CategoryCapsuleModifier(isChanged: isChanged))
        }
}
