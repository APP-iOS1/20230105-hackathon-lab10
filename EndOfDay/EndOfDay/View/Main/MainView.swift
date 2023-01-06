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
            
                
                HStack{
                    Text("\(userStore.currentUserNickname ?? "")님의 하루 끝")
                        .font(.title)
                        .fontWeight(.medium)
                    Spacer()
                }
            }
            .padding()
            .padding(.horizontal, 15)
            
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns) {
                    Button {
                        print("그룹 다이어리 추가하기")
                        showingSheet.toggle()
                    } label: {
                        RoundedRectangle(cornerRadius: 5)
                            .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [10]))
                            .foregroundColor(.gray)
                            .frame(width: 150, height: 200)
                            .overlay(
                                Image(systemName: "plus")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(.gray)
                            )
                            .foregroundColor(.black)
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
                 
                    // 개인 일기장
                    NavigationLink {
                        RecordListView(diary: diaryStore.privateDiary)
                    } label: {
                        DiaryCell(diary: diaryStore.privateDiary)
                            .padding(.vertical, 10)
                            .foregroundColor(.white)
                            .bold()
                    }
                    
                    
                    ForEach(diaryStore.diaries) { diary in
                        NavigationLink {
                            RecordListView(diary: diary)
                        } label: {
                            DiaryCell(diary: diary)
                                .padding(.vertical, 10)
                                .foregroundColor(.white)
                                
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 80)
            }
        }
        .onAppear {
            Task {
                await diaryStore.fetchDiaries()
            }
//            print("닉네임: \(userStore.currentUserNickname)")
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
    let colors: [Color] = [.redColor, .orangeColor, .yellowColor, .greenColor, .blueColor, .purpleColor]
//    let colors: [Color] = [.red, .orange, .yellow, .green, .mint, .cyan, .blue, .indigo, .purple, .brown]
    let images: [String] = ["01", "02", "03", "04","05","06","07","08"]
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .foregroundColor(.brown)
                    .overlay {
                        Image("\(images[diary.colorIndex])")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .offset(x:50)
                    }
                    
                    .frame(width: 150, height: 200)
                    .cornerRadius(20, corners: .topRight)
                    .cornerRadius(20, corners: .bottomRight)
                    .shadow(radius: 5, x: 6, y: 6)
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 2)
                    .frame(width: 100, height: 30)
                    .foregroundColor(.white)
                

                    .overlay(
                        Text(diary.dairyTitle)
                            .foregroundColor(.black)
                            .frame(width: 100, height: 30)
                            .background(Color.white)
                            .cornerRadius(10)
                    )
                    .offset(x: 12, y : -40)
                
            }
            
            //            RoundedRectangle(cornerRadius: 5)
            //                .frame(width: 150, height: 200)
            //                .foregroundColor(colors[diary.colorIndex])
            //                .overlay(
            //                    Text(diary.dairyTitle)
            //                )
            
        }
    }
}
struct diaryDraw: View {
        let imageName: String
        let stripName: String
        
        var body: some View {
            ZStack {
                Rectangle()
                    .overlay {
                        Image(imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .offset(x:50)
                    }
                    .frame(width: 150, height: 200)
                    .cornerRadius(20, corners: .topRight)
                    .cornerRadius(20, corners: .bottomRight)
                Rectangle()
                    .overlay {
                        Image(stripName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    }
                    .frame(width: 25, height: 207)
                    .cornerRadius(5)
                    .padding(.leading, 80)
            }
            .shadow(radius: 5, x: 6, y: 6)
        }
    }
// rectangle의 특정 모서리만 라운드 넣어주는 기능 구현
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}


struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}


//struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView()
//    }
//}
