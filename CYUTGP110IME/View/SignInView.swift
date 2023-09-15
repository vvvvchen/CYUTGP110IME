//
//  SignInView.swift
//  IM110
//
//  Created by 曾品瑞 on 2023/9/11.
//

import SwiftUI

struct SignInView: View {
    //存取登入狀態
    @AppStorage("logIn") private var logIn: Bool=false
    
    //提供所有View使用的User結構
    @EnvironmentObject private var user: User
    
    //執行結果Alert
    @State private var result: (Bool, String)=(false, "")
    //帳號密碼
    @State private var information: (String, String)=("", "")
    
    //MARK: 使用者登入
    private func signIn() async {
        //Authentication
        Authentication().signIn(account: self.information.0, password: self.information.1) {(_, error) in
            //登入失敗
            if let error=error {
                self.result.1=error.localizedDescription
                self.result.0.toggle()
            } else {
                //Realtime Database
                RealTime().getUser(account: self.information.0) {(result, error) in
                    //登入成功回傳的使用者資料
                    if let result=result {
                        //存進User
                        self.user.setUser(id: result[0], account: result[1], password: result[2], name: result[3])
                        self.result.1="Welcome!  \(self.user.name)"
                        self.result.0.toggle()
                    //登入失敗
                    } else if let error=error {
                        self.result.1=error.localizedDescription
                        self.result.0.toggle()
                    }
                }
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 50) {
            //MARK: 帳號
            TextField("Account", text: self.$information.0)
                .textFieldStyle(.roundedBorder)
                .bold()
            
            //MARK: 密碼
            SecureField("Password", text: self.$information.1)
                .textFieldStyle(.roundedBorder)
                .bold()
            
            VStack(spacing: 25) {
                //MARK: 登入Button
                Button("LOG IN") {
                    Task {
                        //登入
                        await self.signIn()
                    }
                }
                .bold()
                
                //MARK: SignUpView
                NavigationLink(destination: SignUpView()) {
                    Text("Don't have an account?")
                        .underline()
                        .font(.body)
                        .foregroundColor(.blue)
                }
            }
            
            Spacer()
        }
        .font(.title)
        .foregroundColor(.white)
        //MARK: 結果Alert
        .alert(self.result.1, isPresented: self.$result.0) {
            Button("Dismiss", role: .cancel) {
                if(self.result.1.hasPrefix("Welcome")) {
                    withAnimation(.easeInOut.speed(2)) {
                        self.logIn=true
                    }
                }
            }
        }
        .navigationTitle("Log In")
        .navigationBarTitleDisplayMode(.large)
        .padding()
    }
}
