//
//  SignInView.swift
//  IM110
//
//  Created by 曾品瑞 on 2023/9/11.
//
import SwiftUI

struct SigninView: View
{

    @Binding var textselect: Int
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var information: (String, String, String, String, String, Int, Double, Double)=("", "", "", "", "", 0, 0.0 , 0.0 )
  
    //執行結果Alert
    @State private var result : (Bool,String)=(false,"")

    @State private var selectedTab = 0
    init(textselect: Binding<Int>)
    {
        self._textselect=textselect
        UIPageControl.appearance().currentPageIndicatorTintColor = .orange
        UIPageControl.appearance().pageIndicatorTintColor = .gray
    }
    
    //MARK: 註冊使用者
    private func signin() async
    {
        //輸入框有空 || 密碼不相同
        if(self.information.0.isEmpty || self.information.1.isEmpty || self.information.1 != self.information.2) {
            self.result.1="1.請確保沒有空白字段。\n2. 請確保您的密碼相同。"
            self.result.0.toggle()
        } else
        {
            //Authentication
            Authentication().signin(account: self.information.0, password: self.information.1) {(_, error) in
                //註冊失敗
                if let error=error
                {
                    self.result.1=error.localizedDescription
                    self.result.0.toggle()
                //註冊成功
                } else
                {
                    //Realtime Database
                    RealTime().signin(account: self.information.0, password: self.information.1, name: self.information.3,gender: self.information.4 , age: self.information.5, height: self.information.6,weight: self.information.7)
                    self.result.1="註冊成功!"
                    self.result.0.toggle()
                }
            }
        }
    }
    
    //InformationLabel記得要搬
    private let label: [InformationLabel]=[
        InformationLabel(image: "person.text.rectangle", label: "帳號"),
        InformationLabel(image: "", label: ""),
        InformationLabel(image: "", label: ""),
        InformationLabel(image: "person.fill", label: "名稱"),
        InformationLabel(image: "figure.arms.open", label: "性別"),
        InformationLabel(image: "birthday.cake.fill", label: "年齡"),
        InformationLabel(image: "ruler", label: "身高"),
        InformationLabel(image: "dumbbell", label: "體重"),
    ]
    //MARK: 設定顯示資訊
    private func setInformation(index: Int) -> String
    {
        switch(index)
        {
        case 0:
            return self.information.0 //帳號
        case 1:
            return self.information.1 //密碼
        case 2:
            return self.information.2 //密碼a
        case 3:
            return self.information.3 //名稱
        case 4:
            return self.information.4 //性別
        case 5:
            return "\(self.information.5)" //年齡
        case 6:
            return "\(self.information.6)" //身高
        case 7:
            return "\(self.information.7)" //體重
        default:
            return ""
        }
    }
    
    //MARK: 驗證密碼
     private func passcheck() -> Bool
     {
         return !self.information.1.isEmpty && self.information.1==self.information.2
     }
     
     private func CurrenPageAcc() -> Bool
     {
         if self.information.0.isEmpty || self.information.1.isEmpty || self.information.2.isEmpty {
     
             return false
         
         } else if !self.passcheck() {

             return false
         } else {
       
             return true
         }
     }

    var body: some View
    {
        TabView(selection: $selectedTab)
        {
            NavigationStack
            {
                //MARK: 輸入帳號密碼
                VStack(spacing: 60)
                {
                    VStack(spacing: 20)
                    {
                        Text("請輸入您的帳號 密碼")
                            .font(.title2)
                            .foregroundColor(Color(red: 0.828, green: 0.249, blue: 0.115))
                        TextField("輸入您的帳號", text: self.$information.0)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .frame(width: 300, height: 50)
                            .cornerRadius(100)
                        
                        SecureField("輸入您的密碼", text: self.$information.1)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .frame(width: 300, height: 50)
                            .cornerRadius(100)
                            .lineLimit(10)
                        
                        SecureField("再次輸入密碼", text: self.$information.2)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .frame(width: 300, height: 50)
                            .cornerRadius(100)
                    }
                    Button
                    {
                        
                        selectedTab = 1
                    }
                    
                label:
                    {
                        Text("下一步")
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 300, height: 60)
                            .background(Color(red: 0.828, green: 0.249, blue: 0.115))
                            .clipShape(Capsule())
                    }
                }
            }
            .tag(0)
            
            //MARK: 輸入名稱
            VStack(spacing: 60)
            {
                VStack
                {
                    Text("請輸入您的名稱")
                        .font(.title2)
                        .foregroundColor(Color(red: 0.828, green: 0.249, blue: 0.115))
                    //MARK: text: self.$account 改 連結
                    TextField("您的名稱", text: self.$information.3)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .frame(width: 300, height: 50)
                        .cornerRadius(100)
                }
                Button
                {
                    selectedTab = 2
                }
            label:
                {
                    Text("下一步")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 300, height: 60)
                        .background(Color(red: 0.828, green: 0.249, blue: 0.115))
                        .clipShape(Capsule())
                }
            }
            .tag(1)
            
