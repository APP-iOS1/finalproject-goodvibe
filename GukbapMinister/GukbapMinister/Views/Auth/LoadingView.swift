//
//  LoadingView.swift
//  GukbapMinister
//
//  Created by ishio on 2023/01/20.
//

import SwiftUI

struct LoadingView: View {
    @Binding var show: Bool
    
    var body: some View {
        ZStack {
            if show{
                Group{
                    Rectangle()
                        .fill(.black.opacity(0.1))
                        .ignoresSafeArea()
                    ProgressView()
                        .padding(15)
                        .background(.white, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                }//Group
            } //if
        }//ZStack
        .animation(.easeInOut(duration: 0.1), value: show)
    }
}

//struct LoadingView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoadingView()
//    }
//}
