import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BarcodeReaderView extends StatefulWidget {
  const BarcodeReaderView({super.key});

  @override
  State<BarcodeReaderView> createState() => _BarcodeReaderViewState();
}

class _BarcodeReaderViewState extends State<BarcodeReaderView> {
  // This is used in the platform side to register the view.
  final String viewType = 'barcode_reader_view';


  @override
  Widget build(BuildContext context) {
    // Pass parameters to the platform side.
    final Map<String, dynamic> creationParams = <String, dynamic>{};

    return UiKitView(
      viewType: viewType,
      layoutDirection: TextDirection.ltr,
      creationParams: creationParams,
      creationParamsCodec: const StandardMessageCodec(),
      // onPlatformViewCreated: ,
    );
  }
}
