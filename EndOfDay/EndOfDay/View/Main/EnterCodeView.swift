//
//  EnterCodeView.swift
//  EndOfDay
//
//  Created by 기태욱 on 2023/01/05.
//

import SwiftUI

struct EnterCodeView: View {
    private enum Field : Int, Hashable{
        case name, location, data, addAttendee
    }
    
    @State var codeText : String = ""
    @Binding var showingSheet : Bool
    
    @EnvironmentObject var diaryStore: DiaryStore
    @FocusState private var focusField : Field?
    //focusField = .addAttendee
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .center){
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 340, height: 70)
                    .foregroundColor(Color("LightGray"))
                    .overlay(
                        
                        TextField("코드를 입력해주세요", text: $codeText)
                            .padding(.horizontal)
                            .focused($focusField, equals: .addAttendee)
                    )
                
                Button {
                    // 복사한 거 붙여넣기
                } label: {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 340, height: 50)
                        .foregroundColor(Color("LightGray"))
                        .overlay(
                            Text("붙여넣기")
                                .foregroundColor(.black)
                        )
                }
            }
            .onAppear {
//                focusField = .addAttendee
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button() {
                        showingSheet.toggle()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                    }
                }
                ToolbarItem(placement: .navigation) {
                    Text("초대 코드 입력")
                        .frame(width: 280, alignment: .center)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button() {
                        Task {
                            await diaryStore.joinDiary(diaryID: codeText)
                        }
                        print("코드 제출 완료")
                        showingSheet.toggle()
                    } label: {
                        Text("완료")
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
}

//struct EnterCodeView_Previews: PreviewProvider {
//    static var previews: some View {
//        EnterCodeView()
//    }
//}
