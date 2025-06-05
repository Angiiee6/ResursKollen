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
    
    @StateObject var viewModel = LoginViewViewmodel()
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
        init() {
            customizeTabBarAppearance()
        }
        
        var body: some Scene {
            WindowGroup {
//                ManagerHomeView()
                ContentView()
                    .environmentObject(viewModel)
                    .environment(\.colorScheme, .dark)
                    .preferredColorScheme(.dark) // Säkerställer att sheets också får dark mode
                    .tint(.orange)
               // StaffView()
            }
        }
        
        private func customizeTabBarAppearance() {
             UITabBar.appearance().unselectedItemTintColor = UIColor(Color.white.opacity(0.6))
               UITabBar.appearance().tintColor = UIColor.orange
               UITabBar.appearance().backgroundColor = UIColor(red: 49/255, green: 50/255, blue: 60/255, alpha: 1.0)

               UINavigationBar.appearance().tintColor = UIColor.orange
               UIBarButtonItem.appearance().tintColor = UIColor.orange
//            // Färg för ovalda ikoner
//            UITabBar.appearance().unselectedItemTintColor = UIColor(Color.white.opacity(0.6))
//            UINavigationBar.appearance().tintColor = UIColor.orange
//            UIBarButtonItem.appearance().tintColor = UIColor.orange
//            UITabBar.appearance().tintColor = UIColor.orange
//
//
//            //bakgrundsfärg för meny
//            UITabBar.appearance().backgroundColor = UIColor(red: 49/255, green: 50/255, blue: 60/255, alpha: 1.0)
        }
    }

