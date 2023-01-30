//
//  AppRulesView.swift
//  GukbapMinister
//
//  Created by ishio on 2023/01/30.
//

import SwiftUI

struct AppRulesView: View {
    @Environment(\.dismiss) var returnSignUpView
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("App Rules View")
            } //VStack
            .toolbar{
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        returnSignUpView()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                    }
                }
            }//toolbar
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.yellow, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }//NavigationStack
    }//var body
}

struct AppRulesView_Previews: PreviewProvider {
    static var previews: some View {
        AppRulesView()
    }
}
