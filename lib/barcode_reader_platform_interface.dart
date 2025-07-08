import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'barcode_reader_method_channel.dart';

abstract class BarcodeReaderPlatform extends PlatformInterface {
  /// Constructs a BarcodeReaderPlatform.
  BarcodeReaderPlatform() : super(token: _token);

  static final Object _token = Object();

  static BarcodeReaderPlatform _instance = MethodChannelBarcodeReader();

  /// The default instance of [BarcodeReaderPlatform] to use.
  ///
  /// Defaults to [MethodChannelBarcodeReader].
  static BarcodeReaderPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BarcodeReaderPlatform] when
  /// they register themselves.
  static set instance(BarcodeReaderPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  void initBarcodeCallback({required Null Function(String) onScannedBarcode});
}
