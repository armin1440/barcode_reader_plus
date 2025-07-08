import 'dart:developer';

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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: BarcodeReaderView(
            onScannedBarcode: (barcode){
              log('Barcode in flutter $barcode');
            }
          ),
        ),
      ),
    );
  }
}
