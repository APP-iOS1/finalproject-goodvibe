//
//  User.swift
//  GukbapMinister
//
//  Created by Martin on 2023/01/16.
//

import Foundation


struct User: Identifiable, Hashable, Codable {
    var id: String = UUID().uuidString
    var userNickname: String = ""
    var userEmail: String =  ""
}
