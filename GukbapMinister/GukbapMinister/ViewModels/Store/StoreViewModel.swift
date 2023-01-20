//
//  StoreViewModel.swift
//  GukbapMinister
//
//  Created by Martin on 2023/01/20.
//

import Combine
import SwiftUI
import PhotosUI

import Firebase
import FirebaseFirestore
import FirebaseStorage

final class StoreViewModel: ObservableObject {
    @Published var store: Store
    @Published var latitude: Double = 0.0
    @Published var longitude: Double = 0.0
    
    @Published var selectedImages: [PhotosPickerItem] = []
    @Published var selectedImageData: [Data] =  []
    @Published var convertedImages: [UIImage] =  []
    
    
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
    
    
    
    //    func addReview(review: Review, images: [UIImage]) async {
    //        do {
    //            // create image name list
    //            var imgNameList: [String] = []
    //
    //            // iterate over images
    //            for img in images {
    //                let imgName = UUID().uuidString
    //                imgNameList.append(imgName)
    //                uploadImage(image: img, name: (review.id + "/" + imgName))
    //            }
    //
    //            try await database.collection("Reviews")
    //                .document(review.id)
    //                .setData(["userId": review.userId,
    //                          "reviewText": review.reviewText,
    //                          "createdAt": review.createdAt,
    //                          "image": imgNameList,
    //                          "nickName": review.nickName
    //                         ])
    //            fetchReviews()
    //
    //        } catch {
    //            print(error.localizedDescription)
    //        }
    //    }
    
    private func convertToUIImages() {
        if !selectedImageData.isEmpty {
            for imageData in selectedImageData {
                if let image = UIImage(data: imageData) {
                    convertedImages.append(image)
                }
            }
        }
    }
    
    private func makeImageName() -> [String] {
        var imgNameList: [String] = []
        
        // iterate over images
        for img in convertedImages {
            let imgName = UUID().uuidString
            imgNameList.append(imgName)
            
            
            if let id = store.id {
                uploadImage(image: img, name: (id + "/" + imgName))
            }
        }
        
        return imgNameList
    }
    
    
    private func addStoreInfo() {
        do {
            self.convertToUIImages()
            self.store.storeImages = makeImageName()
            //위도 경도값을 형변환해서 넣어주기
            self.store.coordinate = GeoPoint(latitude: self.latitude, longitude: self.longitude)
            
            let _ = try database.collection("Store")
                .addDocument(from: self.store)
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
            addStoreInfo()
        }
    }
    
    private func uploadImage(image: UIImage, name: String) {
        let storageRef = storage.reference().child("storeImages/\(name)")
        let data = image.jpegData(compressionQuality: 0.1)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        // uploda data
        if let data = data {
            storageRef.putData(data, metadata: metadata) { (metadata, err) in
                
                if let err = err {
                    print("err when uploading jpg\n\(err)")
                }
                
                if let metadata = metadata {
                    print("metadata: \(metadata)")
                }
            }
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
