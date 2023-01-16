//
//  MapView.swift
//  GukbapMinister
//
//  Created by Martin on 2023/01/16.
//

import SwiftUI

struct MapView: View {
    // 초기 좌표값 서울시청
    @State var coordination: (Double, Double) = (37.5666805, 126.9784147)
    
    var body: some View {
        
        ZStack {
            VStack {
                Button(action: {coordination = (35.1379222, 129.05562775)}) {
                    Text("Move to Busan")
                }
                Button(action: {coordination = (37.413294, 127.269311)}) {
                    Text("Move to Seoul somewhere")
                }
                Spacer()
            }
            .zIndex(1)
            
            NaverMapView(coordination: coordination)
                .edgesIgnoringSafeArea(.vertical)
        }
        
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
