//
//  SearchBarModifier.swift
//  GukbapMinister
//
//  Created by Martin on 2023/02/05.
//

import SwiftUI

enum SearchBarMode {
    case button, textfield
}


struct SearchBarModifier: ViewModifier {
    @Environment(\.colorScheme) var scheme
    
    var style: SearchBarMode
    
    init(style: SearchBarMode) {
        self.style = style
    }
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(style == .button ? .gray : .black)
            .frame(width: Screen.searchBarWidth, height: 50)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(scheme == .light ? Color.white : Color.black))
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.mainColor.opacity(0.5))
                    
            }
    }
}

extension View {
    func searchBarStyle(style: SearchBarMode) -> some View {
            modifier(SearchBarModifier(style: style))
        }
}
