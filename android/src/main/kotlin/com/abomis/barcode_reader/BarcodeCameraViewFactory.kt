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

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val cameraView = BarcodeCameraView(context) { barcode ->
            methodChannel.invokeMethod("onBarcodeScanned", barcode)
        }

        return object : PlatformView {
            override fun getView(): View = cameraView
            override fun dispose() {}
        }
    }
}
