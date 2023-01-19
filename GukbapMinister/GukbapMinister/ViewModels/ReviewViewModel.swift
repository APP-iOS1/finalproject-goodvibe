//
//  CommentViewModel.swift
//  GukbapMinister
//
//  Created by Martin on 2023/01/16.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import SwiftUI


class ReviewViewModel: ObservableObject {
    @Published var reviews: [Review] = []
    @Published var reviewImage: [String : UIImage] = [:]
    
    let database = Firestore.firestore()
    let storage = Storage.storage()
    
    
    init() {
        reviews = []
    }
    
    //    var id: String
    //    var userId: String
    //    var reviewText: String
    //    var createdAt: Double
    //    var image: [String]?
    //    var nickName: String
    //    var createdDate: String
    
    func fetchReviews() {
        database.collection("Reviews")
            .order(by: "createdAt", descending: true)
            .getDocuments { (snapshot, error) in
                self.reviews.removeAll()
                
                if let snapshot {
                    for document in snapshot.documents {
                        let id: String = document.documentID
                        
                        let docData = document.data()
                        let userId: String = docData["userId"] as? String ?? ""
                        let reviewText: String = docData["reviewText"] as? String ?? ""
                        let createdAt: Double = docData["createdAt"] as? Double ?? 0
                        let image: [String] = docData["image"] as? [String] ?? []
                        let nickName: String = docData["nickName"] as? String ?? ""
                        let starRating: Int = docData["starRating"] as? Int ?? 0
                        
                        for imageName in image {
                            self.retrieveImages(postitId: id, imageName: imageName)
                        }
                        
                        let review: Review = Review(id: id, userId: userId, reviewText: reviewText, createdAt: createdAt, nickName: nickName, starRating: starRating )
                        
                        self.reviews.append(review)
                        print("reviews \(self.reviews)")
                    }
                }
            }
    }
    
    // MARK: - 서버의 Postits Collection에 Postits 객체 하나를 추가하여 업로드하는 Method
    func addReview(review: Review, images: [UIImage]) async {
        do {
            // create image name list
            var imgNameList: [String] = []
            
            // iterate over images
            for img in images {
                let imgName = UUID().uuidString
                imgNameList.append(imgName)
                uploadImage(image: img, name: (review.id + "/" + imgName))
            }
            
            try await database.collection("Reviews")
                .document(review.id)
                .setData(["userId": review.userId,
                          "reviewText": review.reviewText,
                          "createdAt": review.createdAt,
                          "image": imgNameList,
                          "nickName": review.nickName
                         ])
            fetchReviews()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - 서버의 Postits Collection에서 Postits 객체 하나를 삭제하는 Method
    func removeReview(review: Review) {
        database.collection("Reviews")
            .document(review.id).delete()
        
        // remove photos from storage
        if let images = review.image {
            for image in images {
                let imagesRef = storage.reference().child("images/\(review.id)/\(image)")
                imagesRef.delete { error in
                    if let error = error {
                        print("Error removing image from storage\n\(error.localizedDescription)")
                    } else {
                        print("images directory deleted successfully")
                    }
                }
            }
        }
        fetchReviews()
    }
    
    // MARK: - 서버의 Storage에 이미지를 업로드하는 Method
    func uploadImage(image: UIImage, name: String) {
        let storageRef = storage.reference().child("images/\(name)")
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

    
    // MARK: - 서버의 Storage에서 이미지를 가져오는 Method
    func retrieveImages(postitId: String, imageName: String) {
        print("이미지 패치 함수 실행됨")
        let ref = storage.reference().child("images/\(postitId)/\(imageName)")
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        ref.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("error while downloading image\n\(error.localizedDescription)")
                return
            } else {
                let image = UIImage(data: data!)
                self.reviewImage[imageName] = image
            }
        }
    }
}
