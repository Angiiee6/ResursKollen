import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct ResursKollenApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
        init() {
            customizeTabBarAppearance()
        }
        
        var body: some Scene {
            WindowGroup {
//                ManagerHomeView()
                ContentView()
                    .environment(\.colorScheme, .dark)
               // StaffView()
            }
        }
        
        private func customizeTabBarAppearance() {
            // Färg för ovalda ikoner
            UITabBar.appearance().unselectedItemTintColor = UIColor(Color.white.opacity(0.6))
            

            
            //bakgrundsfärg för meny
            UITabBar.appearance().backgroundColor = UIColor(red: 49/255, green: 50/255, blue: 60/255, alpha: 1.0)
        }
    }