            //MARK: 選擇性別
            
            VStack(spacing: 20)
            {
                Text("請選擇您的性別")
                    .font(.title2)
                    .foregroundColor(Color(red: 0.828, green: 0.249, blue: 0.115))
                VStack
                {
                    Picker("", selection : $information.4)
                    {
                        Text("").tag("")
                        Text("男性").tag("男性")
                        Text("女性").tag("女性")
                        Text("隱私").tag("隱私")
                    }
                    .pickerStyle(.wheel)
                    .frame(width: 330, height: 100)
                }
                .padding(20)
                Button
                {
                    selectedTab = 3
                }
            label:
                {
                    Text("下一步")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 300, height: 60)
                        .background(Color(red: 0.828, green: 0.249, blue: 0.115))
                        .clipShape(Capsule())
                }
            }
            .tag(2)
            
            //MARK: 輸入年齡
            VStack(spacing: 60)
            {
                //Logo
                //                Circle()
                //                    .foregroundColor(.gray)
                //                    .frame(width: 150,height: 150)
                //                    .padding(.top,-90)
                Text("請輸入您的年齡")
                    .font(.title2)
                    .foregroundColor(Color(red: 0.828, green: 0.249, blue: 0.115))
                //年齡
                VStack
                {
                    //MARK: text: self.$account 改 連結
                    TextField("輸入您的年齡", value: self.$information.5, formatter: NumberFormatter())
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .frame(width: 300, height: 50)
                        .cornerRadius(100)
                        .keyboardType(.numberPad)
                    
                }
                .padding(20)
                
                
                Button
                {
                    selectedTab = 4
                }
            label:
                {
                    Text("下一步")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 300, height: 60)
                        .background(Color(red: 0.828, green: 0.249, blue: 0.115))
                        .clipShape(Capsule())
                }
            }
            .tag(3)
            
            //MARK: 輸入身高 體重
            VStack(spacing: 60)
            {
                
                Text("請輸入您的身高(CM)和體重(KG)")
                    .font(.title2)
                    .foregroundColor(Color(red: 0.828, green: 0.249, blue: 0.115))
               
                //身高
                VStack
                {
                    
                    TextField("輸入您的身高", value: self.$information.6, formatter: NumberFormatter())
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .frame(width: 300, height: 50)
                        .cornerRadius(100)
                }
                
                //體重
                VStack
                {
                    TextField("輸入您的體重", value: self.$information.7, formatter: NumberFormatter())
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .frame(width: 300, height: 50)
                        .cornerRadius(100)
                }
                .padding()
                
                Button
                {
                    selectedTab = 5
                }
            label:
                {
                    Text("下一步")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 300, height: 60)
                        .background(Color(red: 0.828, green: 0.249, blue: 0.115))
                        .clipShape(Capsule())
                }
            }
            .tag(4)
            
            //MARK: 所有資料
            VStack
            {
                Text("個人資訊")
                    .font(.title2)
                    .foregroundColor(Color(red: 0.828, green: 0.249, blue: 0.115))
                List
                {
                    ForEach(0..<Mirror(reflecting: self.information).children.count, id: \.self)
                    { index in
                        if(!(index==1 || index==2))
                        {
                            HStack
                            {
                                if(index<self.label.count)
                                {
                                    self.label[index]
                                }
                                Text(self.setInformation(index: index))
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .background(.clear)
                .listRowSeparator(.hidden)
                Button
                         {
                             Task
                             {
                                 //註冊
                                 await self.signin()
                             }
                         }
            label:
                {
                    Text("完成註冊～歡迎註冊")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 300, height: 60)
                        .background(Color(red: 0.828, green: 0.249, blue: 0.115))
                        .clipShape(Capsule())
                }
            }
            .tag(5)
        }
        //MARK: 結果Alert
        .alert(self.result.1, isPresented: self.$result.0)
        {
            Button("確認")
            {
                if(self.result.1.contains("success"))
                {
                    //self.dismiss()
                    
                }
            }
        }

        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
    }
}

struct SigninView_Previews: PreviewProvider
{
    static var previews: some View
    {
        NavigationStack
        {
            SigninView(textselect: .constant(0))
        }
    }
}
