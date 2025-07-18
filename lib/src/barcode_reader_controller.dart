import 'dart:developer';

import 'package:flutter/services.dart';

class BarcodeReaderController {
  static const MethodChannel _channel = MethodChannel('barcode_reader');

  Future<void> toggleFlash(bool enabled) async {
    try {
      await _channel.invokeMethod('toggleFlash', enabled);
    } on PlatformException catch (e) {
      log('Failed to toggle flash: ${e.message}');
    }
  }

  Future<String?> takePicture() async {
    try {
      final path = await _channel.invokeMethod<String>('takePicture');
      return path;
    } catch (e) {
      log('Error taking picture: $e');
      return null;
    }
  }

  Future<void> pauseCamera() async {
    await _channel.invokeMethod('pauseCamera');
  }

  Future<void> resumeCamera() async {
    await _channel.invokeMethod('resumeCamera');
  }

}