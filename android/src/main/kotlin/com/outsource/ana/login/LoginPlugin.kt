package com.outsource.ana.login

import android.app.Activity
import android.content.Context
import android.util.Log
import androidx.annotation.NonNull
import com.outsource.ana.anasdkmanager.AnaLoginManager
import com.outsource.ana.anasdkmanager.base.LoginResult
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

/** LoginPlugin */

class LoginPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private var activity: Activity? = null
  private var context: Context? = null

  var resultCallback: MethodResultWrapper? = null

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "analogin")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.getApplicationContext()
    //context?.setTheme(R.style.TransparentLaunchTheme)
   // activity = flutterPluginBinding.getApplicationContext()

  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
    resultCallback = MethodResultWrapper(result)
    val arg = call.arguments as Map<*, *>?

    if (call.method == "init") {
      if (arg != null) {
        AnaLoginManager.init(arg["clientId"] as String,false)
        resultCallback?.success("SDK initialized")
      } else {
        Log.d("onMethodCall", "Please send arguments")
        resultCallback?.error("-1","onMethodCall SDK initialized","Please send arguments")
      }

    } else if (call.method == "login") {
//      Log.d("::::::::::arg", arg.toString());
//      val consentMode = arg?.get("consentMode") as String?;
//      Log.d("::::::::::consM",consentMode?.toString());
      AnaLoginManager.login(activity, arg?.get("scope") as String?, arg?.get("consentMode") as String?,object : AnaLoginManager.AnaLoginChangeCallback {
        override fun onSuccess(result: LoginResult?) {
          Log.d("login Success result:", result.toString())
          resultCallback?.success(result?.toString())
        }
        override fun onError(code: String, error: String) {
          Log.d("onError [login]", "[code]: $code [error]: $error")
          resultCallback?.error(code,error,error)
        }
      })
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }


  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.getActivity()

   // activity?.setTheme(R.style.TransparentLaunchTheme)
  }

  override fun onDetachedFromActivityForConfigChanges() {}

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.getActivity()
  }

  override fun onDetachedFromActivity() {}

}
