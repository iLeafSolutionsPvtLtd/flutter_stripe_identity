package com.ileaf.flutter_stripe_identity

import android.app.Activity
import android.content.ContentValues.TAG
import android.content.Context
import android.net.Uri
import android.util.Log
import androidx.activity.ComponentActivity
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import com.stripe.android.identity.IdentityVerificationSheet
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

/** FlutterStripeIdentityPlugin */
class FlutterStripeIdentityPlugin: FlutterPlugin, MethodCallHandler ,ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context: Context
  private lateinit var activity: Activity
  lateinit var identityVerificationSheet: IdentityVerificationSheet

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_stripe_identity")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext

  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "stripeIdentityVerification") {
      //result.success("Android ${android.os.Build.VERSION.RELEASE}")
        call.argument<String>("verificationSessionId")
            ?.let { onIdentify(verificationSessionId = it, ephemeralKeySecret = call.argument<String>("ephemeralKeySecret")!!) }

    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onDetachedFromActivity() {
    TODO("Not yet implemented")
  }

override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    TODO("Not yet implemented")
}

override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity;
    configureIdentitySheet(activity)
}

override fun onDetachedFromActivityForConfigChanges() {
    TODO("Not yet implemented")
}
  private fun configureIdentitySheet(activity:Activity) {
        identityVerificationSheet =
            IdentityVerificationSheet.create(
                activity as ComponentActivity,
                IdentityVerificationSheet.Configuration(
                    // Pass your square brand logo by creating it from local resource or
                    // Uri.parse("https://loremflickr.com/cache/resized/65535_52682003064_4355ce4967_q_120_120_nofilter.jpg")
                    brandLogo = Uri.parse("https://loremflickr.com/cache/resized/65535_52682003064_4355ce4967_q_120_120_nofilter.jpg")
                )
            ) { verificationFlowResult->
                when (verificationFlowResult) {
                    is IdentityVerificationSheet.VerificationFlowResult.Completed -> {
                        // The user has completed uploading their documents.
                        // Let them know that the verification is processing.

                        Log.d(TAG, "Verification Flow Completed!")
                    }
                    is IdentityVerificationSheet.VerificationFlowResult.Canceled -> {
                        // The user did not complete uploading their documents.
                        // You should allow them to try again.

                        Log.d(TAG, "Verification Flow Canceled!")
                    }
                    is IdentityVerificationSheet.VerificationFlowResult.Failed -> {
                        // If the flow fails, you should display the localized error
                        // message to your user using throwable.getLocalizedMessage()

                        Log.d(TAG, "Verification Flow Failed!")
                    }
                }
            }
    }
    private fun onIdentify(verificationSessionId: String, ephemeralKeySecret: String) {
        // show loading UI
        // Request the session ID with Fuel or other network libraries
        // start verification session
        identityVerificationSheet.present(
            verificationSessionId = verificationSessionId,
            ephemeralKeySecret = ephemeralKeySecret
        )
    }
}
