//
//  FireStore.swift
//  IM110
//
//  Created by 曾品瑞 on 2023/9/11.
//

import Foundation
import FirebaseFirestore

//Firebase Firestore
struct FireStore {
    //Firestore環境
    let firestore: Firestore
    
    //MARK: 初始化
    init() {
        self.firestore=Firestore.firestore()
    }
    
    //MARK: 刪除
    //刪除Firestore中指定節點的所有資料
    func deleteData(id: String) {
        self.firestore
            //Forum節點
            .collection("Forum")
            //指定ID節點
            .document(id)
            //刪除所有資料
            .delete()
    }
    //MARK: 查詢
    //查詢Firestore中指定節點的所有資料
    func getData(completion: @escaping (QuerySnapshot?, Error?) -> Void) {
        self.firestore
            //Forum節點
            .collection("Forum")
            //該節點的所有資料
            .getDocuments {(result, error) in
                if let error=error {
                    //查詢錯誤 -> (空值, 錯誤資訊)
                    completion(nil, error)
                } else {
                    //查詢成功 -> (查詢結果, 空值)
                    completion(result, nil)
                }
            }
    }
    //MARK: 寫入
    //將資料寫入Firestore
    func setData(id: String, title: String, text: String, secure: Bool, author: String, completion: @escaping (Bool, Error?) -> Void) {
        self.firestore
            //創建或寫入Forum節點
            .collection("Forum")
            //創建或寫入該id節點
            .document(id)
            //寫入Title欄位 Text欄位 Secure欄位 Author欄位
            .setData(["Title": title, "Text": text, "Secure": secure, "Author": author]) {error in
                if let error=error {
                    //寫入失敗 -> (失敗, 錯誤資訊)
                    completion(false, error)
                } else {
                    //些入成功 -> (成功, 空值)
                    completion(true, nil)
                }
            }
    }
}
