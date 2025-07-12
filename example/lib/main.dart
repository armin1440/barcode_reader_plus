import 'dart:developer';

import 'package:barcode_reader_plus/barcode_reader_plus.dart';
import 'package:flutter/material.dart';

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
  bool isPaused = false;
  String path = 'take pic';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/':
            (BuildContext context) => Scaffold(
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
                  Row(
                    children: [
                      Text('Flash'),
                      Switch(
                        onChanged: (newState) {
                          controller.toggleFlash(newState);
                          setState(() {
                            flashState = newState;
                          });
                        },
                        value: flashState,
                      ),
                      Flexible(
                        child: TextButton(
                          child: Text(path),
                          onPressed: () {
                            controller.takePicture().then((value) {
                              setState(() {
                                path = value ?? 'none';
                              });
                            });
                          },
                        ),
                      ),
                      Switch(
                        value: isPaused,
                        onChanged: (newValue) {
                          if (isPaused) {
                            controller.resumeCamera();
                          } else {
                            controller.pauseCamera();
                          }
                          setState(() {
                            isPaused = newValue;
                          });
                        },
                      ),
                      TextButton(onPressed: () => Navigator.pushNamed(context, '/b'), child: Text('To Page2')),
                    ],
                  ),
                ],
              ),
            ),
        '/b':
            (BuildContext context) => Scaffold(
              body: Center(child: TextButton(onPressed: () => Navigator.pop(context), child: Text('Pop me'))),
            ),
      },
    );
  }
}
