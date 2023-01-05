//
//  LoginView.swift
//  EndOfDay
//
//  Created by 이재희 on 2022/12/13.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var userStore: UserStore
   
    @State private var emailID: String = ""
    @State private var password: String = ""
    
    // MARK: 로그인 정보 유효성 검사
    // 이메일 유효성 확인
    private var isCheckValidEmail: Bool {
        emailID.isEmpty ? true : isValidEmail(emailID)
    }
    // 비밀번호 길이 확인
    private var isPasswordCount: Bool {
        password.isEmpty ? true : password.count >= 8
    }
    // 검사에 대한 경고 메세지
    private var cautionMessage: String {
        if !isCheckValidEmail {
            return "잘못된 이메일 형식입니다."
        } else if !isPasswordCount {
            return "비밀번호는 8자리 이상이어야 합니다."
        } else {
            return ""
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment:.leading) {
                    Text("아이디")
                    TextField("이메일 아이디", text: $emailID)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).strokeBorder())
                        .textContentType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .keyboardType(.emailAddress)
                    
                    Text("비밀번호").padding(.top, 10)
                    SecureField("비밀번호", text: $password)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).strokeBorder())
                        .textContentType(.password)
                        .keyboardType(.default)
                }
                .padding([.top, .horizontal])
                
                VStack {
                    if !cautionMessage.isEmpty {
                        Text("\(Image(systemName: "exclamationmark.triangle")) \(cautionMessage)")
                            .foregroundColor(.gray)
                    } else {
                        Text(" ")
                    }
                }
                .padding(.vertical, 2)
                
                VStack {
                    Button {
                        userStore.logIn( emailAddress: emailID, password: password )
                    } label: {
                        Text("로그인")
                            .bold()
                            .font(.title3)
                            .foregroundColor(Color.white)
                            .frame(maxWidth: .infinity, minHeight: 55)
                            .background(isCheckValidEmail && isPasswordCount ? .black : .gray)
                            .cornerRadius(10)
                    }
                    .disabled(!cautionMessage.isEmpty)
                    
                    HStack {
                        Text("아직 회원이 아니신가요?").foregroundColor(.gray)
                        NavigationLink(destination: SignUpView()) {
                            Text("회원가입")
                                .bold()
                        }
                    }
                    .padding()
                }
                .padding(.horizontal)
            }
            Spacer()
        }
        .padding()
        .navigationTitle("로그인")
        // MARK: 회원 정보가 없을 시 경고창 띄움
        .alert(userStore.errorMessage, isPresented: $userStore.showError) {}
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LoginView()
                .environmentObject(UserStore())
        }
    }
}
