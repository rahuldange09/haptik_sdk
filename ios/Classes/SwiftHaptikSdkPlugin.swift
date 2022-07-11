/////2nd attempt


import Flutter
import UIKit
import HPWebKit

public class SwiftHaptikSdkPlugin: NSObject, FlutterPlugin {
    private static var methodChannel: FlutterMethodChannel?
    
    public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
        SwiftHaptikSdkPlugin.methodChannel?.setMethodCallHandler(nil)
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "haptik_sdk", binaryMessenger: registrar.messenger())
        let instance = SwiftHaptikSdkPlugin()
        
        registrar.addMethodCallDelegate(instance, channel: channel)
        methodChannel = channel
        
        
        if #available(iOS 15.0, *) {
            let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            ShareHelper.shared.flutterVC = UINavigationController(
                rootViewController: scene!.windows.first!.rootViewController!)
        } else {
            let flutterController =
            
            UIApplication.shared.windows.first?.rootViewController as? FlutterViewController
            ShareHelper.shared.flutterVC = UINavigationController(rootViewController: flutterController!)
        }
        
        let flutterNav = ShareHelper.shared.flutterVC
        if flutterNav != nil {
            DispatchQueue.main.async {
                flutterNav!.setNavigationBarHidden(true, animated: true)
                UIApplication.shared.keyWindow!.rootViewController = flutterNav!
                UIApplication.shared.keyWindow!.makeKeyAndVisible()
            }
        }
        
        
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "init":
            initWithArguments(payload: call.arguments as! [String: Any], result: result)
        case "loadSignupConversation":
            guard let arguments = call.arguments else { return }
            // let jsonData = JSON(arguments)
            loadSignupConversation(payload: arguments as! [String: Any], result: result)
        case "loadGuestConversation": loadGuestConversation(result: result)
        case "setNotificationToken":
            guard let deviceToken = call.arguments as? String else { return }
            HPKit.sharedSDK.setDeviceToken(deviceToken: Data(deviceToken.utf8))
        case "isHaptikNotification":
            guard let userInfo = call.arguments as? [String: Any] else { return }
            let haptikNotification = (HPKit.sharedSDK.canHandleNotificationWith(UserInfo: userInfo))
            result(haptikNotification)
        case "handleNotification":
            guard let json = call.arguments as? [String: Any] else { return }
            handleNotification(arguments: json)
        case "setLaunchMessage":
            guard let json = call.arguments as? [String: Any] else { return }
            setLaunchMessage(arguments: json)
        case "destroy": destroy()
        case "logout": logout()
        default:
            result(false)
            //          result("notImplemented()")
        }
    }
    
    private func initWithArguments(payload: [String: Any], result: @escaping FlutterResult) {
        HPKit.sharedSDK.setup()
        if let uniqueChatIdentifier = payload["uniqueChatIdentifier"] as? String {
            let customBuilder = HPCustomBuilder()
            customBuilder.uniqueChatIdentifier = uniqueChatIdentifier
            HPKit.sharedSDK.setCustomSettings(settings: customBuilder)
        }
        result(true)
    }
    
    private func loadSignupConversation(payload: [String: Any], result: @escaping FlutterResult) {
        do {
            let authAttribute = HPWebKit.HPAttributesBuilder.build { builder in
                builder.authCode = payload["authCode"] as! String?
                builder.authID = payload["authId"] as! String?
                builder.userName = payload["userName"] as! String?
                builder.email = payload["email"] as! String?
                builder.mobile = payload["mobileNo"] as! String?
                builder.signupType = payload["signupType"]  as! String
            }
            var customData: [String: String]? = nil
            if let data = payload["customData"] as? [String: String] {
                customData = data
            }
            
            try HPKit.sharedSDK.loadConversation(launchController: ShareHelper.shared.flutterVC!.topViewController!, attributes: authAttribute, customData:
                                                    customData)
            result(true)
        } catch {
            //            print(error)
            result(false)
        }
        
    }
    
    private func loadGuestConversation(result: @escaping FlutterResult) {
        
        do {
            try HPKit.sharedSDK.loadGuestConversation(
                launchController: ShareHelper.shared.flutterVC!.topViewController!, customData: nil)
            result(true)
        } catch {
            //                    print(error)
            result(false)
        }
        
    }
    
    private func handleNotification(arguments:  [String: Any]) {
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
    
    private func setLaunchMessage(arguments:  [String: Any]) {
        HPKit.sharedSDK.setLaunchMessage(
            message : arguments["message"] as! String,
            hidden : arguments["hidden"] as! Bool
        )
    }
    
    private func destroy() {
        
    }
    
    private func logout() {
        HPKit.sharedSDK.logout()
    }
    
    //        override func onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    //            channel.setMethodCallHandler(null)
    //        }
}

class ShareHelper: NSObject {
    static var shared: ShareHelper = ShareHelper()
    var flutterVC: UINavigationController?
    
}
