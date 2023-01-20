//
//  StoreViewModel.swift
//  GukbapMinister
//
//  Created by Martin on 2023/01/20.
//

import Combine

import Firebase
import FirebaseFirestore
import FirebaseStorage

final class StoreViewModel: ObservableObject {
    @Published var store: Store
    @Published var modified = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init(store: Store = Store(storeName: "", storeAddress: "", coordinate: GeoPoint(latitude: 0, longitude: 0), storeImages: [], menu: [:], description: "", countingStar: 0.0)) {
        self.store = store
        
        self.$store
            .dropFirst()
            .sink { [weak self] store in
                self?.modified = true
            }
            .store(in: &self.cancellables)
        
    }
    
    private var database = Firestore.firestore()
    private var storage = Storage.storage()
    
    
    private func addStoreInfo(_ store: Store) {
        do {
            let _ = try database.collection("Store")
                .addDocument(from: store)
        }
        catch {
            print(error)
        }
    }
    
    private func updateStoreInfo(_ store: Store) {
        
        if let documentId = store.id {
            do {
                try database.collection("Store")
                    .document(documentId)
                    .setData(from: store)
            }
            catch {
                print(error)
            }
            
        }
    }
    
    
    private func removeStoreInfo() {
        if let documentId = self.store.id {
            database.collection("Store").document(documentId).delete { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
    private func updateOrAddStoreInfo() {
        if let _ = store.id {
            self.updateStoreInfo(self.store)
        }
        else {
            //위도 경도값을 형변환해서 넣어주기
            self.store.coordinate = GeoPoint(latitude: 35, longitude: 127)
            addStoreInfo(self.store)
        }
    }
    
    //MARK: UI 핸들러
    
    func handleDoneTapped() {
        self.updateOrAddStoreInfo()
    }
    
    func handleDeleteTapped() {
        self.removeStoreInfo()
    }
    
}
