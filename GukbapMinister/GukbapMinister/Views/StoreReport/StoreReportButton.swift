//
//  StoreReportButton.swift
//  GukbapMinister
//
//  Created by Martin on 2023/02/06.
//

import SwiftUI

import PopupView
import Shimmer




struct StoreReportButton: View {
    @Environment(\.colorScheme) var scheme
    @State var showModal: Bool = false

    
    var body: some View {
        Button {
            showModal.toggle()
        } label: {
            VStack(spacing: 0) {
                Text("국밥집 제보")
                    .font(.caption.bold())
                    .foregroundColor(.mainColorLight)
                    .frame(width: 70, height: 20)
                    .background {
                        Capsule().fill(Color.mainColorDark)
                            .shimmering(duration: 2, delay: 5)
                    }
                    .padding(.bottom, 4)
                    
                
                
                Circle()
                    .frame(width: 45, height: 45)
                    .overlay {
                        GifImage("Ddukbaegi.boiling.5")
                            .frame(width: 45)
                            .clipShape(Circle())
                    }
                
            }
            
        }
        .sheet(isPresented: $showModal) {
            NavigationStack{
                StoreReportView()
            }
        }
        .onAppear {
//            loadGIFData()
        }
        
    }
    
}

struct StoreReportButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
            StoreReportButton()
        }
    }
}
