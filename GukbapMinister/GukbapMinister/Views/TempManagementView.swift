//
//  TempManagementView.swift
//  GukbapMinister
//
//  Created by Martin on 2023/01/20.
//

import SwiftUI

enum ManagementMode {
    case new
    case edit
}

enum ManagementAction {
    case delete
    case done
    case cancel
}


struct TempManagementView: View {
    @ObservedObject var viewModel: StoreViewModel = StoreViewModel()
    
    var mode: ManagementMode = .new
    var completionHandler: ((Result<ManagementAction, Error>) -> Void)?
    
    var body: some View {
        Form {
            Section {
                Text("상호명")
                    .font(.headline)
                TextField("상호명을 입력해 주세요", text: $viewModel.store.storeName)
                Text("주소")
                    .font(.headline)
                TextField("주소를 입력해 주세요", text: $viewModel.store.storeAddress)
            }
            
            
        }
        .formStyle(.columns)
        .padding()
    }
}

struct TempManagementView_Previews: PreviewProvider {
    static var previews: some View {
        TempManagementView(viewModel: StoreViewModel())
    }
}
