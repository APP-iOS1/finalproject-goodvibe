//
//  NavigationStackDemoView.swift
//  GukbapMinister
//
//  Created by Martin on 2023/02/03.
//

import SwiftUI

struct NavigationStackDemoView: View {
    @State private var showingModal: Bool = false
    @State private var showingFullScreen: Bool = false
    
    var body: some View {
        VStack {
            Button {
                showingModal.toggle()
            } label: {
                Text("Click Here")
            }
            .fullScreenCover(isPresented: $showingFullScreen) {
                TestFullScreenView(showingFullScreen: $showingFullScreen)
            }
        }
        .sheet(isPresented: $showingModal) {
            TestModalView(showingModal: $showingModal, showingFullScreen: $showingFullScreen)
                .presentationDetents([.height(200), .large])
        }
        

    }
}

struct TestModalView: View {
    @Binding var showingModal: Bool
    @Binding var showingFullScreen: Bool
    var body: some View {
        Button {
            showingModal = false
            showingFullScreen = true
        } label: {
            Text("this is modal")
        }
    }
}

struct TestFullScreenView: View {
    @Binding var showingFullScreen: Bool
    var body: some View {
        Button {
            showingFullScreen.toggle()
        } label: {
            Text("this is Link")
        }
    }
}

struct NavigationStackDemoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStackDemoView()
    }
}
