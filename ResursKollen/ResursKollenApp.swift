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
        
    //MARK: TabBar-utseende
        private func customizeTabBarAppearance() {
             UITabBar.appearance().unselectedItemTintColor = UIColor(Color.white.opacity(0.6))
               UITabBar.appearance().tintColor = UIColor.orange
               UITabBar.appearance().backgroundColor = UIColor(red: 49/255, green: 50/255, blue: 60/255, alpha: 1.0)

               UINavigationBar.appearance().tintColor = UIColor.orange
               UIBarButtonItem.appearance().tintColor = UIColor.orange
            
            //MARK: Badge-utseende
            
            ///Bakgrund
            
            ///GRÖN
//            UITabBarItem.appearance().badgeColor = UIColor(red: 0.232, green: 0.74, blue: 0.54, alpha: 1.0)
            
            ///LJUSARE RÖD
//            UITabBarItem.appearance().badgeColor = UIColor(red: 255/255, green: 107/255, blue: 107/255, alpha: 1.0)
            
            ///TURKOS
//            UITabBarItem.appearance().badgeColor = UIColor(
//                red: 0/255,
//                green: 147/255,
//                blue: 147/255,
//                alpha: 1.0
//            )
            
            ///GULD
//            UITabBarItem.appearance().badgeColor = UIColor(
//                red: 212/255,
//                green: 175/255,
//                blue: 55/255,
//                alpha: 1.0
//            )

            ///GUL
//            UITabBarItem.appearance().badgeColor = UIColor(
//                red: 255/255,
//                green: 191/255,
//                blue: 0/255,
//                alpha: 1.0
//            )
           
            ///LJUSGRÖN
//            UITabBarItem.appearance().badgeColor = UIColor(
//                red: 200/255,
//                green: 214/255,
//                blue: 29/255,
//                alpha: 1.0
//            )
            
            //MARK: Badge-textfärg
            UITabBarItem.appearance().setBadgeTextAttributes(
                   [.foregroundColor: UIColor.white,
                    .font: UIFont.systemFont(ofSize: 11, weight: .bold)],
                   for: .normal
               )
        }
    }

