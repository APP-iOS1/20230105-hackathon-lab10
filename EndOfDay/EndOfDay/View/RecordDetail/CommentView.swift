//
//  CommentView.swift
//  EndOfDay
//
//  Created by 김태성 on 2023/01/05.
//

import SwiftUI

struct CommentUser: Hashable {
    var nickname: String
    var comment: String
    var time: String
}

struct CommentView: View {
    @StateObject var commentStore = CommentStore()
    var record: Record
    var colors = Color(red: 52 / 255, green: 152 / 255, blue: 255 / 255)
    @State private var comment: String = ""
    var diaryId: String
    @StateObject var diaryStore = DiaryStore()
    
//    var commentUser: [CommentUser] = [
//        CommentUser(nickname: "김태성", comment: "나는 안졸리다 나는 안졸리다 나는 안졸리다 나는 안졸리다", time: "1분 전"),
//        CommentUser(nickname: "우영우", comment: "너무 맛있어 보여요!너무 맛있어 보여요!너무 맛있어 보여요!너무 맛있어 보여요!너무 맛있어 보여요!너무 맛있어 보여요!너무 맛있어 보여요!너무 맛있어 보여요!너무 맛있어 보여요!너무 맛있어 보여요!너무 맛있어 보여요!", time: "22시간 전"),
//        CommentUser(nickname: "하루끝", comment: "하루끝 너무 좋음", time: "1일 전")
//    ]
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(commentStore.comments) { m in
                    VStack(alignment: .leading) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(m.userNickName)
                                    .bold()
                                Text(m.commentContent)
                                    .font(.footnote)
                                    .padding(.vertical, 0.2)
                                HStack {
                                    Spacer()
                                    Text(m.createdDate)
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                }
                            }
                            Spacer()
                        }
                        .padding()
                        .overlay(
                            Rectangle()
                                .cornerRadius(15)
                                .foregroundColor(colors)
                                .opacity(0.1)
                        )
                    }
                    .frame(width: UIScreen.main.bounds.width - 40)
                    
                    .contextMenu {
                        if m.writerID == diaryStore.userID {
                            Button {
                                
                                Task {
                                    await commentStore.removeComment(commentID: m.id)
                                }
                            } label: {
                                Label("삭제하기", systemImage: "trash")
                            }
                        }
                    }
                }
                
            }
            
            Spacer()
            
            HStack {
                TextField("댓글을 남겨보세요", text: $comment)

                Button {
                    Task {
                        await commentStore.addComment(Comment(id: UUID().uuidString, commentContent: comment, createdAt: Date().timeIntervalSince1970, writerID: "writerID", userNickName: "userNickName"))
                        print("comment: \(comment)")
                        comment = ""
                    }
                } label: {
                    Text("등록")
                }

            }
            .padding()
            .background(colors.opacity(0.07))
        }
        .navigationBarTitle("댓글", displayMode: .inline)
        .onAppear {
            commentStore.diaryID = diaryId
            commentStore.recordID = record.id
            Task {
                await commentStore.fetchComments()
            }
        }
    }
}

//struct Comment: Identifiable {
//    var id: String
//    var commentContent: String
//    var createdAt: Double
//    var writerID: String
//    var userNickName: String
//
//    var createdDate: String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "ko_kr")
//        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
//        dateFormatter.dateFormat = "MM월 dd일"
//
//        let dateCreatedAt = Date(timeIntervalSince1970: createdAt)
//        return dateFormatter.string(from: dateCreatedAt)
//    }
//}

//struct CommentView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            CommentView()
//        }
//    }
//}
