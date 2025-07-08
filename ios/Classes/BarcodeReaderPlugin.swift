import Flutter
import UIKit

public class BarcodeReaderPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "barcode_reader", binaryMessenger: registrar.messenger())

    let instance = BarcodeReaderPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)

    let factory = BarcodeReaderViewFactory(messenger: registrar.messenger())
    registrar.register(factory, withId: "barcode_reader_view")
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}