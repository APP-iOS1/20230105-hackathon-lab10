//
//  DiaryCellView.swift
//  EndOfDay
//
//  Created by 조운상 on 2023/01/05.
//

import SwiftUI

struct RecordCellView: View {
    
    var record: Record
    
    var body: some View {
        VStack {
            Form {
                if record.photoID != "" {
                    HStack {
                        Spacer()
                        Image(uiImage: record.photo!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 300, height: 300)
                        Spacer()
                    }
                    .listRowSeparator(.hidden)
                    .padding(.top)
                }

                VStack(alignment: .leading) {
                    Text("\(record.recordTitle)")
                        .font(.title2)
                        .bold()
                        .lineLimit(1)
                    HStack {
                        Text("\(record.createdDate)")
                            .foregroundColor(.gray)
                        Spacer()
                        Text("\(record.userNickName)")
                    }
                }
                .padding(.horizontal, 10)
                
            }
            .frame(width: UIScreen.main.bounds.width - 20, height: record.photoID != "" ? UIScreen.main.bounds.height / 1.8 : UIScreen.main.bounds.height / 6.0)
            .border(Color.blue.opacity(0.1), width: 2)
        }
        .padding(.bottom, 30)
    }
}

struct RecordCellView_Previews: PreviewProvider {
    static var previews: some View {
        RecordCellView(record: Record(id: "111", recordTitle: "임시 타이틀", recordContent: "임시 내용", createdAt: Date().timeIntervalSince1970, writerID: "id", userNickName: "임시 nickname", photo: nil))
    }
}
