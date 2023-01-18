//
//  ButtonModifier.swift
//  GukbapMinister
//
//  Created by 기태욱 on 2023/01/17.
//

import Foundation
import SwiftUI


struct CategoryButtonModifier: ViewModifier {
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(.gray)
            .padding(7.5)
            .padding(.horizontal, 5)
            .background(color)
            .cornerRadius(30)
            .overlay{
                RoundedRectangle(cornerRadius: 30)
                    .stroke(.yellow, lineWidth: 1)
            }
    }
}
