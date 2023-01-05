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

    
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)

    var body: some View {
        VStack{
            VStack{
                HStack{
                    Spacer()
                    Button{
                        print("일기 작성하기")
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                    .padding(.trailing, 5)

                    
                    Button{
                        print("마이 페이지")
                    } label: {
                        //Image(systemName: "person")
                        Text("MY")
                            .font(.system(size:20))
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
            
            
            NavigationStack{
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

                        
                        
                        ForEach((0...33), id: \.self) { selection in
                            
                            ImageTabViewItems(selection: selection)
                                .padding(.vertical, 10)

                            
                        }
                        
                    }
                    .padding(.horizontal, 25)
                }

                
            }
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
struct ImageTabViewItems: View {

    var selection: Int
    
    var body: some View {
        RoundedRectangle(cornerRadius: 5)
            .frame(width: 150, height: 170)
            .foregroundColor(Color("LightGray"))
            .overlay(
                Text("Diary title")
            )
            .onTapGesture {
                print(selection)
            }
    }
}


//struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView()
//    }
//}
