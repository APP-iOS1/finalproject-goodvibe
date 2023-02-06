//
//  StoreReport.swift
//  GukbapMinister
//
//  Created by Martin on 2023/02/06.
//


import Foundation
import SwiftUI
import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift


struct StoreReport: Codable, Hashable, Identifiable {
    @DocumentID var id: String?
    var userId: String
    var storeName: String
    var storeAddress: String
    var foodType: [String] //국밥 타입: ex:순대,돼지국밥
    var description: String
    var isUseful: Bool
}
