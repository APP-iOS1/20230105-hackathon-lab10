//
//  EnterCodeView.swift
//  EndOfDay
//
//  Created by 기태욱 on 2023/01/05.
//

import SwiftUI
//import UniformTypeIdentifiers

struct EnterCodeView: View {
    private enum Field : Int, Hashable{
        case name, location, data, addAttendee
    }
    
    @State var codeText : String = ""
    @Binding var showingSheet : Bool
    
    @EnvironmentObject var diaryStore: DiaryStore
    @FocusState private var focusField : Field?
    
//    @State private var pasteboard: String = ""
    //focusField = .addAttendee
    
    
    var trimContent: String {
        codeText.trimmingCharacters(in: .whitespaces)
    }
    
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
                    Task {
                        await diaryStore.joinDiary(diaryID: codeText)
                    }
                    print("코드 제출 완료")
                    showingSheet.toggle()
                } label: {
                    Text("완료")
                        .frame(width: 340, height: 50)
                        .background(Color("LightGray"))
                        .cornerRadius(10)
                    
                }
                .disabled(trimContent.count > 0 ? false : true)

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
                    Text("붙여넣기")
                        .onTapGesture {
                            if let str = UIPasteboard.general.string {
                                codeText = str
                            }
                        }

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
