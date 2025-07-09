import 'package:flutter/services.dart';

class BarcodeReaderController {
  static const MethodChannel _channel = MethodChannel('barcode_reader');

  // Future<void> changeFlashMode(bool enabled) async {
  //   try {
  //     await _channel.invokeMethod('toggleFlash', enabled);
  //   } on PlatformException catch (e) {
  //     print('Failed to toggle flash: ${e.message}');
  //   }
  // }
}