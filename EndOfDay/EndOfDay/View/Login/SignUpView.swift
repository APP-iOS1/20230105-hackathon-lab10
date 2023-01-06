//
//  SignUpView.swift
//  EndOfDay
//
//  Created by 이재희 on 2022/12/13.
//

import SwiftUI
import PopupView

// ???: 텍스트 필드에 따라 언어도 강제할 수 있을까?

struct SignUpView: View {
    
    @EnvironmentObject private var userStore: UserStore
    @Environment(\.dismiss) private var dismiss
    
    @State private var emailID: String = ""
    @State private var nickname: String = ""
    @State private var password: String = ""
    @State private var passwordCheck: String = ""
    @State private var isShowingPopup: Bool = false
    
    // MARK: 회원가입 정보 유효성 검사
    // 이메일 유효성 확인
    private var isCheckValidEmail: Bool {
        emailID.isEmpty ? true : isValidEmail(emailID)
    }
    @State private var isDuplicatedCheck: Bool = true
    // 닉네임 길이 확인
    @State private var isNicknameCount: Bool = false
    // 비밀번호 길이 및 일치 확인
    @State private var isValidPassword: Bool = false
    
    // MARK: 나타나는 TextField마다 안내 메세지 변경
    @State private var guideMessage: String = "이메일를 입력해주세요."
    
    // MARK: 나타나는 TextField마다 포커스를 옮겨주기 위한 FocusState와 구조체
    @FocusState private var focusField: Field?
    
    enum Field: Hashable {
        case emailID
        case nickname
        case password
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment:.leading) {
                // MARK: 이메일
                HStack{
                    Text("이메일")
                    Spacer()
                    if !emailID.isEmpty && !isCheckValidEmail {
                        Text("이메일 형식이 맞지 않습니다")
                            .foregroundColor(.red)
                    } else if !emailID.isEmpty && isCheckValidEmail {
                        Text("사용가능한 이메일입니다")
                            .foregroundColor(.blue)
                    }else if emailID.isEmpty{
                        Text(" ")
                    }
                }
                TextField("이메일", text: $emailID)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).strokeBorder())
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .keyboardType(.emailAddress)
                    .focused($focusField, equals: .emailID)
                
                // MARK: 닉네임
                HStack{
                    Text("닉네임")
                    Spacer()
                    if !nickname.isEmpty && !(nickname.count > 1 && nickname.count < 9){
                        Text("닉네임 형식이 맞지 않습니다")
                            .foregroundColor(.red)
                    }else if !nickname.isEmpty && (nickname.count > 1 && nickname.count < 9){
                        Text("사용가능한 닉네임입니다")
                            .foregroundColor(.blue)
                    }else if nickname.isEmpty{
                        Text(" ")
                    }
                }
                TextField("닉네임 : 2~8자", text: $nickname)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).strokeBorder())
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .focused($focusField, equals: .nickname)
                
                // MARK: 비밀번호
                HStack{
                    Text("비밀번호")
                    Spacer()
                    if !password.isEmpty && !(password.count > 7) {
                        Text("비밀번호 형식이 맞지 않습니다")
                            .foregroundColor(.red)
                    } else if !password.isEmpty && (password.count > 7) {
                        Text("사용가능한 비밀번호입니다")
                            .foregroundColor(.blue)
                    } else if password.isEmpty{
                        Text(" ")
                    }
                }
                SecureField("8자 이상의 비밀번호", text: $password)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).strokeBorder())
                    .textContentType(.password)
                    .keyboardType(.default)
                    .focused($focusField, equals: .password)
        
                // MARK: 비밀번호 확인
                HStack{
                    Text("비밀번호 확인")
                    Spacer()
                    if !passwordCheck.isEmpty && password != passwordCheck {
                        Text("비밀번호가 일치하지 않습니다")
                            .foregroundColor(.red)
                    } else if !passwordCheck.isEmpty && password == passwordCheck {
                        Text("비밀번호가 일치합니다")
                            .foregroundColor(.blue)
                    }else if passwordCheck.isEmpty{
                        Text(" ")
                    }
                }
                SecureField("비밀번호 확인", text: $passwordCheck)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).strokeBorder())
                    .textContentType(.password)
                    .keyboardType(.default)
                
            }.padding(20)
            
            
            if !emailID.isEmpty && !nickname.isEmpty && !password.isEmpty && !passwordCheck.isEmpty && password == passwordCheck{
                Button {
                    Task {
                       await userStore.signUp(emailAddress: emailID, password: password, nickname: nickname)
                    }
                    isShowingPopup = true
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                      // 1초 후 실행될 부분
                        dismiss()
                    }
                    
                    
                } label: {
                    Text("회원가입하기")
                        .modifier(MaxWidthColoredButtonModifier(cornerRadius: 15))
                }
            }else{
                Button{
                    
                } label: {
                    Text("회원가입하기")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .bold()
                        .background(Color.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding(EdgeInsets(top: 5, leading: 20, bottom: 0, trailing: 20))
                }
            }

            
        }.navigationTitle("회원가입")
            .popup(isPresented: $isShowingPopup, type: .floater(useSafeAreaInset: true), position: .top, animation: .default, autohideIn: 2, dragToDismiss: true, closeOnTap: true, closeOnTapOutside: true, view: {
                HStack {
                    Image(systemName: "checkmark.circle")
                        .foregroundColor(.white)
                    
                    Text("환영합니다!")
                        .foregroundColor(.white)
                        .font(.footnote)
                        .bold()
                }
                
                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                .background(Color.green)
                .cornerRadius(100)
            })
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SignUpView()
                .environmentObject(UserStore())
        }
    }
}



