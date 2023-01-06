//
//  DiaryDetailView.swift
//  EndOfDay
//
//  Created by 김태성 on 2023/01/05.
//

import SwiftUI

struct DiaryDetailView: View {
    var colors = Color(red: 52 / 255, green: 152 / 255, blue: 255 / 255)
    
    var body: some View {
        VStack {
            Rectangle()
                .frame(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.height - 650)
                .cornerRadius(15)
                .foregroundColor(colors.opacity(0.3))
            
            VStack(alignment: .leading) {
                
                HStack {
                    Text("일기 내용일기 내용일기 내용일기 내용일기 내용일기 내용일기 내용일기 내용일기 내용일기 내용일기 내용일기 내용일기 내용일기 내용일기 내용일기 내용일기 내용일기 내용일기 내용일기 내용일기 내용일기 내용일기 내용")
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
                    CommentView()
                } label: {
                    Label {
                        //댓글 갯수 자리
                        Text("2")
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
        .navigationTitle("일기 디테일")
        .toolbar {
            Button {
                
            } label: {
                Text("편집")
            }
        }
    }
}
//
//struct DiaryDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            DiaryDetailView()
//        }
//    }
//}
