//
//  AuthViewModel.swift
//  EndOfDay
//
//  Created by 이재희 on 2022/12/13.
//

import SwiftUI
import FirebaseAuth

// FIXME: do~catch로 메서드 변환 필요

class UserStore: ObservableObject {
    // MARK: - 로그인한 사용자의 정보를 담고 있는 프로퍼티
    var user: User? {
        didSet { // 저장된 user 정보가 바뀌면 호출되어서 값을 업데이트
            objectWillChange.send()
        }
    }
    
    // 유저의 닉네임 패치
    @Published var currentUserNickname = Auth.auth().currentUser?.displayName
    
    func updateNickname(_ nickname: String) {
        if let currentUser = Auth.auth().currentUser?.createProfileChangeRequest() {
            currentUser.displayName = nickname
            
            currentUser.commitChanges(completion: {error in
                if let error = error {
                    print(error)
                } else {
                    print("DisplayName changed")
                }
            })
        }
        
        // TODO: await async 로 변경해야함
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
          // 1초 후 실행될 부분
            self.currentUserNickname = Auth.auth().currentUser?.displayName
        }
    }
    
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    // MARK: - 사용자의 로그인 여부를 확인하기 위한 메서드
    func listenToLoginState() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else {
                return
            }
            // 로그인이 되어 있는 상태라면 user property에 user를 할당
            self.user = user
        }
    }
    
    // MARK: - 로그인 메서드
    func logIn(emailAddress: String, password: String) {
        Task {
            do {
                try await Auth.auth().signIn(withEmail: emailAddress, password: password)
                listenToLoginState()
                print("로그인 성공")
            } catch {
                await handleError(message: "등록되지 않은 사용자 입니다.")
            }
        }
    }
    // !!!: 작동하지 않는 이메일 중복 확인
    // TODO: 이메일 중복확인 메서드 구현
    func duplicateCheck(emailAddress: String) -> Bool {
        var isDuplicated: Bool = false
        Auth.auth().fetchSignInMethods(forEmail: emailAddress) { providers, error in
            if let error {
                print(error.localizedDescription)
                self.errorMessage = "계정 정보가 없습니다."
            } else if providers != nil {
                print("이미 등록된 이메일 입니다.")
                isDuplicated = true
            } else {
                print("계정 정보가 없습니다.")
                isDuplicated = false
            }
        }
        print(isDuplicated)
        return isDuplicated
    }
    
    // MARK: - 회원가입 메서드
    // FIXME: 에러처리 필요함
    func signUp(emailAddress: String, password: String, nickname: String) {
        Auth.auth().createUser(withEmail: emailAddress, password: password) { result, error in
            if let error = error {
                print("an error occured: \(error.localizedDescription)")
                return
            } else {
                // MARK: 받아온 닉네임 정보로 사용자의 displayName 설정
                if let currentUser = Auth.auth().currentUser?.createProfileChangeRequest() {
                    currentUser.displayName = nickname
                    currentUser.photoURL = URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/7/7e/Circle-icons-profile.svg/2048px-Circle-icons-profile.svg.png")
                    currentUser.commitChanges(completion: {error in
                        if let error = error {
                            print(error)
                        } else {
                            print("DisplayName changed")
                        }
                    })
                }
                self.logIn(emailAddress: emailAddress, password: password)
            }
        }
    }
    
    // MARK: - 로그아웃 메서드
    func logOut() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    // MARK: - error 처리 메서드
    func handleError(message: String) async {
        await MainActor.run(body: {
            errorMessage = message
            showError.toggle()
        })
    }
}
