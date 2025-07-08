import 'package:flutter_test/flutter_test.dart';
import 'package:barcode_reader/barcode_reader.dart';
import 'package:barcode_reader/barcode_reader_platform_interface.dart';
import 'package:barcode_reader/barcode_reader_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockBarcodeReaderPlatform
    with MockPlatformInterfaceMixin
    implements BarcodeReaderPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final BarcodeReaderPlatform initialPlatform = BarcodeReaderPlatform.instance;

  test('$MethodChannelBarcodeReader is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelBarcodeReader>());
  });

  test('getPlatformVersion', () async {
    BarcodeReader barcodeReaderPlugin = BarcodeReader();
    MockBarcodeReaderPlatform fakePlatform = MockBarcodeReaderPlatform();
    BarcodeReaderPlatform.instance = fakePlatform;

    expect(await barcodeReaderPlugin.getPlatformVersion(), '42');
  });
}
