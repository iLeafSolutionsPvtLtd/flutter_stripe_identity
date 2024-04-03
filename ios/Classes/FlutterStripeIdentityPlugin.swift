import Flutter
import UIKit
import StripeIdentity

public class FlutterStripeIdentityPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_stripe_identity", binaryMessenger: registrar.messenger())
    let instance = FlutterStripeIdentityPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "stripeIdentityVerification":
        if let parameters: [String:Any] = call.arguments as? [String:Any] {
            
            var verificationSessionId = parameters["verificationSessionId"] as! String
            var ephemeralKeySecret = parameters["ephemeralKeySecret"] as! String
            presentVerificationSheet(verificationSessionId:verificationSessionId,ephemeralKeySecret:ephemeralKeySecret, callback: result)
        }
    default:
      result(FlutterMethodNotImplemented)
    }
    
  }
    func presentVerificationSheet(verificationSessionId: String, ephemeralKeySecret: String,callback:@escaping FlutterResult) {
  
    // Instantiate and present the sheet
      if #available(iOS 13, *) {
          // Configure a square brand logo. Recommended image size is 32 x 32 points.
          let configuration = IdentityVerificationSheet.Configuration(
              brandLogo: UIImage(systemName: "building.2.fill")!
          )
          let verificationSheet = IdentityVerificationSheet(
            verificationSessionId: verificationSessionId,
            ephemeralKeySecret: ephemeralKeySecret,
            configuration: configuration
          )
          verificationSheet.present(from:  UIApplication.topViewController() ?? UIViewController(), completion: { result in
            switch result {
            case .flowCompleted:
              // The user has completed uploading their documents.
              // Let them know that the verification is processing.
              print("Verification Flow Completed!")
                callback("Verification Flow Completed!")
            case .flowCanceled:
              // The user did not complete uploading their documents.
              // You should allow them to try again.
                callback("Verification Flow Canceled!")
              print("Verification Flow Canceled!")
            case .flowFailed(let error):
              // If the flow fails, you should display the localized error
              // message to your user using error.localizedDescription
              print("Verification Flow Failed!")
                callback("Verification Flow Failed!")
              print(error.localizedDescription)
            }
          })

      } else {
          // Fallback on earlier versions
      }
  }
}
extension UIApplication {
    class func topViewController(base: UIViewController? =  UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
