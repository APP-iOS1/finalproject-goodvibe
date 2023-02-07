//
//  GgakdugiRatingShort.swift
//  GukbapMinister
//
//  Created by Martin on 2023/02/07.
//

import SwiftUI

struct GgakdugiRatingShort: View {
    var rate: Double
    var size: CGFloat
    var showText: Bool
    
    init(rate: Double, size: CGFloat, showText: Bool = false) {
        self.rate = rate
        self.size = size
        self.showText = showText
    }
    
    
    
    var body: some View {
        Label {
            HStack{
                if showText {
                    Text("깍두기 점수")
                }
                Text("\(String(format: "%.1f", rate))")
            }
            .font(.footnote)
            .bold()
        } icon: {
            Image("Ggakdugi")
                .resizable()
                .scaledToFill()
                .frame(width: size, height: size)
        }

    }
}

struct GgakdugiRatingShort_Previews: PreviewProvider {
    static var previews: some View {
        GgakdugiRatingShort(rate: 4.62, size: 20)
    }
}
