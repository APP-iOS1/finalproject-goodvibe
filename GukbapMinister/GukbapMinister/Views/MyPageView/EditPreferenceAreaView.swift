//
//  EditPreferenceAreaView.swift
//  GukbapMinister
//
//  Created by 전혜성 on 2023/02/05.
//

import SwiftUI
import FirebaseAuth

enum PreferenceTextFieldFocus: Hashable {
    case preferenceFocus
}

struct EditPreferenceAreaView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    @State private var preferenceArea: String = ""
    
    @FocusState private var focused: PreferenceTextFieldFocus?
    
    let currentUser = Auth.auth().currentUser
    
    var body: some View {
        NavigationStack {
            VStack {
//                TextField("\(userViewModel.userInfo.preferenceArea)", text: $preferenceArea)
//                    .focused($focused, equals: .preferenceFocus)
            }
            .navigationTitle("선호하는 지역")
            .toolbar {
                Button {
//                    userViewModel.updateUserPreferenceArea(preferenceArea: preferenceArea)
                    dismiss()
                } label: {
                    Text("완료")
                }
            }
        }
        .onAppear {
            print("EditPreferenceArea : \(#function)")
            self.focused = .preferenceFocus
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
}

//struct EditPreferenceAreaView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditPreferenceAreaView()
//    }
//}
