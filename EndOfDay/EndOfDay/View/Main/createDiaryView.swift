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
    @EnvironmentObject var userStore: UserStore
    
    //var rows: [GridItem] = Array(repeating: .init(.fixed(50)), count: 2)
    var rows: [GridItem] = [GridItem(.flexible(), spacing: 50, alignment: nil),
                            GridItem(.flexible(), spacing: 50, alignment: nil)]

    
    // TODO: color 수정
    let colors: [Color] = [.redColor, .orangeColor, .yellowColor, .greenColor, .blueColor, .purpleColor]
    let images: [String] = ["01", "02", "03", "04","05","06","07","08"]
    var trimMemo: String {
        title.trimmingCharacters(in: .whitespaces)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("일기 표지 꾸미기").bold()) {
                    VStack {
                        ZStack {
                            Rectangle()
                                .foregroundColor(.brown)
                                .overlay {
                                    Image("\(images[colorIndex])")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .offset(x:50)
                                }
                                
                                .frame(width: 180, height: 240)
                                .cornerRadius(20, corners: .topRight)
                                .cornerRadius(20, corners: .bottomRight)
                                .shadow(radius: 5, x: 6, y: 6)
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 2)
                                .frame(width: 140, height: 30)
                                .foregroundColor(.white)
                            

                                .overlay(
                                    TextField("제목을 입력하세요", text: $title, axis: .vertical)
                                        .foregroundColor(.black)
                                        .frame(width: 140, height: 30)
                                        .background(Color.white)
                                        .cornerRadius(10)
                                )
                                .offset(x: 12, y : -40)
                        }
                    }
                    .frame(width: 340)

                }
                //.padding(.horizontal, 10)
                .padding()
                
                
                Section(header: Text("표지 색상").bold()) {
                    LazyHGrid(rows: rows, spacing: 30){
                        ForEach(Array(images.enumerated()), id: \.offset) { (index, color) in // 왜 Array
                            Button {
                                colorIndex = index
                            } label: {
                                Image("\(images[index])")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle())
                                    .overlay {
                                        if colorIndex == index{
                                            Image(systemName: "checkmark")
                                                .font(.title)
                                                .foregroundColor(.accentColor)
                                        }
                                    }
                            }
                            
                            
                        }
                        
                        
                    }
                    
                }
                .frame(width: 320, alignment: .leading)
                .padding()

            }
            .padding()
            .padding(.horizontal, 10)
            
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
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("생성") {
                        let time = Date().timeIntervalSince1970
                        title = title.trimmingCharacters(in: .whitespaces)
                        let diary: Diary = Diary(id: UUID().uuidString, dairyTitle: title, colorIndex: colorIndex, createdAt: time, membersID: [diaryStore.userID], membersNickname: [userStore.user?.displayName ?? ""])
                        showingSheet.toggle()
                        Task {
                            await diaryStore.addDiary(diary: diary)
                        }
                    }
                    .foregroundColor(trimMemo.isEmpty ? .gray : .black)
                    .disabled(trimMemo.isEmpty)
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
