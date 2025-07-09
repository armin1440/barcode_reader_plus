import Flutter
import UIKit
import AVFoundation

class BarcodeReaderViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        let methodChannel = FlutterMethodChannel(
                name: "barcode_reader",
                binaryMessenger: messenger
            )
        return BarcodeReaderView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger,
            methodChannel: methodChannel)
    }
}

class BarcodeReaderView: NSObject, FlutterPlatformView {
    private var _view: UIView
    private let cameraView: CameraView

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?,
        methodChannel: FlutterMethodChannel
    ) {
        cameraView = CameraView(frame: frame, methodChannel: methodChannel)
        BarcodeReaderPlugin.setCameraView(cameraView)
        _view = UIView()
        super.init()
    }

    func view() -> UIView {
        return cameraView
    }
}