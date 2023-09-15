//
//  Authentication.swift
//  IM110
//
//  Created by 曾品瑞 on 2023/9/11.
//

import Foundation
import FirebaseAuth

//Firebase Authentication
struct Authentication {
    //Authentication環境
    private let authentication: Auth
    
    //MARK: 初始化
    init() {
        self.authentication=Auth.auth()
    }
    
    //MARK: 刪除
    //刪除當前使用者在Authentication的資料
    func delete() {
        //確認當前使用者有登入
        if let user=self.authentication.currentUser {
            //刪除
            user.delete()
        }
    }
    //MARK: 登入
    //當前使用者登入
    func signIn(account: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        //登入
        self.authentication.signIn(withEmail: account, password: password) {(_, error) in
            if let error=error {
                //登入失敗 -> (失敗, 錯誤資訊)
                completion(false, error)
            } else {
                //登入成功 -> (成功, 空值)
                completion(true, nil)
            }
        }
    }
    //MARK: 註冊
    func signUp(account: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        //註冊
        self.authentication.createUser(withEmail: account, password: password) {(_, error) in
            if let error=error {
                //註冊失敗 -> (失敗, 錯誤資訊)
                completion(false, error)
            } else {
                //註冊失敗 -> (成功, 空值)
                completion(true, nil)
            }
        }
    }
}
