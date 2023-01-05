//
//  DiaryCellView.swift
//  EndOfDay
//
//  Created by 조운상 on 2023/01/05.
//

import SwiftUI

import SwiftUI

struct DiaryCellView: View {
    
    var record: Record
    
    var body: some View {
        VStack {
            Form {
                HStack {
                    Spacer()
                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: 250, height: 250)
                    Spacer()
                }
                .listRowSeparator(.hidden)
                
                VStack(alignment: .leading) {
                    Text("\(record.recordTitle)")
                    HStack {
                        Text("\(record.createdDate)")
                        Spacer()
                        Text("\(record.userNickName)")
                    }
                }
                .padding()
                
                
            }
            .frame(width: .infinity, height: 450)
        }
    }
}

struct DiaryCellView_Previews: PreviewProvider {
    static var previews: some View {
        DiaryCellView(record: Record(id: "111", recordTitle: "임시 타이틀", recordContent: "임시 내용", createdAt: Date().timeIntervalSince1970, userID: "id", userNickName: "임시 nickname", photo: nil))
    }
}
