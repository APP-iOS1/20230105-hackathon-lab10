//
//  MyPageView.swift
//  EndOfDay
//
//  Created by 기태욱 on 2023/01/05.
//

import SwiftUI

struct MyPageView: View {
    private enum Field : Int, Hashable{
        case name, location, data, addAttendee
    }
    @FocusState private var focusField : Field?
    @State private var isEdit : Bool = false
    @State var nickname : String = ""
    @EnvironmentObject var userStore: UserStore
    @Environment(\.dismiss) private var dismiss
    @State var showingLogOutAlert = false
    
    var body: some View {
        VStack{
            VStack(alignment: .center){
                HStack{
                    Text("마이페이지")
                        .font(.title)
                        .bold()
                    
                    Spacer()
                }
                .padding(.horizontal, 21)
                
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 350, height: 120)
                    .foregroundColor(Color("LightGray"))
                    .overlay(
                        HStack{
                            VStack(alignment: .leading, spacing: 10){
                                Text("이름")
                                Text("이메일")
                            }
                            .foregroundColor(.gray)
                            .fontWeight(.regular)
                            .frame(width: 60, alignment: .leading)
                            .padding(.leading)
                            
                            VStack(alignment: .leading, spacing: 10){
                                if isEdit{
                                    TextField("이름 입력", text: $nickname)
                                        .focused($focusField, equals: .addAttendee)

                                } else{
                                    Text(userStore.currentUserNickname ?? "")
                                }
                                Text(verbatim: "test@test.test")
                                
                            }
                            .foregroundColor(.black)
                            .bold()
                            .frame(width: 170, alignment: .leading)
                            
                            
                            VStack{
                                Button{
                                    isEdit.toggle()
                                    if isEdit{
                                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                                            focusField = .addAttendee
                                        }
                                    } else {
                                        Task {
                                            await userStore.updateNickname(nickname)
                                        }
                                        print(userStore.currentUserNickname)
                                    }

                                } label: {
                                    Text(isEdit ? "완료" : "편집")
                                        .bold()
                                        .foregroundColor(.black)
                                }
                                .padding()
                                .padding(.top, 18)
                                
                                Spacer()
                            }
                        }
                    )
                    .padding(.bottom, 15)
                
                Spacer()
                
                Button {
                    showingLogOutAlert.toggle()
                    print("logout")
//                    dismiss()
                } label: {
                    Text("로그아웃")
                        .fontWeight(.bold)
                        .frame(width: 350, height: 50)
                        .background(Color(.black))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.bottom, 10)
                .alert("로그아웃", isPresented: $showingLogOutAlert) {
                    Button("취소", role: .cancel) {}
                    Button("확인", role: .destructive) {
                        print(userStore.page)
                        userStore.logOut()
                        print(userStore.page)
                    }
                } message: {
                    Text("로그아웃 하시겠습니까?")
                }

//                RoundedRectangle(cornerRadius: 10)
//                    .frame(width: 350, height: 50)
//                //                .foregroundColor(Color("LightGray"))
//                    .foregroundColor(Color(UIColor.lightGray))
//                    .overlay(
//                        Text("로그아웃")
//                            .bold()
//                            .foregroundColor(.white)
//                    )
//                    .onTapGesture {
//                        userStore.logOut()
//                        dismiss()
//                        print("코드 제출 완료")
//                    }
//                    .padding(.bottom, 10)
            }
            .padding(.top, 20)
        }
    }
}

//struct MyPageView_Previews: PreviewProvider {
//    static var previews: some View {
//        MyPageView()
//    }
//}
