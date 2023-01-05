//
//  TestView.swift
//  EndOfDay
//
//  Created by MIJU on 2022/12/13.
//

import SwiftUI

struct TestView: View {
    @StateObject private var diaryStore: DiaryStore = DiaryStore()
    var body: some View {
        VStack {
            List{
                Text("일기장")
                HStack{
                    Button {
                        diaryStore.fetchDiaries()
                    } label: {
                        Text("읽기")
                    }
                    Button {
                        diaryStore.addDiary(Diary(id: UUID().uuidString, dairyTitle: "타이틀", colorIndex: 2, createdAt: 2))
                    } label: {
                        Text("쓰기")
                    }
                }
                Text("일기")
                HStack{
                    Button {
                        
                    } label: {
                        Text("읽기")
                    }
                    Button {
//
                    } label: {
                        Text("쓰기")
                    }
                }
                Text("댓글")
                HStack{
                    Button {
                        
                    } label: {
                        Text("읽기")
                    }
                    Button {
                        
                    } label: {
                        Text("쓰기")
                    }
                }
            }
            Button(action: {
                diaryStore.addDiary(Diary(id: UUID().uuidString, dairyTitle: "타이틀", colorIndex: 2, createdAt: 2))
            }) {
                Text("추가")
            }
            Button(action: {
                diaryStore.fetchDiaries()
            }) {
                Text("읽기")
            }
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
