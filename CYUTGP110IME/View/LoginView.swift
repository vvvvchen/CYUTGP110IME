//
//  SigninView.swift
//  Graduation_Project
//
//  MARK: 註冊 Created by Mac on 2023/8/20.
//

import SwiftUI
//登入畫面
struct LoginView: View
{
    //存取登入狀態
    @AppStorage("logIn") private var logIn: Bool=false
    //提供所有View使用的User結構
    @EnvironmentObject private var user: User
    
    //執行結果Alert
    @State private var result: (Bool, String)=(false, "")
    //帳號密碼
    @State private var information: (String, String)=("", "")
    
    //開啟「忘記密碼」的狀態
    @State private var forget: Bool=false

    //手機儲存「記住我」狀態
    @State private var remember: Bool=false //之後要改
    
    
    //MARK: 使用者登入
    private func signIn() async
    {
        //Authentication
        Authentication().Login(account: self.information.0, password: self.information.1) {(_, error) in
            //登入失敗
            if let error=error
            {
                self.result.1=error.localizedDescription
                self.result.0.toggle()
            } else
            {
                //Realtime Database
                RealTime().getUser(account: self.information.0) {(result, error) in
                    //登入成功回傳的使用者資料
                    if let result=result
                    {
                        //存進User
                        self.user.setUser(id: result[0], account: result[1], password: result[2], name: result[3] , gender: result[4] , age: Int(result[5]) ?? 0 , height: Double(result[6]) ?? 0 , weight: Double(result[7]) ?? 0)
                        self.result.1="歡迎!  \(self.user.name)"
                        self.result.0.toggle()
                    //登入失敗
                    } else if let error=error
                    {
                        self.result.1=error.localizedDescription
                        self.result.0.toggle()
                    }
                }
            }
        }
    }
    
    var body: some View
    {
        NavigationStack
        {
            //已登入
            if(self.logIn) {
                ForumView().transition(.opacity)
            //未登入
//            } else {
//                LoginView().transition(.opacity)
            }
                VStack(spacing: 20)
                {
                    //MARK: logo
                    //                    Image()
                    //                        .resizable()
                    //                        .scaledToFit()
                    //                        .frame(width: 150)
                    //                        .background(.gray)
                    //                        .clipShape(Circle())
                    //                        .padding(.bottom, 50)
                    
                    Circle()
                        .fill(.gray)
                        .scaledToFit()
                        .frame(width: 150)
                        .padding(.bottom, 50)
                    
                    VStack(spacing: 30)
                    {
                        //MARK: 帳號
                        TextField("帳號...", text: self.$information.0)
                            .scrollContentBackground(.hidden)
                            .padding()
                            .background(Color(.systemGray5))
                            .clipShape(Capsule())
                        
                        //MARK: 密碼
                        SecureField("密碼...", text: self.$information.1)
                            .scrollContentBackground(.hidden)
                            .padding()
                            .background(Color(.systemGray5))
                            .clipShape(Capsule())
                    }
                    .font(.title3)
                    
                    NavigationLink(destination:SigninView(textselect: .constant(0)))
                    {
                        Text("尚未註冊嗎？請點擊我")
                            .font(.body)
                            .foregroundColor(Color(red: 0.574, green: 0.609, blue: 0.386))
                            .colorMultiply(.gray)
                    }
                    HStack
                    {
                        //MARK: 記住我
                        HStack
                        {
                            Circle()
                                .fill(Color(.systemGray6))
                                .frame(width: 20)
                                .overlay
                            {
                                Circle()
                                    .fill(.blue)
                                    .padding(5)
                                    .opacity(self.remember ? 1:0)
                            }
                            .onTapGesture
                            {
                                withAnimation(.easeInOut)
                                {
                                    self.remember.toggle()
                                }
                            }
                            
                            Text("記住我").font(.callout)
                        }
                        
                        Spacer()
                        
                        //MARK: 忘記密碼
                        Button("忘記密碼？")
                        {
                            self.forget.toggle()
                        }
                        .font(.callout)
                    }
                    .sheet(isPresented: self.$forget)
                    {
                        ForgetPasswordView()
                            .presentationDetents([.medium])
                            .presentationCornerRadius(30)
                    }
                    //MARK: 登入
                    Button
                    {
                        Task {
                            //登入
                            await self.signIn()
                        }
                    }
                label:
                    {
                        Text("登入")
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(red: 0.828, green: 0.249, blue: 0.115))
                            .clipShape(Capsule())
                    }
                    
                    //MARK: Circle
                    HStack
                    {
                        ForEach(0..<3)
                        {index in
                            Circle()
                                .fill(Color(.systemGray3))
                                .scaledToFit()
                                .frame(height: 50)
                            
                            if(index<2)
                            {
                                Spacer()
                            }
                        }
                    }
                }
                .padding(.horizontal, 50)
                .transition(.opacity)
            }
        //MARK: 結果Alert
        .alert(self.result.1, isPresented: self.$result.0)
        {
            Button("Dismiss", role: .cancel)
            {
                if(self.result.1.hasPrefix("Welcome"))
                {
                    withAnimation(.easeInOut.speed(2))
                    {
                        self.logIn=true
                    }
                }
            }
        }
        }
    }


struct LoginView_Previews: PreviewProvider
{
    static var previews: some View
    {
        LoginView()
    }
}
