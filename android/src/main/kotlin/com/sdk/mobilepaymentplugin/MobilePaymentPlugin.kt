package com.sdk.mobilepaymentplugin

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MobilePaymentPlugin : FlutterPlugin, ActivityAware, MethodChannel.MethodCallHandler {

    private lateinit var channel: MethodChannel

    private lateinit var pluginSdkMethods: MobilePaymentPluginSdkMethods

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "paymentMethod" -> {
                pluginSdkMethods.paymentMethod(call.arguments as Map<String, Any>)
                result.success(null)
            }

            "refund" -> {
                pluginSdkMethods.refund(call.arguments as Map<String, Any>)
                result.success(null)
            }

            "completion" -> {
                pluginSdkMethods.completion(call.arguments as Map<String, Any>)
                result.success(null)
            }

            "inquiry" -> {
                pluginSdkMethods.inquiry(call.arguments as Map<String, Any>)
                result.success(null)
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "mobile_payment_plugin")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        pluginSdkMethods = MobilePaymentPluginSdkMethods(binding.activity as FlutterActivity, channel)
    }

    override fun onDetachedFromActivityForConfigChanges() {

    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        pluginSdkMethods = MobilePaymentPluginSdkMethods(binding.activity as FlutterActivity, channel)
    }

    override fun onDetachedFromActivity() {}
}