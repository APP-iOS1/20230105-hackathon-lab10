//
//  createDiaryView.swift
//  EndOfDay
//
//  Created by 기태욱 on 2023/01/05.
//


import SwiftUI

struct createDiaryView: View {
    @Binding var showingSheet: Bool
    
    @State private var title: String = ""
    @State private var colorIndex: Int = 2
    @EnvironmentObject var diaryStore: DiaryStore
    
    var rows: [GridItem] = Array(repeating: .init(.fixed(50)), count: 2)
    
    // TODO: color 수정
    let colors: [Color] = [.red, .orange, .yellow, .green, .mint, .cyan, .blue, .indigo, .purple, .brown]
    var trimMemo: String {
        title.trimmingCharacters(in: .whitespaces)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("일기 표지 꾸미기").bold()) {
                    VStack{
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: 200, height: 330)
                            .foregroundColor(colors[colorIndex])
                            .overlay(
                                TextField("제목을 입력하세요", text: $title, axis: .vertical) // axis: TextField 줄바꿈용
                                    .padding()
                            )
                    }
                    .frame(width: UIScreen.main.bounds.width - 60, alignment: .center)
                }
                .padding(.horizontal, 10)
                .padding()
                
                Spacer()
                
                Section(header: Text("표지 색상").bold()) {
                    LazyHGrid(rows: rows, spacing: 35){
                        ForEach(Array(colors.enumerated()), id: \.offset) { (index, color) in // 왜 Array
                            Button {
                                colorIndex = index
                            } label: {
                                ZStack {
                                    Circle()
                                        .foregroundColor(color)
                                        .frame(width: 40, height: 40)
                                    
                                    if colorIndex == index {
                                        Image(systemName: "checkmark")
                                            .font(.title)
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                        }
                        
                    }
                }
                .padding()
                .padding(.horizontal, 10)
                
            }
            .navigationTitle("일기장 만들기")
            .navigationBarTitleDisplayMode(.large)
            .formStyle(.columns)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button() {
                        showingSheet.toggle()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                    }
                }
                
                if trimMemo.count > 0 {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("생성") {
                            let time = Date().timeIntervalSince1970
                            title = title.trimmingCharacters(in: .whitespaces)
                            let diary: Diary = Diary(id: UUID().uuidString, dairyTitle: title, colorIndex: colorIndex, createdAt: time, membersID: ["7XUJpl1zjCcqR2NIaxGdZaNOztj1"], membersNickname: [])
                            showingSheet.toggle()
                            Task {
                                await diaryStore.addDiary(diary: diary, userID: "7XUJpl1zjCcqR2NIaxGdZaNOztj1")
                            }
                        }
                        .foregroundColor(.black)
                    }
                }
            }
        }
    }
}

//struct createDiaryView_Previews: PreviewProvider {
//    static var previews: some View {
//        createDiaryView()
//    }
//}
