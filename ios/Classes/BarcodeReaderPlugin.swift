import Flutter
import UIKit

public class BarcodeReaderPlugin: NSObject, FlutterPlugin {
  private static var cameraViewInstance: CameraView?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "barcode_reader", binaryMessenger: registrar.messenger())

    let instance = BarcodeReaderPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)

    let factory = BarcodeReaderViewFactory(messenger: registrar.messenger())
    registrar.register(factory, withId: "barcode_reader_view")
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      switch call.method {

      case "toggleFlash":
          if let enabled = call.arguments as? Bool {
              if let cameraView = BarcodeReaderPlugin.cameraViewInstance {
                  cameraView.toggleFlash(enabled)
                  result(nil)
              } else {
                  result(FlutterError(code: "no_camera_view",
                                      message: "Camera view is not initialized.",
                                      details: nil))
              }
          } else {
              result(FlutterError(code: "invalid_argument",
                                  message: "Expected a boolean value for 'enabled'.",
                                  details: nil))
          }

      case "takePicture":
          if let view = BarcodeReaderPlugin.cameraViewInstance {
              view.takePicture { path in
                  if let path = path {
                      result(path)
                  } else {
                      result(FlutterError(code: "capture_failed", message: "Photo capture failed", details: nil))
                  }
              }
          } else {
              result(FlutterError(code: "no_camera_view", message: "Camera view is not initialized", details: nil))
          }

      case "pauseCamera":
          BarcodeReaderPlugin.cameraViewInstance?.pauseCamera()
          result(nil)

      case "resumeCamera":
          BarcodeReaderPlugin.cameraViewInstance?.resumeCamera()
          result(nil)

      default:
          result(FlutterMethodNotImplemented)
      }
  }

  static func setCameraView(_ view: CameraView) {
      cameraViewInstance = view
  }
}