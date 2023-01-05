//
//  Comment.swift
//  EndOfDay
//
//  Created by 조석진 on 2022/12/13.
//

import Foundation

struct Comment: Identifiable {
    var id: String
    var commentContent: String
    var createdAt: Double
    var userID: String
    var userNickName: String
    
    var createdDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "MM월 dd일"
        
        let dateCreatedAt = Date(timeIntervalSince1970: createdAt)
        return dateFormatter.string(from: dateCreatedAt)
    }
}
