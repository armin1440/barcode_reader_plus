import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter/services.dart';
import 'barcode_reader_controller.dart';
import 'barcode_reader_platform_interface.dart';

class BarcodeReaderView extends StatefulWidget {
  const BarcodeReaderView({super.key, required this.onScannedBarcode, required this.controller});

  final Null Function(String barcode) onScannedBarcode;
  final BarcodeReaderController controller;

  @override
  State<BarcodeReaderView> createState() => _BarcodeReaderViewState();
}

class _BarcodeReaderViewState extends State<BarcodeReaderView> {
  final String viewType = 'barcode_reader_view';

  @override
  void initState() {
    super.initState();
    BarcodeReaderPlatform.instance.initBarcodeCallback(
      onScannedBarcode: (barcode) {
        widget.onScannedBarcode(barcode);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final platformView =
        Platform.isAndroid
            ? PlatformViewLink(
              viewType: viewType,
              surfaceFactory: (context, controller) {
                return AndroidViewSurface(
                  controller: controller as AndroidViewController,
                  gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
                  hitTestBehavior: PlatformViewHitTestBehavior.opaque,
                );
              },
              onCreatePlatformView: (params) {
                return PlatformViewsService.initExpensiveAndroidView(
                    id: params.id,
                    viewType: viewType,
                    layoutDirection: TextDirection.ltr,
                    creationParams: {},
                    creationParamsCodec: const StandardMessageCodec(),
                  )
                  ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
                  ..create();
              },
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
