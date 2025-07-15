import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:ana_login_manager/src/web_login_manager.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:websafe_svg/websafe_svg.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'src/login_result.dart';
export 'src/login_result.dart';

typedef OnSuccessCallBack = void Function(LoginResult? result);
typedef OnClickCallBack = void Function();
typedef OnErrorCallBack = void Function(
    PlatformException error, String? message);

enum ConsentMode { Phone, Email, Face, none }

class AnaLoginManager {
  static String? _clientId;
  static const MethodChannel _channel = MethodChannel('analogin');
  static const String icon =
      'PHN2ZyB2aWV3Qm94PSIwIDAgODUuNzMgOTIuOTMiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgeG1sbnM6eGxpbms9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkveGxpbmsiPjxsaW5lYXJHcmFkaWVudCBpZD0iYSIgZ3JhZGllbnRUcmFuc2Zvcm09Im1hdHJpeCgxIDAgMCAtMSAwIDg4LjQ4KSIgZ3JhZGllbnRVbml0cz0idXNlclNwYWNlT25Vc2UiIHgxPSI3Ni41NSIgeDI9IjY3LjQiIHkxPSI3MS41MSIgeTI9IjI2LjgzIj48c3RvcCBvZmZzZXQ9IjAiIHN0b3AtY29sb3I9IiNiOGQwNGYiLz48c3RvcCBvZmZzZXQ9IjEiIHN0b3AtY29sb3I9IiM4MWJiMzAiLz48L2xpbmVhckdyYWRpZW50PjxsaW5lYXJHcmFkaWVudCBpZD0iYiIgZ3JhZGllbnRUcmFuc2Zvcm09Im1hdHJpeCgxIDAgMCAtMSAwIDg4LjQ4KSIgZ3JhZGllbnRVbml0cz0idXNlclNwYWNlT25Vc2UiIHgxPSI0NS4yNCIgeDI9IjM1LjM3IiB5MT0iNzguOTMiIHkyPSI2Mi4wMyI+PHN0b3Agb2Zmc2V0PSIwIiBzdG9wLWNvbG9yPSIjYjhkMDRmIi8+PHN0b3Agb2Zmc2V0PSIuMjkiIHN0b3AtY29sb3I9IiNhZWNjNDgiLz48c3RvcCBvZmZzZXQ9Ii44IiBzdG9wLWNvbG9yPSIjOTFjMDM3Ii8+PHN0b3Agb2Zmc2V0PSIxIiBzdG9wLWNvbG9yPSIjODFiYjMwIi8+PC9saW5lYXJHcmFkaWVudD48bGluZWFyR3JhZGllbnQgaWQ9ImMiIGdyYWRpZW50VHJhbnNmb3JtPSJtYXRyaXgoMSAwIDAgLTEgMCA4OC40OCkiIGdyYWRpZW50VW5pdHM9InVzZXJTcGFjZU9uVXNlIiB4MT0iNDAuMzMiIHgyPSIzNS44NiIgeTE9IjQ4Ljc5IiB5Mj0iMjYuOTUiPjxzdG9wIG9mZnNldD0iMCIgc3RvcC1jb2xvcj0iI2I4ZDA0ZiIvPjxzdG9wIG9mZnNldD0iLjI3IiBzdG9wLWNvbG9yPSIjYjBjZDRhIi8+PHN0b3Agb2Zmc2V0PSIuNjgiIHN0b3AtY29sb3I9IiM5OWM0M2IiLz48c3RvcCBvZmZzZXQ9IjEiIHN0b3AtY29sb3I9IiM4MWJiMzAiLz48L2xpbmVhckdyYWRpZW50PjxsaW5lYXJHcmFkaWVudCBpZD0iZCIgZ3JhZGllbnRUcmFuc2Zvcm09Im1hdHJpeCgxIDAgMCAtMSAwIDg4LjQ4KSIgZ3JhZGllbnRVbml0cz0idXNlclNwYWNlT25Vc2UiIHgxPSIyMi4xOCIgeDI9IjExLjk5IiB5MT0iNjkuMzciIHkyPSIxOS42MSI+PHN0b3Agb2Zmc2V0PSIwIiBzdG9wLWNvbG9yPSIjYjhkMDRmIi8+PHN0b3Agb2Zmc2V0PSIuMjYiIHN0b3AtY29sb3I9IiNiM2NlNGMiLz48c3RvcCBvZmZzZXQ9Ii41NyIgc3RvcC1jb2xvcj0iI2E1Yzg0MiIvPjxzdG9wIG9mZnNldD0iLjkiIHN0b3AtY29sb3I9IiM4Y2JmMzUiLz48c3RvcCBvZmZzZXQ9IjEiIHN0b3AtY29sb3I9IiM4MWJiMzAiLz48L2xpbmVhckdyYWRpZW50PjxwYXRoIGQ9Im04My40NyA4MC43NS0xNy40Ny05LjVhMTUuOTQgMTUuOTQgMCAwIDEgLTguMzEtMTR2LTU1LjY0YTEuNTMgMS41MyAwIDAgMSAyLjMxLTEuMzRsMTcuNDMgOS41YTE1Ljk0IDE1Ljk0IDAgMCAxIDguMzEgMTR2NTUuNjRhMS41MyAxLjUzIDAgMCAxIC0yLjI2IDEuMzR6IiBmaWxsPSJ1cmwoI2EpIi8+PHBhdGggZD0ibTQ5LjM5IDM2LjE5LTE0LjA2LTcuNjdhMTMuNDEgMTMuNDEgMCAwIDEgLTctMTEuNzZ2LTE0Ljk0YTEuNzQgMS43NCAwIDAgMSAyLjU5LTEuNTNsMTQuMDggNy43MWExMy40MSAxMy40MSAwIDAgMSA3IDExLjc2djE0LjlhMS43NCAxLjc0IDAgMCAxIC0yLjYxIDEuNTN6IiBmaWxsPSJ1cmwoI2IpIi8+PHBhdGggZD0ibTUyIDcyLjU5LTI4LTUuNzl2LTM3bDE5LjY2IDEwLjczYTE1Ljk0IDE1Ljk0IDAgMCAxIDguMzEgMTR6IiBmaWxsPSJ1cmwoI2MpIi8+PHBhdGggZD0ibTUyIDcyLjU5LTIzLjY1LTQwLjQtMi44OCAyNiAyLjUzIDEuMzN2MjEuNDJhMTIgMTIgMCAwIDAgMjQgMHoiIGZpbGw9IiM0NjhkMzMiLz48cGF0aCBkPSJtMzMuMjggOTAuOTJhMTIuMTUgMTIuMTUgMCAwIDEgLTUuMy0xMHYtNTcuMjVhMTYgMTYgMCAwIDAgLTguMjktMTRsLTE3LjQ3LTkuNDlhMS41IDEuNSAwIDAgMCAtMi4yMiAxLjMydjYyLjVhMTUgMTUgMCAwIDAgNy44MyAxMy4xMXoiIGZpbGw9InVybCgjZCkiLz48L3N2Zz4=';

