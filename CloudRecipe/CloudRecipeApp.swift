//
//  CloudRecipeApp.swift
//  CloudRecipe
//
//  Created by P. Kurt Thorderson on 10/21/20.
//

import SwiftUI

@main
struct CloudRecipeApp: App {
  @StateObject var items = Recipes()
  
    var body: some Scene {
        WindowGroup {
          ContentView()
            .environmentObject(items)
        }
    }
}

//struct MyScene: Scene {
//  @Environment(\.scenePhase) private var scenePhase
//  var body: some Scene {
//    WindowGroup {
//      MyRootView()
//    }
//  }
//}



//class SceneDelegate: UIResponder, UIWindowSceneDelegate {
//  var window: UIWindow?
//  var recipes = Recipes()
//  
//  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//    let contentView = ContentView().environmentObject(recipes)
//    
//    if let windowScene = scene as? UIWindowScene {
//      let window = UIWindow(windowScene: windowScene)
//      window.rootViewController = UIHostingController(rootView: contentView)
//      self.window = window
//      window.makeKeyAndVisible()
//    }
//  }
//  
//}
