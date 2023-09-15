//
//  ContentView.swift
//  IM110
//
//  Created by 曾品瑞 on 2023/9/11.
//
//
import SwiftUI

struct ContentView: View {
    //存取登入狀態
    @AppStorage("logIn") private var logIn: Bool=false
    
    var body: some View {
        NavigationStack {
            //已登入
            if(self.logIn) {
                ForumView().transition(.opacity)
            //未登入
            } else {
                LoginView().transition(.opacity)
            }
        }
        .ignoresSafeArea(.all)
    }
}
