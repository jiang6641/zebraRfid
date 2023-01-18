import 'dart:async';

import 'package:flutter/services.dart';
import 'package:zebra_rfid/base.dart';

class ZebraRfid {
  static const MethodChannel _channel =
      const MethodChannel('com.hone.zebraRfid/plugin');
  static const EventChannel _eventChannel =
      const EventChannel('com.hone.zebraRfid/event_channel');
  static ZebraEngineEventHandler? _handler;

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String?> toast(String text) async {
    return _channel.invokeMethod('toast', {"text": text});
  }

  ///
  static Future<String?> onRead() async {
    return _channel.invokeMethod('startRead');
  }

  ///写
  static Future<String?> write() async {
    return _channel.invokeMethod('write');
  }

  ///连接设备
  static Future<dynamic> connect() async {
    try {
      await _addEventChannelHandler();
      var result = await _channel.invokeMethod('connect');
      return result;
    } catch (e) {
      var a = e;
    }
  }

  ///Disconnect the device
  static Future<String?> disconnect() async {
    return _channel.invokeMethod('disconnect');
  }

  /// Sets the engine event handler.
  ///
  /// After setting the engine event handler, you can listen for engine events and receive the statistics of the corresponding [RtcEngine] instance.
  ///
  /// **Parameter** [handler] The event handler.
  static void setEventHandler(ZebraEngineEventHandler handler) {
    _handler = handler;
  }

  static StreamSubscription<dynamic>? _sink;
  static Future<void> _addEventChannelHandler() async {
    if (_sink == null) {
      _sink = _eventChannel.receiveBroadcastStream().listen((event) {
        final eventMap = Map<String, dynamic>.from(event);
        final eventName = eventMap['eventName'] as String?;
        // final data = List<dynamic>.from(eventMap['data']);
        _handler?.process(eventName, eventMap);
      });
    }
  }

  ///DisConnect device
  static Future<String?> dispose() async {
    _sink = null;
    return _channel.invokeMethod('dispose');
  }

  static Future<bool> get isConnected async {
    return await _channel.invokeMethod('isConnected');
  }

  /// set power
  /// [power] 0-270
  static Future<void> setPower(int power) async {
    // return error if power is not in range
    assert(power >= 0 && power <= 270);
    // if not connected show error
    assert(await isConnected);
    return _channel.invokeMethod('setPower', {"powerIndex": power});
  }

  static Future<int> getPower() async {
    final power = await _channel.invokeMethod('getPower');
    return power;
  }
}
