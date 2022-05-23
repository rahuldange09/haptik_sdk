/////2nd attempt


import Flutter
import UIKit
import HPWebKit
import SwiftyJSON

//Set 0 if adding the Production URL else keep it as 1 (Staging).
typealias JsonDictionary = [String: Any]
typealias StringDictionary = [String: String]

public class SwiftHaptikSdkPlugin: NSObject, FlutterPlugin {
        private static var methodChannel: FlutterMethodChannel?
    //    private var flutterResult: Result?
//    private var flutterRegistrar: FlutterPluginRegistrar?
//    private var viewController: FlutterViewController?
//    private var viewController = UIViewController()
//    init(registrar: FlutterPluginRegistrar, viewController: FlutterViewController?) {
//        self.flutterRegistrar = registrar
//        self.viewController = viewController
//    }
    
    public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
        SwiftHaptikSdkPlugin.methodChannel?.setMethodCallHandler(nil)
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "haptik_sdk", binaryMessenger: registrar.messenger())
//        let viewController: FlutterViewController = (UIApplication.shared.delegate?.window??.rootViewController) as! FlutterViewController
        let instance = SwiftHaptikSdkPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        methodChannel = channel
//        let methodChannel = FlutterMethodChannel(name: "navigation", binaryMessenger:controller.binaryMessenger)
        //      let METHOD_CHANNEL_NAME = "flutter.native/nativeModule"
        //           let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        //          controller.navigationController?.interactivePopGestureRecognizer?.isEnabled = false;
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
//        result("iOS " + UIDevice.current.systemVersion)

        switch call.method {
        case "init":
            initWithArguments(result: result)
        case "loadSignupConversation":
            print("Haptic data")
            print(call.arguments ?? "No Data")
            guard let arguments = call.arguments else { return }
            let jsonData = JSON(arguments)
            loadSignupConversation(jsonData: jsonData, result: result)
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
            result(false)
            //          result("notImplemented()")
        }
    }
    
    private func initWithArguments(result: @escaping FlutterResult) {
        HPKit.sharedSDK.setup()
        result(true)
    }
    
    private func loadSignupConversation(jsonData: JSON, result: @escaping FlutterResult) {
        
//        let viewController: FlutterViewController = (UIApplication.shared.delegate?.window??.rootViewController) as! FlutterViewController
//
        let vc = WkWebviewController()
               vc.url = ""
           let viewController = UIApplication.shared.keyWindow?.rootViewController
           let nav = UINavigationController(rootViewController: vc)
           nav.modalPresentationStyle = .fullScreen
           viewController?.present(nav, animated: true)
//        var navigationController: UINavigationController?
//        self.viewController.view.frame = viewController.view.frame
//        self.viewController.view.addSubview(viewController.view)
//        navigationController = UINavigationController(rootViewController: viewController)
////        if  let navController = viewController.navigationController {
////            navigationController = navController
////        }
//        if  let navigationController = navigationController {
            let authAttribute = HPWebKit.HPAttributesBuilder.build { builder in
                builder.authCode = jsonData["authCode"].stringValue
                builder.authID = jsonData["authId"].stringValue
                builder.userName = jsonData["userName"].stringValue
                builder.email = jsonData["email"].stringValue
                builder.mobile = jsonData["mobileNo"].stringValue
                builder.signupType = jsonData["signupType"].stringValue
            }
            var customData = StringDictionary()
            if let data = jsonData["customData"].dictionaryObject as? StringDictionary {
                customData = data
            }
            
            do {
                try HPKit.sharedSDK.loadConversation(launchController: nav, attributes: authAttribute, customData: customData)
                result(true)
                //            flutterResult.success(response.status)
            } catch {
                print(error)
                result(false)
            }
            
            
            
//        }
//        else {
//            result(false)
//        }
        
        
        
        //            if (arguments["uniqueChatIdentifier"] != null) {
        //                authId = "${arguments["authId"]}${arguments["uniqueChatIdentifier"]}"
        //            } else {
        //                authId = arguments["authId"].toString()
        //            }
        
    }
    private func loadGuestConversation(result: @escaping FlutterResult) {
//        guard let viewController = viewController else { return }
//        do {
//            try HPKit.sharedSDK.loadGuestConversation(launchController: viewController, customData: nil)
//            result(true)
//            //            flutterResult.success(response.status)
//        } catch {
//            print(error)
//            result(false)
//        }
        
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
        //                HPKit.sharedSDK.clearConversation()
    }
    
    private func logout() {
        //                HPKit.sharedSDK.clearConversation()
        //         HPKit.sharedSDK.logout()
    }
    
    //        override func onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    //            channel.setMethodCallHandler(null)
    //        }
}
