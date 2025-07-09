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
    this.initialFlashEnabled = false,
  });

  final Null Function(String barcode) onScannedBarcode;
  final BarcodeReaderController controller;
  final bool initialFlashEnabled;

  @override
  State<BarcodeReaderView> createState() => _BarcodeReaderViewState();
}

class _BarcodeReaderViewState extends State<BarcodeReaderView> {
  final String viewType = 'barcode_reader_view';
  final BarcodeReader barcodeReader = BarcodeReader();
  bool paused = false;
  Set<String> barcodes = {};

  @override
  void initState() {
    super.initState();
    barcodeReader.initBarcodeCallback(onScannedBarcode: (barcode) {
      widget.onScannedBarcode(barcode);
      if(barcode.length == 10) {
        barcodes.add(barcode);
      }
      print('------------------------------------');
      barcodes.forEach((barcode) => print(barcode));
      print('------------------------------------');
    });

    // set initial flash state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // widget.controller.changeFlashMode(widget.initialFlashEnabled);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (paused) return const SizedBox();

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
