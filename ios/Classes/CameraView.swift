import UIKit
import AVFoundation
import MLKitVision
import MLKitBarcodeScanning
import Flutter

class CameraView: UIView, AVCaptureVideoDataOutputSampleBufferDelegate {
    private let captureSession = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private let barcodeScanner = BarcodeScanner.barcodeScanner()
    private var isProcessing = false
    private var methodChannel: FlutterMethodChannel?
    private var scanTimestamps: [String: [TimeInterval]] = [:]
    private let scanThresholdCount = 2
    private let scanWindowMs: Double = 200


    init(frame: CGRect, methodChannel: FlutterMethodChannel) {
        self.methodChannel = methodChannel
        super.init(frame: frame)
        initializeCamera()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializeCamera()
    }

    private func initializeCamera() {
        // Configure camera device
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device),
              captureSession.canAddInput(input) else {
            print("Failed to initialize camera input")
            return
        }

        captureSession.beginConfiguration()
        captureSession.sessionPreset = .high
        captureSession.addInput(input)

        // Configure video output
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.videoSettings = [
            (kCVPixelBufferPixelFormatTypeKey as String): Int(kCVPixelFormatType_32BGRA)
        ]
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera.frame.processing"))

        guard captureSession.canAddOutput(videoOutput) else {
            print("Cannot add video output")
            captureSession.commitConfiguration()
            return
        }

        captureSession.addOutput(videoOutput)

        // Configure preview layer
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = .resizeAspectFill
        previewLayer?.frame = bounds
        if let layer = previewLayer {
            self.layer.addSublayer(layer)
        }

        captureSession.commitConfiguration()
        captureSession.startRunning()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer?.frame = bounds
    }

    // MARK: - Frame Processing

    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {

        guard !isProcessing else { return }
        isProcessing = true

        let visionImage = VisionImage(buffer: sampleBuffer)
        visionImage.orientation = .right

        barcodeScanner.process(visionImage) { [weak self] barcodes, error in
            defer { self?.isProcessing = false }

            guard error == nil, let barcodes = barcodes else { return }

            for barcode in barcodes {
                if let value = barcode.rawValue {
                    if self?.shouldEmitBarcode(value) == true {
                        self?.sendBarcodeToFlutter(value)
                    }
                }
            }

        }
    }

    // MARK: - Flutter Communication

    private func sendBarcodeToFlutter(_ barcode: String) {
        DispatchQueue.main.async {
            self.methodChannel?.invokeMethod("onBarcodeScanned", arguments: barcode)
        }
    }

    private func shouldEmitBarcode(_ value: String) -> Bool {
        let now = Date().timeIntervalSince1970 * 1000 // ms
        let window = scanWindowMs

        var timestamps = scanTimestamps[value] ?? []
        timestamps.append(now)

        // Keep only those within window
        timestamps = timestamps.filter { now - $0 <= window }

        // Update the stored timestamps
        scanTimestamps[value] = timestamps

        return timestamps.count >= scanThresholdCount
    }
}
