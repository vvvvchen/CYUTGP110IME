//
//  CYUTGP110IMEApp.swift
//  CYUTGP110IME
//
//  Created by 朝陽資管 on 2023/9/13.
//
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
struct CYUTGP110IMEApp: App {
    //提供所有View使用的User結構
    @EnvironmentObject var user: User

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    //控制深淺模式
    @AppStorage("colorScheme") private var colorScheme: Bool = true
    @StateObject private var cameraManagerViewModel = CameraManagerViewModel()

    //CoreData
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            LoginView()
                            .preferredColorScheme(self.colorScheme ? .light:.dark)
//            ContentView()
//                //CoreData連結
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//                //提供環境User初始化
//                .environmentObject(User())
//                //固定深色模式
//                .preferredColorScheme(.dark)
        }
    }
}
