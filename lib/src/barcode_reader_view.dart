import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter/services.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'barcode_reader_controller.dart';
import 'barcode_reader_platform_interface.dart';

class BarcodeReaderView extends StatefulWidget {
  const BarcodeReaderView({super.key, required this.onScannedBarcode, required this.controller});

  final Null Function(String barcode) onScannedBarcode;
  final BarcodeReaderController controller;

  @override
  State<BarcodeReaderView> createState() => _BarcodeReaderViewState();
}

class _BarcodeReaderViewState extends State<BarcodeReaderView> with WidgetsBindingObserver {
  final String viewType = 'barcode_reader_view';
  bool paused = false;
  bool isVisible = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    BarcodeReaderPlatform.instance.initBarcodeCallback(
      onScannedBarcode: (barcode) {
        widget.onScannedBarcode(barcode);
      },
    );
  }

  @override
  void dispose() {
    log('Disposed');
    WidgetsBinding.instance.removeObserver(this);
    widget.controller.pauseCamera();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        log('didChangeAppLifecycleState resume');
        if(isVisible) {
          widget.controller.resumeCamera();
        }
        break;
      case AppLifecycleState.inactive:
        if (Platform.isIOS) {
          log('didChangeAppLifecycleState pause');
          widget.controller.pauseCamera();
        }
        break;
      case AppLifecycleState.paused:
        log('didChangeAppLifecycleState pause');
        widget.controller.pauseCamera();
        break;
      default:
        break;
    }
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

    return VisibilityDetector(
      key: const Key('barcode_reader_visibility'),
      onVisibilityChanged: _onVisibilityChanged,
      child: platformView,
    );
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    isVisible = !(info.visibleFraction == 0);
    if (isVisible) {
      log('_onVisibilityChanged pause false');
      widget.controller.resumeCamera();
    } else {
      log('_onVisibilityChanged pause true');
      widget.controller.pauseCamera();
    }
    if (mounted) {
      setState(() {});
    }
  }
}
