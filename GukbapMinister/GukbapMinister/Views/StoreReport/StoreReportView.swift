//
//  StoreReportView.swift
//  GukbapMinister
//
//  Created by Martin on 2023/02/06.
//

import SwiftUI

struct StoreReportView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel = StoreReportViewModel()
    @State private var didTap: [Bool] = Array(repeating: false, count: Gukbaps.allCases.count)
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Text("국밥집 이름")
                        .font(.headline)
                    Divider()
                        .frame(height: 15)
                    TextField("국밥집 상호를 입력해주세요", text: $viewModel.storeReport.storeName)
                }
                
                
                HStack {
                    Text("국밥집 주소")
                        .font(.headline)
                    Divider()
                        .frame(height: 15)
                    TextField("국밥집 주소를 입력해 주세요", text: $viewModel.storeReport.storeAddress)
                }
                
            }
            
            Section {
                Text("국밥 종류")
                    .font(.headline)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(Array(Gukbaps.allCases.enumerated()), id: \.offset) { index, gukbap in
                            Button {
                                didTap[index].toggle()
                                viewModel.updateFoodType(gukBap: gukbap.rawValue)
                            } label: {
                                HStack{
                                    gukbap.image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 20, height: 20)
                                    Text(gukbap.rawValue)
                                }
                                .categoryCapsule(isChanged: didTap[index])
                            }
                        }
                    }
                    .padding(.vertical, 5)
                }
                
            }
            
            Section {
                Text("국밥집 설명")
                    .font(.headline)
                TextField("국밥집에 대한 간단한 설명을 입력해주세요", text: $viewModel.storeReport.description, axis: .vertical)
                    .lineLimit(3, reservesSpace: true)
            }
        }
        .toolbar {
            ToolbarItem(placement:.cancellationAction) {
                Button {
                    dismiss()
                } label: {
                    Text("취소")
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    viewModel.handleDoneTapped()
                    userViewModel.updateStoreReportCount()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        dismiss()
                    }
                } label: {
                    Text("등록")
                }
                .disabled(!isReportCompleted)
                
            }
        }
        .popup(isPresented: $viewModel.showPopUp) {
            Group {
                switch viewModel.state {
                case .done: donePopUp
                case.yet: EmptyView()
                case.error: errorPopUp
                }
            }
            .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
            .background(Color.mainColor)
            .cornerRadius(100)
        } customize: {
            $0
                .autohideIn(2)
                .type(.floater())
                .position(.top)
        }
    }
    
    
    private var isReportCompleted: Bool {
        let report = viewModel.storeReport
        return !(report.storeName.isEmpty ||
                 report.storeAddress.isEmpty ||
                 report.foodType.isEmpty ||
                 report.description.isEmpty
        )
    }
    
    private var donePopUp: some View {
        HStack {
            Image(systemName: "checkmark")
                .foregroundColor(.mainColorReversed)
            Text("장소를 제보해주셔서 감사합니다.")
                .foregroundColor(.mainColorReversed)
                .font(.footnote)
                .bold()
        }
    }
    
    private var errorPopUp: some View {
        HStack {
            Image(systemName: "xmark")
                .foregroundColor(.mainColorReversed)
            Text(viewModel.errorMessage)
                .foregroundColor(.mainColorReversed)
                .font(.footnote)
                .bold()
        }
    }
}



struct StoreReportView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            StoreReportView()
        }
    }
}
