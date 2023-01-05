//
//  MainView.swift
//  EndOfDay
//
//  Created by MIJU on 2023/01/05.
//

import SwiftUI

struct MainView: View {
    @State private var showingSheet = false
    @State private var showingCreatDiaryView = false
    @State private var showingEnterCodeView = false
    @EnvironmentObject var diaryStore: DiaryStore
    @EnvironmentObject var userStore: UserStore
    
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    var body: some View {
        NavigationStack {
            VStack{
                HStack{
                    Spacer()
                    NavigationLink {
                        WriteDetailView()
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .padding(.trailing, 5)
                    }
                    
                    NavigationLink {
                        MyPageView()
                    } label: {
                        Text("MY")
                            .font(.system(size:20))
                        //Image(systemName: "person")
                    }
                }
                .font(.system(size:22))
                .foregroundColor(.black)
                .padding(.trailing, 5)
                
                HStack{
                    Text("메인 뷰 타이틀")
                        .font(.largeTitle)
                    Spacer()
                }
            }
            .padding()
            .padding(.horizontal, 15)
            
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns) {
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: 150, height: 170)
                        .foregroundColor(.gray)
                        .overlay(
                            Text("+")
                        )
                        .padding(.vertical, 10)
                        .onTapGesture {
                            print("그룹 다이어리 추가하기")
                            showingSheet.toggle()
                        }
                        .confirmationDialog("", isPresented: $showingSheet, titleVisibility: .hidden) {
                            Button("일기장 만들기") {
                                showingCreatDiaryView.toggle()
                            }
                            Button("그룹 참가하기") {
                                showingEnterCodeView.toggle()
                            }
                            Button("취소", role: .cancel) {
                            }
                        }
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: 150, height: 170)
                        .foregroundColor(Color("LightGray"))
                        .overlay(
                            Text("개인 일기장")
                        )
                        .onTapGesture {
                            print("개인 일기장")
                        }
                    
                    ForEach(diaryStore.diaries) { diary in
                        NavigationLink {
                            DiaryFeedView()
                        } label: {
                            DiaryCell(diary: diary)
                                .padding(.vertical, 10)
                                .foregroundColor(.black)
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .onAppear {
            Task {
                await diaryStore.fetchDiaries(userID: "7XUJpl1zjCcqR2NIaxGdZaNOztj1")
            }
            print("닉네임: \(userStore.currentUserNickname)")
        }
        .sheet(isPresented: $showingCreatDiaryView) {
            createDiaryView(showingSheet: $showingCreatDiaryView)
        }
        .sheet(isPresented: $showingEnterCodeView) {
            EnterCodeView(showingSheet: $showingEnterCodeView)
                .presentationDetents([.height(200)])
        }
        
    }
}
struct DiaryCell: View {
    var diary: Diary
    let colors: [Color] = [.red, .orange, .yellow, .green, .mint, .cyan, .blue, .indigo, .purple, .brown]
    
    var body: some View {
        RoundedRectangle(cornerRadius: 5)
            .frame(width: 150, height: 170)
            .foregroundColor(colors[diary.colorIndex])
            .overlay(
                Text(diary.dairyTitle)
            )
    }
}




//struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView()
//    }
//}