/*
 ScrollView {
 VStack(alignment:.leading) {
 
 Text(guideMessage).font(.title)
 // 아래에서 닉네임이 유효하여 isNicknameCount가 true가 되면 보여짐
 if isNicknameCount {
 Text("비밀번호").padding(.top, 10)
 SecureField("8자 이상의 비밀번호", text: $password)
 .padding()
 .background(RoundedRectangle(cornerRadius: 10).strokeBorder())
 .textContentType(.password)
 .keyboardType(.default)
 .focused($focusField, equals: .password)
 .onAppear {
 DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
 focusField = .password
 }
 }
 
 Text("비밀번호 확인").padding(.top, 10)
 SecureField("비밀번호 확인", text: $passwordCheck)
 .padding()
 .background(RoundedRectangle(cornerRadius: 10).strokeBorder())
 .textContentType(.password)
 .keyboardType(.default)
 Text("닉네임").padding(.top, 10)
 }
 // 아래에서 이메일이 유효하여 isCheckValidEmail이 true가 되면 보여짐
 if !isDuplicatedCheck {
 TextField("닉네임 : 2~8자", text: $nickname)
 .padding()
 .background(RoundedRectangle(cornerRadius: 10).strokeBorder())
 .textInputAutocapitalization(.never)
 .disableAutocorrection(true)
 .focused($focusField, equals: .nickname)
 .onAppear {
 DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
 focusField = .nickname
 }
 }
 Text("이메일").padding(.top, 10)
 }
 
 TextField("이메일", text: $emailID)
 .padding()
 .background(RoundedRectangle(cornerRadius: 10).strokeBorder())
 .textContentType(.emailAddress)
 .textInputAutocapitalization(.never)
 .disableAutocorrection(true)
 .keyboardType(.emailAddress)
 .focused($focusField, equals: .emailID)
 .onAppear {
 // TextField가 나타나면 Focus를 이 필드로 옮겨서 키보드를 띄워줌
 DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
 focusField = .emailID
 }
 }
 if !isCheckValidEmail {
 Text("\(Image(systemName: "exclamationmark.triangle")) 잘못된 이메일 형식입니다.")
 .foregroundColor(.gray)
 }
 
 // 맨 위에서 password의 길이와 일치 검사가 모두 true면 버튼 등장
 if isValidPassword {
 Button {
 userStore.signUp(emailAddress: emailID, password: password, nickname: nickname)
 dismiss()
 } label: {
 Text("회원가입")
 .bold()
 .font(.title3)
 .foregroundColor(Color.white)
 .frame(maxWidth: .infinity, minHeight: 55)
 .background(.black)
 .cornerRadius(10)
 }
 .padding(.top)
 }
 }
 .padding()
 .toolbar {
 ToolbarItem(placement: .keyboard) {
 // MARK: - 키보드 툴바 버튼 구현
 // 텍스트 필드들이 해당 내용에 맞는 유효성 검사를 마칠 때 마다 버튼과 guideMessage 내용이 변경됨
 if isDuplicatedCheck {
 Button {
 isDuplicatedCheck = userStore.duplicateCheck(emailAddress: emailID)
 if !isCheckValidEmail && isDuplicatedCheck {
 guideMessage = "이메일을 입력해주세요."
 }
 } label: {
 Text("이메일 중복확인").font(.title2)
 }
 } else if !isNicknameCount {
 Button {
 isNicknameCount = nickname.count >= 2 && nickname.count <= 8
 if isNicknameCount {
 guideMessage = "비밀번호를 입력해주세요."
 }
 } label: {
 Text("닉네임 확인").font(.title2)
 }
 } else if !isValidPassword {
 Button {
 isValidPassword = password.count >= 8 && password == passwordCheck
 if isValidPassword {
 guideMessage = "회원가입을 눌러주세요."
 focusField = nil
 UIApplication.shared.endEditing()
 }
 } label: {
 Text("비밀번호 확인").font(.title2)
 }
 }
 }
 }
 }
 Spacer()
 */
