package com.abomis.barcode_reader

import android.content.Context
import android.view.View
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import io.flutter.plugin.common.StandardMessageCodec

class BarcodeCameraViewFactory(
    private val messenger: BinaryMessenger,
    private val methodChannel: MethodChannel
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    private var cameraView: BarcodeCameraView? = null

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        cameraView = BarcodeCameraView(context) { barcode ->
            methodChannel.invokeMethod("onBarcodeScanned", barcode)
        }

        return object : PlatformView {
            override fun getView(): View = cameraView!!
            override fun dispose() {}
        }
    }

    fun toggleFlash(enabled: Boolean) {
        cameraView?.toggleFlash(enabled)
    }
}

