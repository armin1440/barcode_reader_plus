
import 'barcode_reader_platform_interface.dart';

class BarcodeReader {
  Future<String?> getPlatformVersion() {
    return BarcodeReaderPlatform.instance.getPlatformVersion();
  }
}
