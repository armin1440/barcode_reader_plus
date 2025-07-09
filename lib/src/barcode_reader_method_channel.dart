import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'barcode_reader_platform_interface.dart';

/// An implementation of [BarcodeReaderPlatform] that uses method channels.
class MethodChannelBarcodeReader extends BarcodeReaderPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('barcode_reader');

  @override
  void initBarcodeCallback({required Null Function(String) onScannedBarcode}) {
    methodChannel.setMethodCallHandler((call) async {
      if (call.method == 'onBarcodeScanned') {
        final String barcode = call.arguments;
        onScannedBarcode(barcode);
      }
    });
  }
}
