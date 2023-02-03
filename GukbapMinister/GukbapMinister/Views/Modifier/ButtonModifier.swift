//
//  ButtonModifier.swift
//  GukbapMinister
//
//  Created by 기태욱 on 2023/01/17.
//

import Foundation
import SwiftUI


struct CategoryButtonModifier: ViewModifier {
    var isChangedButtonStyle: Bool
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(isChangedButtonStyle ? .white : .black)
            .padding(7.5)
            .padding(.horizontal, 5)
            .background(isChangedButtonStyle ? Color("MainColor") : .white)
            .cornerRadius(30)
            .overlay{
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color.mainColor, lineWidth: 1)
            }
    }
}