  // static Future<String?> get platformVersion async {
  //   final String? version = await _channel.invokeMethod('getPlatformVersion');
  //   return version;
  // }

  static Future<String> init(String clientId) async {
    _clientId=clientId;
    if (kIsWeb || Platform.isWindows) {
      return Future.value("");
    }
    final String result = await _channel.invokeMethod(
        'init', {"clientId": clientId}).onError((error, stackTrace) {
      return error.toString();
    });
    if (kDebugMode) {
      print("initialze call back: $result");
    }
    return result;
  }

  static login(
    BuildContext context, {
    required final String scope,
    final ConsentMode? consentMode,
    final bool requiredAnaAppInstalled=true,
    final OnClickCallBack? onClick,
    required final OnSuccessCallBack onSuccess,
    final OnErrorCallBack? onError,
  }) async {
    onClick?.call();
    if (kIsWeb || Platform.isWindows) {
      WebLoginManager.login(
        clientId: _clientId!,
        scope:scope,
        consentMode:consentMode??ConsentMode.none,
        onClick: onClick,
        onSuccess:(result){
          if (kDebugMode) {
            print("login call back:$result");
          }
          onSuccess.call(LoginResult.fromString(result));
        },
        onError: onError,
      );
      return;
    }
    final String? result = await _channel.invokeMethod('login', {
      "scope": scope,
      'consentMode': consentMode?.name ?? ConsentMode.none.name,
    }).onError((PlatformException error, stackTrace) async {
      if (kDebugMode) {
        print("login call back [onError]:${error.toString()}");
      }
      if (error.code == "-1") {
        if(requiredAnaAppInstalled && !kIsWeb){
          _showMyDialog(context,onFinish: (){
            onError?.call(error, error.message.toString());
          });
        }else{
          WebLoginManager.login(
            clientId: _clientId!,
            scope:scope,
            consentMode:consentMode??ConsentMode.none,
            onClick: onClick,
            onSuccess:(result){
              if (kDebugMode) {
                print("login call back:$result");
              }
              onSuccess.call(LoginResult.fromString(result));
            },
            onError: onError,
          );
        }
      }else{
        onError?.call(error, error.message.toString());
      }
      return null;
    });
    if (result != null) {
      if (kDebugMode) {
        print("login call back:$result");
      }
      onSuccess.call(LoginResult.fromString(result));
    }
  }

