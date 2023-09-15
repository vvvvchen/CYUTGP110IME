//
//  ForumView.swift
//  IM110
//
//  Created by 曾品瑞 on 2023/9/11.
//

import SwiftUI

struct ForumView: View {
    //存取登入狀態
    @AppStorage("logIn") private var logIn: Bool=false
    
    //提供所有View使用的User結構
    @EnvironmentObject private var user: User
    
    //確認Alert
    @State private var confirm: Bool=false
    //ProgressView狀態
    @State private var progress: Bool=true
    //執行結果Alert
    @State private var result: (Bool, String)=(false, "")
    //圖片
    @State private var image: [UIImage?]=[]
    //文章
    @State private var forum: [Forum]=[]
    
    //MARK: 刪除文章
    private func deleteForum(id: String) async {
        FireStore().deleteData(id: id)
    }
    //MARK: 刪除使用者
    private func deleteUser() async {
        //Authentication
        Authentication().delete()
        //Realtime Database
        RealTime().deleteUser(id: self.user.id)
        //User結構
        self.user.deleteUser()
        //刪除之後登出
        withAnimation(.easeInOut.speed(2)) {
            self.logIn=false
        }
    }
    //MARK: 查詢文章
    private func getForum() async {
        withAnimation(.easeInOut) {
            //顯示ProgressView
            self.progress=true
            //初始化圖片避免重複
            self.image=[]
            //初始化文章避免重複
            self.forum=[]
        }
        
        //MARK: Firestore
        //查詢Firestore Database的文章資料
        FireStore().getData {(success, error) in
            //有查詢結果
            if let success=success {
                //遍歷每一個資料欄位
                for i in success.documents {
                    //MARK: Storage
                    //下載對應文章的圖片
                    StoRage().downloadPicture(path: "forum", name: i.documentID) {(data, error) in
                        //將Data轉換成UIImage
                        if let data=data,
                           let image=UIImage(data: data) {
                            //將UIImage放進image
                            self.image.append(image)
                        } else {
                            //沒有圖片
                            self.image.append(nil)
                        }
                        
                        let data=i.data()
                        //將資料所有欄位轉換成Forum並放進forum
                        self.forum.append(
                            Forum(
                                id: i.documentID,
                                title: data["Title"] as! String,
                                text: data["Text"] as! String,
                                secure: data["Secure"] as! Bool,
                                author: data["Author"] as! String
                            )
                        )
                    }
                }
                //查詢錯誤
            } else if let error=error {
                self.result.1=error.localizedDescription
                self.result.0.toggle()
            }
            
            //停止顯示ProgressView
            withAnimation(.easeInOut){
                self.progress=false
            }
        }
    }
    
    var body: some View {
        ZStack {
            //MARK: ProgressView
            if(self.progress) {
                ProgressView().transition(.opacity)
                //MARK: 預設畫面
            } else if(self.forum.isEmpty && self.image.isEmpty) {
                Text("Almost Done!").font(.largeTitle).transition(.opacity)
                //MARK: 文章
            } else {
                List {
                    ForEach(self.forum.indices, id: \.self) {index in
                        //MARK: 作者
                        Section(self.forum[index].author) {
                            VStack {
                                if let image=self.image[index] {
                                    //MARK: 圖片
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .cornerRadius(10)
                                }
                                
                                VStack(alignment: .leading, spacing: 0) {
                                    //MARK: 標題
                                    Text(self.forum[index].title)
                                        .bold()
                                        .font(.title3)
                                    
                                    //MARK: 分隔線
                                    Capsule()
                                        .frame(height: 1)
                                        .padding(.top, 5)
                                        .padding(.bottom, 20)
                                    
                                    //MARK: 內容
                                    Text(self.forum[index].text)
                                        .font(.body)
                                        .multilineTextAlignment(.leading)
                                }
                                .padding()
                            }
                        }
                        .font(.title.bold())
                        .headerProminence(.increased)
                        //MARK: 隱私背景
                        .listRowBackground((self.forum[index].secure ? Color.red:Color.green).opacity(0.5))
                        .listRowInsets(EdgeInsets())
                        .swipeActions(edge: .trailing) {
                            if(self.forum[index].author==self.user.name) {
                                //MARK: 刪除文章Button
                                Button {
                                    Task {
                                        let id: String=self.forum[index].id
                                        await self.deleteForum(id: id)
                                        await self.getForum()
                                    }
                                } label: {
                                    Text("Delete")
                                }
                                .tint(.red)
                            }
                        }
                    }
                    .listRowSeparatorTint(.black)
                }
                .listStyle(.sidebar)
                .tint(.white)
                .refreshable {
                    Task {
                        await self.getForum()
                    }
                }
                .transition(.opacity)
            }
        }
        //MARK: 刪除帳號Alert
        .alert("Are you sure?", isPresented: self.$confirm) {
            Button("Cancel", role: .cancel) {}
            
            Button("Confirm", role: .destructive) {
                Task {
                    await self.deleteUser()
                }
            }
        } message: {
            Text("This action can't be undo.")
        }
        //MARK: 結果Alert
        .alert(self.result.1, isPresented: self.$result.0) {
            Button("Dismiss") {}
        }
        //MARK: Firebase查詢
        .onAppear {
            if(self.user.account.isEmpty) {
                withAnimation(.easeInOut.speed(2)) {
                    self.logIn=false
                }
            } else {
                Task {
                    await self.getForum()
                }
            }
        }
        .navigationTitle("Forum")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            //MARK: 帳號操作
            ToolbarItem(placement: .navigationBarLeading) {
                Menu("Account") {
                    Button("Log Out") {
                        self.user.deleteUser()
                        withAnimation(.easeInOut.speed(2)) {
                            self.logIn=false
                        }
                    }
                    
                    Button("Delete", role: .destructive) {
                        self.confirm.toggle()
                    }
                }
            }
            
            //MARK: PostTextView
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: PostTextView()) {
                    Text("Post").bold()
                }
            }
        }
    }
}
