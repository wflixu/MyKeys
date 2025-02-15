//
//  Item.swift
//  MyKeys
//
//  Created by 李旭 on 2024/12/6.
//

import SwiftData
import Foundation

@Model
final class PasswordItem {
    var username: String
    var websiteOrTag: String
    var password: String
    var notes: String?
    var category: String

    init(username: String, websiteOrTag: String, password: String, notes: String? = nil, category: String = "其他") {
        self.username = username
        self.websiteOrTag = websiteOrTag
        self.password = password
        self.notes = notes
        self.category = category
    }
}
