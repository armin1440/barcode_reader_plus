import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'barcode_reader.dart';

class BarcodeReaderView extends StatefulWidget {
  const BarcodeReaderView({super.key, required this.onScannedBarcode});

  final Null Function(String barcode) onScannedBarcode;

  @override
  State<BarcodeReaderView> createState() => _BarcodeReaderViewState();
}

class _BarcodeReaderViewState extends State<BarcodeReaderView> {
  final String viewType = 'barcode_reader_view';
  final BarcodeReader barcodeReader = BarcodeReader();

  @override
  void initState() {
    super.initState();
    barcodeReader.initBarcodeCallback(onScannedBarcode: widget.onScannedBarcode);
  }

  @override
  Widget build(BuildContext context) {
    return UiKitView(
      viewType: viewType,
      layoutDirection: TextDirection.ltr,
      creationParams: {},
      creationParamsCodec: const StandardMessageCodec(),
    );
  }
}
