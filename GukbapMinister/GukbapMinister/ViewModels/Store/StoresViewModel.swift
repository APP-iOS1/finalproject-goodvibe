//
//  StoreViewModel.swift
//  GukbapMinister
//
//  Created by Martin on 2023/01/16.
//

import Foundation
//import Combine

import Firebase
import FirebaseFirestore

// 스토어의 정보를 모두 가져오는 뷰모델
final class StoresViewModel: ObservableObject {
    @Published var stores: [Store] = []
   
    private var database = Firestore.firestore()
    private var listenerRegistration: ListenerRegistration?
    
    //Store정보 구독취소
    //Store정보가 필요한 뷰에서
    //.onDisappear { viewModel.unsubscribeStores() } 하면 실행됨
    func unsubscribeStores() {
       if listenerRegistration != nil {
         listenerRegistration?.remove()
         listenerRegistration = nil
       }
     }
    
    //Store정보 구독
    //Store정보가 필요한 뷰에서
    //.onAppear { viewModel.subscribeStores() } 하면 실행됨
    func subscribeStores() {
        if listenerRegistration == nil {
            listenerRegistration =  database.collection("Store")
                .addSnapshotListener { (querySnapshot, error) in
                    guard let documents = querySnapshot?.documents else {
                        print("There are no documents")
                        return
                    }
                    
                    //FirebaseFireStoreSwift 를 써서 @Document 프로퍼티를 썼더니 가능
                    self.stores = documents.compactMap { queryDocumentSnapshot in
                        try? queryDocumentSnapshot.data(as: Store.self)
                }
            }
        }
    }
}
