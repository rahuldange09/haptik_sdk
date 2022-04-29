import Flutter
import UIKit
import HPWebKit

//Set 0 if adding the Production URL else keep it as 1 (Staging).
typealias JsonDictionary = [String: Any]
typealias StringDictionary = [String: String]

public class SwiftHaptikSdkPlugin: NSObject, FlutterPlugin {
//    private var channel: FlutterMethodChannel?
//    private var flutterResult: Result?
    private var viewContoller: FlutterViewController?
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "haptik_sdk", binaryMessenger: registrar.messenger())
    let instance = SwiftHaptikSdkPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
      
//      let METHOD_CHANNEL_NAME = "flutter.native/nativeModule"
//           let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
//          controller.navigationController?.interactivePopGestureRecognizer?.isEnabled = false;
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
     
      switch call.method {
      case "init":
          guard let json = call.arguments as? JsonDictionary else { return }
          initWithArguments(arguments: json)
      case "loadSignupConversation":
          guard let json = call.arguments as? JsonDictionary else { return }
          loadSignupConversation(arguments: json, result: result)
      case "loadGuestConversation": loadGuestConversation(result: result)
      case "setNotificationToken":
          guard let deviceToken = call.arguments as? Data else { return }
          HPKit.sharedSDK.setDeviceToken(deviceToken: deviceToken)
      case "isHaptikNotification":
          guard let userInfo = call.arguments as? StringDictionary else { return }
          let haptikNotification = (HPKit.sharedSDK.canHandleNotificationWith(UserInfo: userInfo))
          result(haptikNotification)
      case "handleNotification":
          guard let json = call.arguments as? StringDictionary else { return }
          handleNotification(arguments: json)
      case "setLaunchMessage":
          guard let json = call.arguments as? JsonDictionary else { return }
          setLaunchMessage(arguments: json)
      case "destroy": destroy()
      case "logout": logout()
      default:
          result("notImplemented()")
      }
  }

    private func initWithArguments(arguments: JsonDictionary) {
        HPKit.sharedSDK.setup()
      }

    private func getString(json: JsonDictionary, key: String) -> String {
        if let data = json[key] as? String {
            return data
        }
        else {
            return ""
        }
    }
    
    private func loadSignupConversation(arguments: JsonDictionary, result: @escaping FlutterResult) {
        guard let viewContoller = viewContoller else { return }
        let authAttribute = HPWebKit.HPAttributesBuilder.build { [self] builder in
            builder.authCode = getString(json: arguments, key: "authCode")
            builder.authID = getString(json: arguments, key: "authId")
            builder.userName = getString(json: arguments, key: "userName")
            builder.email = getString(json: arguments, key: "email")
            builder.mobile = getString(json: arguments, key: "mobileNo")
            builder.signupType = getString(json: arguments, key: "signupType")
        }
        var customData = StringDictionary()
        if let data = arguments["customData"] as? StringDictionary {
            customData = data
        }
        do {
            try HPKit.sharedSDK.loadConversation(launchController: viewContoller, attributes: authAttribute, customData: customData)
            result(true)
//            flutterResult.success(response.status)
        } catch {
            print(error)
            result(error)
        }
        
        
        
      
//            if (arguments["uniqueChatIdentifier"] != null) {
//                authId = "${arguments["authId"]}${arguments["uniqueChatIdentifier"]}"
//            } else {
//                authId = arguments["authId"].toString()
//            }
          
    }
    private func loadGuestConversation(result: @escaping FlutterResult) {
        guard let viewContoller = viewContoller else { return }
        do {
            try HPKit.sharedSDK.loadGuestConversation(launchController: viewContoller, customData: nil)
            result(true)
            //            flutterResult.success(response.status)
        } catch {
            print(error)
            result(error)
        }
        
    }

        private func handleNotification(arguments: StringDictionary) {
            let haptikNotification = (HPKit.sharedSDK.canHandleNotificationWith(UserInfo: arguments))


//                    if (haptikNotification == true && application.applicationState != .active) {
//                       let navController = window?.rootViewController as? UINavigationController
//                       let controller =  navController?.visibleViewController
//                       do {
//                           try HPKit.sharedSDK.loadGuestConversation(launchController: controller!, customData: nil)
//                       } catch {
//                           print(error)
//                       }
//                   }
        }

        private func setLaunchMessage(arguments: JsonDictionary) {
//            HaptikSDK.setLaunchMessage(
//                message = arguments["message"] as String,
//                hidden = arguments["hidden"] as Boolean
//            )
        }

        private func destroy() {
                HPKit.sharedSDK.clearConversation()
        }

        private func logout() {
                HPKit.sharedSDK.clearConversation()
       //         HPKit.sharedSDK.logout()
        }

//        override func onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
//            channel.setMethodCallHandler(null)
//        }
}
