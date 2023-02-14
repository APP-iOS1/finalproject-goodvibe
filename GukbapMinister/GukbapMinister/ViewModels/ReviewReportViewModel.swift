//
//  ReportViewModel.swift
//  GukbapMinister
//
//  Created by 이원형 on 2023/02/08.
//



import Foundation

import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

extension Review {
    static var blank =
    Review(id: "",
           userId: "", //리뷰id
           reviewText: "",
           createdAt: 0.0 ,
           nickName: "",
           starRating: 0,
           storeName: ""
    )
    
}

final class ReviewReportViewModel: ObservableObject{
    
    enum reviewReportState {
        case yet, done, error
    }
    
    @Published var reviewReport: Review
    @Published var errorMessage: String = ""
    @Published var state: reviewReportState  = .yet
    @Published var showPopUp: Bool = false
    
    
    private var currentUser = Auth.auth().currentUser
    private var database = Firestore.firestore()

    init(reviewReport: Review = .blank) {
        self.reviewReport = reviewReport
        
        if let uid = currentUser?.uid {
            self.reviewReport.userId = uid
        }
    }
    
    private func handlePopUp(_ state: reviewReportState) {
        self.state = state
        self.showPopUp = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.showPopUp = false
        }
    }
    
    
    private func addReviewReport() {
        
        do {
           let _ = try database.collection("ReviewReport")
                .addDocument(from: self.reviewReport)
           handlePopUp(.done)
            
        }
        catch {
            errorMessage = error.localizedDescription
            handlePopUp(.error)
        }
         
        
    }
    
    

    
    func handleDoneTapped() {
        if currentUser?.uid == nil {
            errorMessage = "로그인하시고 리뷰를 신고해주세요!"
            handlePopUp(.error)
        } else {
            addReviewReport()
        }
    }
    
}
