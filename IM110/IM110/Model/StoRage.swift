//
//  StoRage.swift
//  IM110
//
//  Created by 曾品瑞 on 2023/9/11.
//

import Foundation
import SwiftUI
import FirebaseStorage

//Firebase Storage
struct StoRage {
    private let storage: Storage
    private let reference: StorageReference
    
    //MARK: 初始化
    init() {
        self.storage=Storage.storage()
        self.reference=self.storage.reference(forURL: "gs://im110-6f7ba.appspot.com/")
    }
    
    //MARK: 下載圖片
    func downloadPicture(path: String, name: String, completion: @escaping (Data?, Error?) -> Void) {
        //指定路徑(資料夾) 指定名稱(檔案)
        let child: StorageReference=self.reference.child(path).child(name)
        
        //取得child中的圖片
        child.getData(maxSize: .max) {(data, error) in
            //找到圖片
            if let data=data {
                completion(data, nil)
            //未找到圖片
            } else if let error=error {
                completion(nil, error)
            }
        }
    }
    //MARK: 上傳圖片
    func uploadPicture(path: String, name: String, image: UIImage) {
        //指定路徑(資料夾) 指定名稱(檔案)
        let child: StorageReference=self.reference.child(path).child(name)
        //將UIImage轉換成JPEG
        if let data=image.jpegData(compressionQuality: 1) {
            //將圖片存進child節點
            child.putData(data, metadata: nil) {(_, error) in
                //上傳失敗
                if let error=error {
                    print("Storage upload picture error: \(error.localizedDescription)")
                }
            }
        }
    }
}
