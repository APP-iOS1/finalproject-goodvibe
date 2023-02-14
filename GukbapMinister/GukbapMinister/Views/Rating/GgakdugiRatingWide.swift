//
//  GgakdugiRatingWide.swift
//  GukbapMinister
//
//  Created by Martin on 2023/01/23.
//

import SwiftUI

struct GgakdugiRatingWide: View {
    let selected: Int
    let size: CGFloat
    let spacing: CGFloat
    let perform: ((Int) -> Void)?
    
    init(selected: Int, size: CGFloat, spacing: CGFloat, perform: @escaping (Int) -> Void) {
        self.selected = selected
        self.size = size
        self.spacing = spacing
        self.perform = perform
    }
    
    var body: some View {
        HStack(spacing: spacing) {
            ForEach(0..<5) { index in
                Image(selected >= index ? "Ggakdugi" : "Ggakdugi.gray")
                    .resizable()
                    .scaledToFit()
                    .frame(width: size, height: size)
                    .onTapGesture { _ in
                        perform?(index)
                    }
            }
        }
    }
}

