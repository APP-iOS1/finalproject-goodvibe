//
//  SearchView.swift
//  GukbapMinister
//
//  Created by 전혜성 on 2023/01/20.
//

import SwiftUI

struct SearchView: View {
    enum Mode {
        case explore, map
    }
    
    enum Field: Hashable {
        case searchBar
    }
    
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var scheme
    
    @EnvironmentObject private var mapViewModel: MapViewModel
    @StateObject var storesViewModel = StoresViewModel()
    
    @State private var searchString: String = ""
    @State private var searchResult: [Store] = []
    @FocusState private var focusField: Field?
    
    
    var mode: Mode = .map
    
    var body: some View {
        NavigationStack {
            VStack {
                searchTextField()
                searchResultList()
            }
            .onAppear {
                focusField = .searchBar
                storesViewModel.subscribeStores()
            }
            .onDisappear {
                storesViewModel.unsubscribeStores()
            }
        }
    }
}

extension SearchView {
    @ViewBuilder
    private func backButton() -> some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.backward")
                .foregroundColor(.mainColor)
        }
        .padding(.horizontal, 15)
        
    }
    
    @ViewBuilder
    private func searchTextField() -> some View {
        HStack {
            backButton()
                  
            TextField("국밥집 검색",text: $searchString, axis: .horizontal)
                .keyboardType(.default)
                .textInputAutocapitalization(.never)
                .onChange(of: searchString) { name in
                    search(name)
                }
                .focused($focusField, equals: .searchBar)
            
            if !searchString.isEmpty {
                Button {
                    searchString = ""
                } label : {
                    Image(systemName: "x.circle.fill")
                        .font(.title3)
                        .foregroundColor(.mainColor)
                }
                .offset(x: -20)
            }
            
        }
        .searchBarStyle(style: .textfield)
        .padding(.top, 13)
        .padding(.bottom)
    }
    
    @ViewBuilder
    private func searchResultList() -> some View {
        VStack {
            List {
                ForEach(searchResult, id: \.self) { store in
                    NavigationLink {
                        DetailView(store: store)
                    } label: {
                        Text("\(store.storeName)")
                    }
                }
            }
            .listStyle(.plain)
        }
    }
    
    
    
    
    private func search(_ searchString: String) {
        searchResult = storesViewModel.stores.filter {
            $0.storeName.localizedCaseInsensitiveContains(searchString)
        }
    }
}


struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
