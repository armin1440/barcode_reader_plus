
import 'barcode_reader_platform_interface.dart';

class BarcodeReader {
  void initBarcodeCallback({required Null Function(String) onScannedBarcode}){
    return BarcodeReaderPlatform.instance.initBarcodeCallback(onScannedBarcode: onScannedBarcode);
  }
}
