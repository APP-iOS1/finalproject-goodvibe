//
//  EditPreferenceAreaView.swift
//  GukbapMinister
//
//  Created by 전혜성 on 2023/02/03.
//

import SwiftUI
import FirebaseAuth

struct EditPreferenceAreaView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    @State private var preferenceArea: String = ""
    
    var body: some View {
        NavigationStack {
            TextField("\(userViewModel.userInfo.preferenceArea)", text: $preferenceArea)
        }
        .navigationTitle("선호하는 지역")
        .toolbar {
            Button {
                
            } label: {
                Text("완료")
            }

        }
    }
}

struct EditPreferenceAreaView_Previews: PreviewProvider {
    static var previews: some View {
        EditPreferenceAreaView()
    }
}
