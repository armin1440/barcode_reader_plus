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
      print('Error taking picture: $e');
      return null;
    }
  }

}