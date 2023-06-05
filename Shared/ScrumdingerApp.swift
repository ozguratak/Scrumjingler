/*
See LICENSE folder for this sample’s licensing information.
*/

import SwiftUI
import Firebase
import GoogleMobileAds

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      
    FirebaseApp.configure()
    GADMobileAds.sharedInstance().start(completionHandler: nil)

    return true
  }
}

@main
struct ScrumdingerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var store = ScrumStore()
    @State private var errorWrapper: ErrorWrapper?

    var body: some Scene {
        WindowGroup {
            NavigationView {
                WelcomePage()
            }
        }
    }
}
