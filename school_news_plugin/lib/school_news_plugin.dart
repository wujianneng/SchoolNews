import 'dart:async';

import 'package:flutter/services.dart';

class SchoolNewsPlugin {
  static const MethodChannel _channel =
  const MethodChannel('school_news_plugin');

  static Future<bool> get onBackToHome async {
    final bool success = await _channel.invokeMethod('onBackToHome');
    print("onBackToHome:" + success.toString());
    return success;
  }

  static Future<bool> showToast(String msg) async {
    final bool success = await _channel.invokeMethod('showToast', {"msg": msg});
    print("showToast:" + success.toString());
    return success;
  }
}
