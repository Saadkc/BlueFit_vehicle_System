import UIKit
import Flutter
import FirebaseCore 
import FirebaseMessaging

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate,MessagingDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    self.window.makeSecure()

      GeneratedPluginRegistrant.register(with: self)
    if FirebaseApp.app() == nil {
        FirebaseApp.configure()
    }
     if #available(iOS 10.0, *) {
         UNUserNotificationCenter.current().delegate = self
     }
  
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

   
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      
      
       Messaging.messaging().delegate = self
       let token = Messaging.messaging().fcmToken ?? "none"
       print("FCM TOKEN", token)
      
       return super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
     }
    
     func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
         print("FCM TOKEN", fcmToken!)
     }

    
  override func applicationWillResignActive(
    _ application: UIApplication
  ) {
    self.window.isHidden = true;
  }
  override func applicationDidBecomeActive(
    _ application: UIApplication
  ) {
    self.window.isHidden = false;
  }
}

//to prevent Screenshot & ScreenRecording
extension UIWindow {
 func makeSecure() {
  let field = UITextField()
  field.isSecureTextEntry = true
  self.addSubview(field)
  field.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
  field.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
  self.layer.superlayer?.addSublayer(field.layer)
  field.layer.sublayers?.first?.addSublayer(self.layer)
}
}
