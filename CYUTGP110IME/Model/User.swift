//
//  User.swift
//  IM110
//
//  Created by 曾品瑞 on 2023/9/13.
//

import Foundation

//提供所有View使用的User結構
class User: ObservableObject {
    //ID
    @Published var id: String
    //帳號
    @Published var account: String
    //密碼
    @Published var password: String
    //名字
    @Published var name: String
    
    //MARK: 初始化
    init() {
        self.id=""
        self.account=""
        self.password=""
        self.name=""
    }
    
    //MARK: 刪除
    func deleteUser() {
        self.id=""
        self.account=""
        self.password=""
        self.name=""
    }
    //MARK: 更新
    func setUser(id: String, account: String, password: String, name: String) {
        self.id=id
        self.account=account
        self.password=password
        self.name=name
    }
}
