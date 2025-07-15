import 'dart:async';
import 'package:flutter/services.dart';
import 'src/login_result.dart';
export 'src/login_result.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

typedef OnSuccessCallBack = void Function(LoginResult? result);
typedef OnClickCallBack = void Function();
typedef OnErrorCallBack = void Function(
    PlatformException error, String? message);

class AnaLoginManagerWeb {
 // static String? _clientId;
  //static const MethodChannel _channel = MethodChannel('analogin');

  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
      'analogin',
      const StandardMethodCodec(),
      registrar,
    );

    final pluginInstance = AnaLoginManagerWeb();
    channel.setMethodCallHandler(pluginInstance.handleMethodCall);
  }

  /// Handles method calls over the MethodChannel of this plugin.
  /// Note: Check the "federated" architecture for a new way of doing this:
  /// https://flutter.dev/go/federated-plugins
  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'init':
        return init(call.arguments);
      case 'login':
        return login(call.arguments);
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: 'adutils_facetec for web doesn\'t implement \'${call.method}\'',
        );
    }
  }
  Future<String> init(args) {
    return Future.value("");
  }
  Future<String> login(args) {
    throw PlatformException(
      code: "-1",
      details: 'Ana app not installed',
    );
  }

}
