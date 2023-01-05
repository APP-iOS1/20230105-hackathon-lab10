//
//  CheckEmailValidation.swift
//  EndOfDay
//
//  Created by Roen White on 2022/12/15.
//

import Foundation

// MARK: - 이메일 형식이 유효한지 검사하는 함수
func isValidEmail(_ string: String) -> Bool {
    if string.count > 100 { return false }
    let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
    return emailPredicate.evaluate(with: string)
}
