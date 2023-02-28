//
//  EditGukbapView.swift
//  GukbapMinister
//
//  Created by 전혜성 on 2023/02/03.
//

import SwiftUI
import FirebaseAuth

struct EditGukbapView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
//                SignUpGukBabView()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("선호하는 국밥")
            .toolbar {
                Button {
                    
                } label: {
                    Text("완료")
                }

            }
        }
    }
}

struct EditGukbapView_Previews: PreviewProvider {
    static var previews: some View {
        EditGukbapView()
    }
}
