//
//  Dairy.swift
//  EndOfDay
//
//  Created by 조석진 on 2022/12/13.
//

import Foundation

struct Diary: Identifiable {
    var id: String
    var dairyTitle: String
    var colorIndex: Int
    var createdAt: Double
    var membersID: [String]
}
