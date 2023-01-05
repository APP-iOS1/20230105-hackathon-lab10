//
//  MyPageView.swift
//  EndOfDay
//
//  Created by 기태욱 on 2023/01/05.
//

import SwiftUI
import AlertToast

struct MyPageView: View {
    private enum Field : Int, Hashable{
        case name, location, data, addAttendee
    }
    @FocusState private var focusField : Field?
    @State private var isEdit : Bool = false
    @State var nickname : String = ""
    @EnvironmentObject var userStore: UserStore
    @Environment(\.dismiss) private var dismiss
    @State private var isShowingPopup = false
    
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
                

                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 350, height: 50)
                //                .foregroundColor(Color("LightGray"))
                    .foregroundColor(Color(UIColor.lightGray))
                    .overlay(
                        Text("로그아웃")
                            .bold()
                            .foregroundColor(.white)
                    )
                    .onTapGesture {
                        userStore.logOut()
                        
                        
                        isShowingPopup = true
                        
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                          // 1초 후 실행될 부분
                            dismiss()
                        }
                        print("코드 제출 완료")
                    }
                    .padding(.bottom, 10)
            }
            .padding(.top, 20)
        }
        .toast(isPresenting: $isShowingPopup){
            
            // `.alert` is the default displayMode
//                AlertToast(type: .regular, title: "Message Sent!")
            
            //Choose .hud to toast alert from the top of the screen
            AlertToast(displayMode: .hud, type: .regular, title: "tt")
//            AlertToast(type: .image("yellow", Color.red), title: "로그아웃 완료")
        }
    }
}

//struct MyPageView_Previews: PreviewProvider {
//    static var previews: some View {
//        MyPageView()
//    }
//}
