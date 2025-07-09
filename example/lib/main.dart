import 'dart:developer';

import 'package:barcode_reader/barcode_reader_controller.dart';
import 'package:flutter/material.dart';
import 'package:barcode_reader/barcode_reader_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final controller = BarcodeReaderController();
  bool flashState = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: Column(
          children: [
            Expanded(
              child: BarcodeReaderView(
                controller: controller,
                onScannedBarcode: (barcode) {
                  log('Barcode in flutter $barcode');
                },
              ),
            ),
            Switch(
              onChanged: (newState) {
                controller.toggleFlash(newState);
                setState(() {
                  flashState = newState;
                });
              },
              value: flashState,
            ),
          ],
        ),
      ),
    );
  }
}
