//
//  Record.swift
//  EndOfDay
//
//  Created by 조석진 on 2022/12/13.
//

import Foundation
import SwiftUI

struct Record: Identifiable {
    var id: String
    var recordTitle: String
    var recordContent: String
    var createdAt: Double
    var userID: String
    var userNickName: String
    var photos: String?
    //TODO: UIImage배열을 구조체에 넘겨주기 
//    var photo: [UIImage]
    
    var createdDate: String {
        
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ko-kr")
            dateFormatter.timeZone = TimeZone(abbreviation: "KST")
            dateFormatter.dateFormat = "yy년 MM월 dd일"

            let dateCreatedAt = Date(timeIntervalSince1970: createdAt)

            return dateFormatter.string(from: dateCreatedAt)
        }

}
