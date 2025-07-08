import UIKit
import AVFoundation
import MLKitVision
import MLKitBarcodeScanning


class CameraView: UIView, AVCaptureVideoDataOutputSampleBufferDelegate {
    private let captureSession = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private let barcodeScanner = BarcodeScanner.barcodeScanner()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeCamera()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializeCamera()
    }

    private func initializeCamera() {
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device) else {
            return
        }

        captureSession.beginConfiguration()
        if captureSession.canAddInput(input) {
            captureSession.addInput(input)
        }

        // Set up preview layer
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = .resizeAspectFill
        previewLayer?.frame = bounds
        if let previewLayer = previewLayer {
            layer.addSublayer(previewLayer)
        }

        // Setup output
        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "barcodeQueue"))
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }

        captureSession.commitConfiguration()
        captureSession.startRunning()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer?.frame = bounds
    }

    // MARK: Barcode Detection

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        let visionImage = VisionImage(buffer: sampleBuffer)
        visionImage.orientation = .right

        barcodeScanner.process(visionImage) { barcodes, error in
            guard error == nil, let barcodes = barcodes else { return }
            for barcode in barcodes {
                if let rawValue = barcode.rawValue {
                    print("Scanned barcode: \(rawValue)")
                    // TODO: Notify Flutter here
                }
            }
        }
    }
}

