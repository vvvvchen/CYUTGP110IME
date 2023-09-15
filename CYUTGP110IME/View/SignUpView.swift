//
//  SignUpView.swift
//  IM110
//
//  Created by 曾品瑞 on 2023/9/11.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) private var dismiss
    
    //執行結果Alert
    @State private var result: (Bool, String)=(false, "")
    //帳號 密碼 確認密碼 名字
    @State private var information: (String, String, String, String)=("", "", "", "")
    
    //MARK: 註冊使用者
    private func signUp() async {
        //輸入框有空 || 密碼不相同
        if(self.information.0.isEmpty || self.information.1.isEmpty || self.information.1 != self.information.2) {
            self.result.1="1. Please ensure there is no empty field.\n2. Please ensure both your passwords are same."
            self.result.0.toggle()
        } else {
            //Authentication
            Authentication().signUp(account: self.information.0, password: self.information.1) {(_, error) in
                //註冊失敗
                if let error=error {
                    self.result.1=error.localizedDescription
                    self.result.0.toggle()
                //註冊成功
                } else {
                    //Realtime Database
                    RealTime().signUp(account: self.information.0, password: self.information.1, name: self.information.3)
                    self.result.1="Sign up success!"
                    self.result.0.toggle()
                }
            }
        }
    }
    
    var body: some View {
        List {
            //MARK: 帳號
            TextField("Account", text: self.$information.0).padding(.vertical, 5)
            
            //MARK: 密碼
            SecureField("Password", text: self.$information.1).padding(.vertical, 5)
            
            //MARK: 確認密碼
            SecureField("Confirm Password", text: self.$information.2).padding(.vertical, 5)
            
            //MARK: 名字
            TextField("Name", text: self.$information.3).padding(.vertical, 5)
        }
        .bold()
        .font(.title)
        .scrollDisabled(true)
        .padding(.top)
        //MARK: 結果Alert
        .alert(self.result.1, isPresented: self.$result.0) {
            Button("Dismiss") {
                if(self.result.1.contains("success")) {
                    self.dismiss()
                }
            }
        }
        .navigationTitle("Sign Up")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            //MARK: 註冊Button
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    Task {
                        //註冊
                        await self.signUp()
                    }
                }
                .bold()
            }
        }
    }
}
