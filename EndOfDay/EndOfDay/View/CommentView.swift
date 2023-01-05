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
    var colors = Color(red: 52 / 255, green: 152 / 255, blue: 255 / 255)
    @State private var comment: String = ""
    
    var commentUser: [CommentUser] = [
        CommentUser(nickname: "김태성", comment: "나는 안졸리다 나는 안졸리다 나는 안졸리다 나는 안졸리다", time: "1분 전"),
        CommentUser(nickname: "우영우", comment: "너무 맛있어 보여요!너무 맛있어 보여요!너무 맛있어 보여요!너무 맛있어 보여요!너무 맛있어 보여요!너무 맛있어 보여요!너무 맛있어 보여요!너무 맛있어 보여요!너무 맛있어 보여요!너무 맛있어 보여요!너무 맛있어 보여요!", time: "22시간 전"),
        CommentUser(nickname: "하루끝", comment: "하루끝 너무 좋음", time: "1일 전")
    ]
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(commentUser, id: \.self) { user in
                    VStack(alignment: .leading) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(user.nickname)
                                    .bold()
                                Text(user.comment)
                                    .font(.footnote)
                                    .padding(.vertical, 0.2)
                                HStack {
                                    Spacer()
                                    Text(user.time)
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
                }
                
            }
            
            Spacer()
            
            HStack {
                TextField("댓글을 남겨보세요", text: $comment)
                    

                Button {
                    comment = ""
                } label: {
                    Text("등록")
                }

            }
            .padding()
            .background(colors.opacity(0.07))
        }
        .navigationBarTitle("댓글", displayMode: .inline)
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CommentView()
        }
    }
}
