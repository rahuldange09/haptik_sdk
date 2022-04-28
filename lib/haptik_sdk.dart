import 'dart:async';

import 'package:flutter/services.dart';
import 'package:haptik_sdk/models/init_data.dart';
import 'package:haptik_sdk/models/signup_data.dart';

class HaptikSdk {
  static const MethodChannel _channel = MethodChannel('haptik_sdk');

  Future init({InitData? initData}) {
    return _channel.invokeMethod('init', initData?.toJson());
  }

  Future<bool> loadSignupConversation(SignupData signupData) async {
    return (await _channel.invokeMethod(
        'loadSignupConversation', signupData.toJson())) as bool;
  }

  Future<bool> loadGuestConversation() async {
    return (await _channel.invokeMethod('loadGuestConversation')) as bool;
  }

  Future setNotificationToken(String deviceToken) {
    return _channel.invokeMethod('setNotificationToken', deviceToken);
  }

  Future<bool> isHaptikNotification(Map<String, String> payload) async {
    final result = await _channel.invokeMethod('isHaptikNotification', payload);
    return result;
  }

  // smallIcon is drawable name of icon without extension
  Future handleNotification(Map<String, String> payload,
      {String smallIcon = "ic_launcher"}) {
    return _channel.invokeMethod('handleNotification',
        payload..putIfAbsent("small_icon", () => smallIcon));
  }

  Future setLaunchMessage(String message, {bool hidden = false}) async {
    _channel.invokeMethod(
      'setLaunchMessage',
      {"message": message, "hidden": hidden},
    );
  }

  Future destroy() {
    return _channel.invokeMethod('destroy');
  }

  Future logout() {
    return _channel.invokeMethod('logout');
  }
}
