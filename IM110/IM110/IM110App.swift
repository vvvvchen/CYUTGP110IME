//
//  IM110App.swift
//  IM110
//
//  Created by 曾品瑞 on 2023/9/11.
//

import SwiftUI
import FirebaseCore

//MARK: Firebase
//初始化啟動Firebase
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

//MARK: Main App
@main
struct IM110App: App {
    //提供所有View使用的User結構
    @EnvironmentObject var user: User
    
    //Firebase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    //CoreData
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                //CoreData連結
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                //提供環境User初始化
                .environmentObject(User())
                //固定深色模式
                .preferredColorScheme(.dark)
        }
    }
}