  static Future<void> _showMyDialog(BuildContext context,{
    final VoidCallback? onFinish,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async{
            onFinish?.call();
            return true;
          },
          child: AlertDialog(
            title: const Text('منصة انا'),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('ليس لديك تطبيق انا! هل تريد تحميلة الان؟'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('لا'),
                onPressed: () {
                  Navigator.of(context).pop();
                  onFinish?.call();
                },
              ),
              TextButton(
                child: const Text('نعم'),
                onPressed: () {
                  Navigator.of(context).pop();
                  if (!kIsWeb) {
                    if (Platform.isAndroid) {
                      _launchURL(
                          "https://play.google.com/store/apps/details?id=ana.app.ekyc");
                    } else if (Platform.isIOS) {
                      _launchURL("https://apps.apple.com/app/id1661473748");
                    }
                    onFinish?.call();

                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  static _launchURL(String? url,
      {final Uri? uri, VoidCallback? onError}) async {
    bool canNotLunch = url == null && uri == null;
    if (canNotLunch ||
        await canLaunchUrl(uri ?? Uri.parse(url ?? '')) == false) {
      if (kDebugMode) {
        print('===> canLaunchUrl==false');
      }
      return onError?.call();
    }

    await launchUrl(
      uri ?? Uri.parse(url ?? ''),
      mode: LaunchMode.externalApplication,
    );
  }

  static loginButton(
    BuildContext context, {
    required final String scope,
    final ConsentMode? consentMode,
    final bool requiredAnaAppInstalled=true,
    final Color? color,
    final Color? textColor,
    final String Function(String text)? translation,
    final OnClickCallBack? onClick,
    final OnClickCallBack? onHandlingRegistrationManually,
    required final OnSuccessCallBack onSuccess,
    final OnErrorCallBack? onError,
  }) {
    return IntrinsicWidth(
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        color: color ?? const Color(0xFF81bb30),
        onPressed: () async {
          if(onHandlingRegistrationManually!=null){
            onHandlingRegistrationManually?.call();
            return;
          }
          await AnaLoginManager.login(
            context,
            scope: scope,
            consentMode: consentMode,
            requiredAnaAppInstalled:requiredAnaAppInstalled,
            onClick: onClick,
            onSuccess: onSuccess,
            onError: onError,
          );
        },
        padding: const EdgeInsetsDirectional.only(end: 24),
        clipBehavior: Clip.hardEdge,
        child: Row(
          children: [
            Container(
                color: Colors.white,
                padding: const EdgeInsets.all(9),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 10,
                  child: WebsafeSvg.memory(base64Decode(icon), height: 20),
                )),
            /*,*/
            const SizedBox(
              width: 16,
            ),
            Text(
              (translation?.call("Sign in by Ana") ?? "Sign in by Ana")
                  .toUpperCase(),
              style: TextStyle(
                fontSize: 18,
                color: color ?? Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static defaultButton(
      BuildContext context, {
        required final String scope,
        final ConsentMode? consentMode,
        final bool requiredAnaAppInstalled=true,
        final Color? color,
        final Color? textColor,
        final String Function(String text)? translation,
        final OnClickCallBack? onClick,
        final OnClickCallBack? onHandlingRegistrationManually,
        required final OnSuccessCallBack onSuccess,
        final OnErrorCallBack? onError,
  }) {
    return IntrinsicWidth(
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        color: color ?? const Color(0xFF81bb30),
        onPressed: () async {
          if(onHandlingRegistrationManually!=null){
            onHandlingRegistrationManually?.call();
            return;
          }
          await AnaLoginManager.login(
            context,
            scope: scope,
            consentMode: consentMode,
            requiredAnaAppInstalled:requiredAnaAppInstalled,
            onClick: onClick,
            onSuccess: onSuccess,
            onError: onError,
          );
        },
        padding: const EdgeInsetsDirectional.only(end: 24),
        clipBehavior: Clip.hardEdge,
        child: Row(
          children: [
            Container(
                color: Colors.white,
                padding: const EdgeInsets.all(9),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 10,
                  child: WebsafeSvg.memory(base64Decode(icon), height: 20),
                )),
            /*,*/
            const SizedBox(
              width: 16,
            ),
            Text(
              (translation?.call("Ana Platform") ?? "Ana Platform")
                  .toUpperCase(),
              style: TextStyle(
                fontSize: 18,
                color: color ?? Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
  static loginButtonBig(
    BuildContext context, {
    required final String scope,
    final ConsentMode? consentMode,
    final bool requiredAnaAppInstalled=true,
    final Color? color,
    final Color? textColor,
    final String Function(String text)? translation,
    final OnClickCallBack? onClick,
    final OnClickCallBack? onHandlingRegistrationManually,
    required final OnSuccessCallBack onSuccess,
    final OnErrorCallBack? onError,
  }) {
    return IntrinsicWidth(
      child: MaterialButton(
        //minWidth: double.infinity,
        padding: const EdgeInsetsDirectional.only(end: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        color: color ?? const Color(0xFF81bb30),
        onPressed: () async {
          if(onHandlingRegistrationManually!=null){
            onHandlingRegistrationManually?.call();
            return;
          }
          await AnaLoginManager.login(
            context,
            scope: scope,
            consentMode: consentMode,
            requiredAnaAppInstalled:requiredAnaAppInstalled,
            onClick: onClick,
            onSuccess: onSuccess,
            onError: onError,
          );
        },
        child: Row(
          children: [
            Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF81bb30),
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                padding: const EdgeInsets.all(4),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: WebsafeSvg.memory(base64Decode(icon),
                      //colorFilter: ColorFilter.mode(color??const Color(0xFF81bb30), BlendMode.color),
                      height: 25),
                )),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Text(
                (translation?.call("Sign in by Ana") ?? "Sign in by Ana")
                    .toUpperCase(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  color: color ?? Colors.white,
                ),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
          ],
        ),
      ),
    );
  }
  static transLoginButton(
      BuildContext context, {
        required final String scope,
        final ConsentMode? consentMode,
        final bool requiredAnaAppInstalled=true,
        final Color? color,
        final Color? textColor,
        final String Function(String text)? translation,
        final OnClickCallBack? onClick,
        final OnClickCallBack? onHandlingRegistrationManually,
        required final OnSuccessCallBack onSuccess,
        final OnErrorCallBack? onError,
      }) {
    return Opacity(
      opacity: 0.7,
      child: Padding(
        padding: const EdgeInsetsDirectional.only(top: 4),
        child: InkWell(
          onTap: () async {
            if(onHandlingRegistrationManually!=null){
              onHandlingRegistrationManually?.call();
              return;
            }
            await AnaLoginManager.login(
              context,
              scope: scope,
              consentMode: consentMode,
              requiredAnaAppInstalled:requiredAnaAppInstalled,
              onClick: onClick,
              onSuccess: onSuccess,
              onError: onError,
            );
          },
          child: Container(

            decoration: BoxDecoration(
              color: Color.alphaBlend(
                Colors.black.withOpacity(0.5),
                Color(0xFF81bb30),
              ).withOpacity(0.5),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 13, vertical: 9),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFF81bb30),
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      //padding: const EdgeInsets.all(4),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 14,
                        child: WebsafeSvg.memory(base64Decode(icon),
                            //colorFilter: ColorFilter.mode(color??const Color(0xFF81bb30), BlendMode.color),
                            height: 20),
                      )),
                  const SizedBox(
                    width: 16,
                  ),
                  Text(
                    (translation?.call("Ana Platform") ?? "Ana Platform")
                        .toUpperCase(),
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

  }
  static testInstallAppDialogButton(BuildContext context) {
    return IntrinsicWidth(
      child: MaterialButton(
        padding: const EdgeInsetsDirectional.only(end: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        color: const Color(0xFF81bb30),
        onPressed: () async {
          _showMyDialog(context);
        },
        child: Row(
          children: [
            Container(
                color: Colors.white,
                padding: const EdgeInsets.all(9),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 10,
                  child: WebsafeSvg.memory(base64Decode(icon), height: 20),
                )),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Text(
                ("Test show dialog").toUpperCase(),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
          ],
        ),
      ),
    );
  }
}
