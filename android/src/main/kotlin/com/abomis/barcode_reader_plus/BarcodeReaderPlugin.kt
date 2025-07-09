package com.abomis.barcode_reader_plus

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

class BarcodeReaderPlugin : FlutterPlugin, MethodCallHandler {

  private lateinit var channel: MethodChannel
  private var viewFactory: BarcodeCameraViewFactory? = null

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(binding.binaryMessenger, "barcode_reader")
    channel.setMethodCallHandler(this)

    val factory = BarcodeCameraViewFactory(binding.binaryMessenger, channel)
    viewFactory = factory
    binding.platformViewRegistry.registerViewFactory("barcode_reader_view", factory)
  }

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    when (call.method) {
      "toggleFlash" -> {
        val enabled = call.arguments as? Boolean ?: false
        viewFactory?.toggleFlash(enabled)
        result.success(null)
      }
      "takePicture" -> {
        viewFactory?.takePicture { path ->
          if (path != null) {
            result.success(path)
          } else {
            result.error("capture_failed", "Photo capture failed", null)
          }
        }
      }
      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}


