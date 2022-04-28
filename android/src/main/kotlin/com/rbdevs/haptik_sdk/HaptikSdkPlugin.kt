package com.rbdevs.haptik_sdk

import ai.haptik.android.wrapper.sdk.HaptikSDK
import ai.haptik.android.wrapper.sdk.model.InitData
import ai.haptik.android.wrapper.sdk.model.SignupData
import android.content.Context
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.json.JSONObject

/** HaptikSdkPlugin */
class HaptikSdkPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var flutterResult: Result
    private lateinit var context: Context

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "haptik_sdk")
        context = flutterPluginBinding.applicationContext
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        flutterResult = result;
        when (call.method) {
            "init" -> init(call.arguments as Map<String, Any?>?)
            "loadSignupConversation" -> loadSignupConversation(call.arguments as Map<String, Any?>)
            "loadGuestConversation" -> loadGuestConversation()
            "setNotificationToken" -> HaptikSDK.setNotificationToken(
                context,
                call.arguments as String
            )
            "isHaptikNotification" -> flutterResult.success(HaptikSDK.isHaptikNotification(call.arguments as Map<String, String>))
            "handleNotification" -> handleNotification(call.arguments as Map<String, String>)
            "setLaunchMessage"->setLaunchMessage(call.arguments as Map<String, Any?>)
            "destroy"-> destroy()
            "logout"-> logout()

            else ->
                result.notImplemented()
        }
    }

    private fun init(arguments: Map<String, Any?>?) {
        HaptikSDK.init(applicationContext = context, initData = InitData().apply {
            if(arguments!=null) {
            /*    noHeader = arguments["noHeader"] as Boolean*/
                uniqueChatIdentifier =  arguments["uniqueChatIdentifier"].toString()
            }

        },);
    }

    private fun loadSignupConversation(arguments: Map<String, Any?>) {
        val signupData = SignupData().apply {
            authCode = arguments["authCode"].toString()
            if(  arguments["uniqueChatIdentifier"] !=null) {
                authId = "${arguments["authId"]}${arguments["uniqueChatIdentifier"]}"
            }else{
                authId = arguments["authId"].toString()
            }
            userName = arguments["userName"].toString()
            email = arguments["email"].toString()
            mobileNo = arguments["mobileNo"].toString()
            signupType = arguments["signupType"].toString()
            customData = JSONObject().apply {
                (arguments["customData"] as Map<String, Any?>?)?.forEach { (key: String, value) ->
                    put(key, value)
                }
            }
        }
        HaptikSDK.loadConversation(signupData, callback = {
            response -> flutterResult.success(response.status)
        })

    }

    private  fun loadGuestConversation(){
        HaptikSDK.loadGuestConversation(callback = {response -> flutterResult.success(response.status) })
    }

    private fun handleNotification(arguments: Map<String, String>) {
        HaptikSDK.handleNotification(
            context,
            arguments,
            context.resources.getIdentifier(
                arguments["small_icon"],
                "drawable",
                context.packageName
            )
        )
    }
    private  fun setLaunchMessage(arguments: Map<String, Any?>){
            HaptikSDK.setLaunchMessage(message = arguments["message"] as String, hidden =  arguments["hidden"] as Boolean)
    }

    private  fun destroy(){
        HaptikSDK.destroy();
    }
    private  fun logout(){
        HaptikSDK.logout(context);
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
