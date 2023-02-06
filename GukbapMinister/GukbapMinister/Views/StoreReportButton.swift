//
//  StoreReportButton.swift
//  GukbapMinister
//
//  Created by Martin on 2023/02/06.
//

import SwiftUI
import PopupView

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
                    .padding(2)
                    .padding(.horizontal, 2)
                    .background {
                        Capsule().fill(Color.mainColorDark)
                    }
                    .padding(.bottom, 4)
                    .padding(.horizontal, -20)
                
                Circle()
                    .fill(Color.mainColor)
                    .frame(width: 42, height: 42)
                    .overlay {
                        Image("Ddukbaegi.fill")
                            .font(.title3)
                            .foregroundColor(.mainColorReversed)
                    }
                
            }
                
        }
        .sheet(isPresented: $showModal) {
            NavigationStack{
                StoreReportView()
            }
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
