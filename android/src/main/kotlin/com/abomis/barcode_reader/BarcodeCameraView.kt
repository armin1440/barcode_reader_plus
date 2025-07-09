package com.abomis.barcode_reader

import android.content.Context
import android.widget.FrameLayout
import androidx.camera.core.*
import androidx.camera.lifecycle.ProcessCameraProvider
import androidx.camera.view.PreviewView
import androidx.core.content.ContextCompat
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.LifecycleRegistry
import com.google.mlkit.vision.barcode.BarcodeScanning
import com.google.mlkit.vision.common.InputImage

class BarcodeCameraView(
    context: Context,
    private val onBarcodeScanned: (String) -> Unit
) : FrameLayout(context), LifecycleOwner {

    private val lifecycleRegistry = LifecycleRegistry(this)
    override val lifecycle: Lifecycle
        get() = lifecycleRegistry

    private val previewView = PreviewView(context)

    init {
        addView(previewView)
        lifecycleRegistry.currentState = Lifecycle.State.CREATED
        startCamera()
    }

    private fun startCamera() {
        val cameraProviderFuture = ProcessCameraProvider.getInstance(context)
        cameraProviderFuture.addListener({
            val provider = cameraProviderFuture.get()
            bindCamera(provider)
        }, ContextCompat.getMainExecutor(context))
    }

    private fun bindCamera(provider: ProcessCameraProvider) {
        val preview = Preview.Builder().build().also {
            it.setSurfaceProvider(previewView.surfaceProvider)
        }

        val analyzer = ImageAnalysis.Builder()
            .setBackpressureStrategy(ImageAnalysis.STRATEGY_KEEP_ONLY_LATEST)
            .build()

        analyzer.setAnalyzer(ContextCompat.getMainExecutor(context)) { imageProxy ->
            processImage(imageProxy)
        }

        val selector = CameraSelector.DEFAULT_BACK_CAMERA
        provider.unbindAll()
        provider.bindToLifecycle(this, selector, preview, analyzer)
        lifecycleRegistry.currentState = Lifecycle.State.RESUMED
    }

    private val scanTimestamps = mutableMapOf<String, MutableList<Long>>()

    private fun processImage(imageProxy: ImageProxy) {
        val mediaImage = imageProxy.image ?: return imageProxy.close()
        val image = InputImage.fromMediaImage(mediaImage, imageProxy.imageInfo.rotationDegrees)

        BarcodeScanning.getClient().process(image)
            .addOnSuccessListener { barcodes ->
                val now = System.currentTimeMillis()
                for (barcode in barcodes) {
                    val value = barcode.rawValue ?: continue
                    val times = scanTimestamps.getOrPut(value) { mutableListOf() }
                    times.add(now)
                    times.retainAll { now - it <= 200 }

                    if (times.size >= 3) {
                        scanTimestamps.remove(value)
                        onBarcodeScanned(value)
                    }
                }
            }
            .addOnCompleteListener {
                imageProxy.close()
            }
    }
}
