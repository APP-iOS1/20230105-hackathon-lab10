//
//  DiaryDetailView.swift
//  EndOfDay
//
//  Created by 김태성 on 2023/01/05.
//

import SwiftUI

struct DiaryDetailView: View {
    var colors = Color(red: 52 / 255, green: 152 / 255, blue: 255 / 255)
    var record: Record
    @StateObject var commentStore = CommentStore()
    var diaryId: String
    @StateObject var recordStore = RecordStore()
    @StateObject var diaryStore = DiaryStore()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            VStack{
//                Form {
                    HStack {
                        Spacer()
                        Rectangle()
                            .fill(colors.opacity(0.2))
                        // TODO: Rectangle -> Image 변경하기
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
                            
                            Spacer()
                            Text("\(record.createdDate)")
                                .foregroundColor(.gray)
                                .font(.footnote)
//                            Text("\(record.userNickName)")
                        }
                    }
                    .padding(.horizontal, 30)
                    
//                }
//                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.8)
                
            }
            
            VStack(alignment: .leading) {
                
                HStack {
                    Text(record.recordContent)
                    Spacer()
                }
                .padding()
                .overlay(
                    Rectangle()
                        .cornerRadius(15)
                        .foregroundColor(colors)
                        .opacity(0.1)
                )
            }.frame(width: UIScreen.main.bounds.width - 40)

            Spacer()
            
            HStack {
                NavigationLink {
                    CommentView(record: record, diaryId: diaryId)
                } label: {
                    Label {
                        //댓글 갯수 자리
                        Text("\(commentStore.comments.count)")
                    } icon: {
                        Image(systemName: "message")
                    }
                    .foregroundColor(.black)
                }
                Spacer()
            }
            .padding()
            .background(colors.opacity(0.07))
        }
        .navigationTitle("\(record.userNickName)의 일기")
        .toolbar {
            if record.writerID == diaryStore.userID {
                Menu {
                    Button {
                        Task {
                            await recordStore.removeRecord(recordID: record.id)
                            dismiss()
                        }
                    } label: {
                        Label("삭제하기", systemImage: "trash")
                    }

                } label: {
                    Image(systemName: "ellipsis")
                }
            }

        }
        .onAppear {
            commentStore.diaryID = diaryId
            commentStore.recordID = record.id
            Task {
                await commentStore.fetchComments()
            }
        }
    }
}
