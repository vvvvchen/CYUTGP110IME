//
//  RealTime.swift
//  IM110
//
//  Created by 曾品瑞 on 2023/9/11.
//

import Foundation
import FirebaseDatabase

//Firebase Realtime
struct RealTime {
    //Realtime環境
    private let reference: DatabaseReference
    
    //MARK: 初始化
    init() {
        self.reference=Database.database().reference()
    }
    //MARK: 刪除
    //刪除當前使用者在Realtime中的所有資料
    func deleteUser(id: String) {
        self.reference
            //指定User節點
            .child("User")
            //指定id節點
            .child(id)
            //刪除
            .removeValue()
    }
    //MARK: 查詢
    func getUser(account: String, completion: @escaping ([String]?, Error?) -> Void) {
        var id: String=""
        
        //查詢當前使用者在Realtime中的ID
        self.getUserID(account: account) {(result, error) in
            //有查到當前使用者ID
            if let result=result {
                id=result
                self.reference
                    //指定User節點
                    .child("User")
                    //指定ID節點
                    .child(id)
                    //查詢該ID節點中的所有資料
                    .observeSingleEvent(of: .value, with: {data in
                        //將資料轉換成NSDictionary結構 以方便查詢
                        if let value=data.value as? NSDictionary {
                            //存進completion以提供呼叫的View使用
                            completion(
                                [
                                    value["ID"] as! String,
                                    value["Account"] as! String,
                                    value["Password"] as! String,
                                    value ["Name"] as! String
                                ],
                                //錯誤為空值
                                nil
                            )
                        }
                    }) {error in
                        //查詢失敗 -> (空值, 錯誤資訊)
                        completion(nil, error)
                    }
            } else if let error=error {
                //查詢失敗 -> (空值, 錯誤資訊)
                completion(nil, error)
            }
        }
    }
    //MARK: 查詢ID
    func getUserID(account: String, completion: @escaping (String?, Error?) -> Void) {
        self.reference
            //指定User節點
            .child("User")
            //取得當前節點中的所有資料
            .getData {(error, result) in
                //有查到資料
                if let result=result {
                    //遍歷資料中的所有節點中的所有資料
                    for i in result.children.allObjects {
                        //將當前資料轉換成String結構 以方便操作
                        var describe: String=String(describing: i)
                        //當前資料中 存在當前使用者的帳號
                        if(describe.contains(account)) {
                            //切割字串擷取出使用者的ID
                            describe=String(describe[describe.firstIndex(of: "(")!..<describe.firstIndex(of: ")")!])
                            //切割字串擷取出使用者的ID
                            describe=describe[1..<describe.count]
                            //存進completion以提供呼叫的View使用
                            completion(describe, nil)
                        }
                    }
                } else if let error=error {
                    //查詢失敗 -> (空值, 錯誤資訊)
                    completion(nil, error)
                }
            }
    }
    //MARK: 註冊
    func signUp(account: String, password: String, name: String) {
        //隨機產生ID
        let id: String=UUID().uuidString
        self.reference
            //指定User節點
            .child("User")
            //指定ID節點
            .child(id)
            //寫入ID資料 Account資料 Password資料 Name資料
            .setValue(["ID": id, "Account": account, "Password": password, "Name": name]) {(error, success) in
                //寫入失敗
                if let error=error {
                    print("Realtime sign up error: \(error.localizedDescription)")
                //寫入成功
                } else {
                    print("Realtime sign up success.")
                }
            }
    }
}
