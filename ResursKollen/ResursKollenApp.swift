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
              //  ManagerHomeView()
                ContentView()
               // StaffView()
            }
        }
        
        private func customizeTabBarAppearance() {
            // Färg för ovalda ikoner
            UITabBar.appearance().unselectedItemTintColor = UIColor(Color.orange)
            
            // Färg för vald ikon (kan även sättas med .tint modifier)
            UITabBar.appearance().tintColor = UIColor(Color.blue)
        
        }
    }


  var body: some Scene {
    WindowGroup {
      NavigationView {
          
    
          //  LoginView()
    //ManagerHomeView()
      }
    }
  }

