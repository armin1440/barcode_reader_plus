import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'barcode_reader.dart';
import 'barcode_reader_controller.dart';

class BarcodeReaderView extends StatefulWidget {
  const BarcodeReaderView({
    super.key,
    required this.onScannedBarcode,
    required this.controller,
  });

  final Null Function(String barcode) onScannedBarcode;
  final BarcodeReaderController controller;

  @override
  State<BarcodeReaderView> createState() => _BarcodeReaderViewState();
}

class _BarcodeReaderViewState extends State<BarcodeReaderView> {
  final String viewType = 'barcode_reader_view';
  final BarcodeReader barcodeReader = BarcodeReader();

  @override
  void initState() {
    super.initState();
    barcodeReader.initBarcodeCallback(onScannedBarcode: (barcode) {
      widget.onScannedBarcode(barcode);
    });
  }

  @override
  Widget build(BuildContext context) {
    final platformView =
        Platform.isAndroid
            ? AndroidView(
              viewType: viewType,
              layoutDirection: TextDirection.ltr,
              creationParams: {},
              creationParamsCodec: const StandardMessageCodec(),
            )
            : UiKitView(
              viewType: viewType,
              layoutDirection: TextDirection.ltr,
              creationParams: {},
              creationParamsCodec: const StandardMessageCodec(),
            );

    return platformView;
  }
}
