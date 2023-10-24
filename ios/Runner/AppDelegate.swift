import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    var flutter_native_splash = 1
    UIApplication.shared.isStatusBarHidden = false
    GMSServices.provideAPIKey("AIzaSyD3OKxgOAcHixt-EswOYdpGAVDd_qJWleQ")
    GeneratedPluginRegistrant.register(with: self)

    // This function registers the desired plugins to be used within a notification background action
          SwiftAwesomeNotificationsPlugin.setPluginRegistrantCallback { registry in
              SwiftAwesomeNotificationsPlugin.register(
                with: registry.registrar(forPlugin: "io.flutter.plugins.awesomenotifications.AwesomeNotificationsPlugin")!)
              FLTSharedPreferencesPlugin.register(
                with: registry.registrar(forPlugin: "io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin")!)
          }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}