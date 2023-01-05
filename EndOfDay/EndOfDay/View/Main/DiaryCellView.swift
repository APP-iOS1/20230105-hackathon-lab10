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
        VStack{
            Form {
                HStack {
                    Spacer()
                    Rectangle()
                        .fill(Color.gray)
                    //                    Image(uiImage: record.photo ?? UIImage())
                    //                        .resizable()
                    //                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 300)
                    Spacer()
                }
                .listRowSeparator(.hidden)
                .padding(.top)
                
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
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.8)
            
        }
    }
}

struct DiaryCellView_Previews: PreviewProvider {
    static var previews: some View {
        DiaryCellView(record: Record(id: "111", recordTitle: "임시 타이틀", recordContent: "임시 내용", createdAt: Date().timeIntervalSince1970, writerID: "id", userNickName: "임시 nickname", photo: nil))
    }
}
