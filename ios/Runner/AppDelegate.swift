import Flutter
import UIKit
import GoogleSignIn

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    // Firebase is initialized in Dart code via FirebaseService.initialize()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  // Handle URL callbacks for Google Sign-In
  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey: Any] = [:]
  ) -> Bool {
    // Check if this is a Google Sign-In URL
    if let scheme = url.scheme, scheme.hasPrefix("com.googleusercontent.apps") {
      if GIDSignIn.sharedInstance.handle(url) {
        return true
      }
    }
    // Let Flutter handle other URLs
    return super.application(app, open: url, options: options)
  }
}
