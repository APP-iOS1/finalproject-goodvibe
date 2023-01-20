//
//  MyPageView.swift
//  GukbapMinister
//
//  Created by Martin on 2023/01/16.
//

import SwiftUI

struct MyPageView: View {
    @State private var isSheetPresented: Bool = false
    var body: some View {
        NavigationStack {
            List {
                Button {
                    isSheetPresented.toggle()
                } label: {
                    Text("장소 제보하기(임시)")
                }
            }
            .sheet(isPresented: $isSheetPresented) {
                TempManagementView()
            }
        }
    }
}

struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView()
    }
}
