//
//  User.swift
//  IM110
//
//  Created by 曾品瑞 on 2023/9/13.
//

import Foundation

//提供所有View使用的User結構
class User: ObservableObject
{
    //ID
    @Published var id: String
    //帳號
    @Published var account: String
    //密碼
    @Published var password: String
    //名字
    @Published var name: String
    //性別
    @Published var gender: String
    //年齡
    @Published var age: Int
    //身高
    @Published var height: Double
    //體重
    @Published var weight: Double
    
    //MARK: 初始化
    init()
    {
        self.id=""
        self.account=""
        self.password=""
        self.name=""
        self.gender=""
        self.age=0
        self.height=0.0
        self.weight=0.0
        
    }
    
    //MARK: 刪除
    func deleteUser()
    {
        self.id=""
        self.account=""
        self.password=""
        self.name=""
        self.gender=""
        self.age=0
        self.height=0.0
        self.weight=0.0
    }
    //MARK: 更新
    func setUser(id: String, account: String, password: String, name: String, gender: String, age: Int, height: Double, weight: Double)
    {
        self.id=id
        self.account=account
        self.password=password
        self.name=name
        self.gender=gender
        self.age=age
        self.height=height
        self.weight=weight
    }
}

