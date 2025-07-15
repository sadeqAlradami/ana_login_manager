import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ana_login_manager/ana_login_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';
class MyInAppBrowser extends InAppBrowser {
  final OnClickCallBack? onClick;
  final Function(InAppBrowser browser,String result) onSuccess;
  final OnErrorCallBack? onError;
  MyInAppBrowser({
    this.onClick,
    required this.onSuccess,
    this.onError,
  });
  @override
  Future onBrowserCreated() async {
    print("Browser Created!");
  }

  @override
  Future onLoadStart(url) async {
    print("Started $url");
  }

  @override
  Future onLoadStop(url) async {
    //final uri=Uri.tryParse(url.queryParameters);
    if(url?.queryParameters.containsKey("isconsent")==true && url?.queryParameters["isconsent"]=='true' && url?.queryParameters.containsKey("auth_code")==true){
      onSuccess.call(this,json.encode({
        'authId': url!.queryParameters["auth_code"]!
      }));
    }else if(url?.queryParameters.containsKey("isconsent")==true && url?.queryParameters["isconsent"]=='false'){
      close();
    }
    print("Stopped $url");
  }

  @override
  void onExit() {
    onError?.call(PlatformException(code: "-1",message: "User not complete the process"),"");
    print("Browser closed!");
  }
  @override
  Future<ServerTrustAuthResponse?>? onReceivedServerTrustAuthRequest(
      URLAuthenticationChallenge challenge) async{
    return ServerTrustAuthResponse(action: ServerTrustAuthResponseAction.PROCEED);
  }
  // @override
  // Future<PermissionRequestResponse?>? androidOnPermissionRequest(
  //     String origin, List<String> resources) {
  //   print("androidOnPermissionRequest");
  //
  //   return null;
  // }
  // @override
  // void onPermissionRequestCanceled(PermissionRequest permissionRequest) {
  //   print("onPermissionRequestCanceled");
  //
  // }
  @override
  void onRenderProcessGone(RenderProcessGoneDetail detail) {
    onError?.call(PlatformException(code: "-1",message: "User not complete the process"),"");
  }
  @override
  Future<PermissionResponse?>? onPermissionRequest(
      PermissionRequest permissionRequest)async{
    print("onPermissionRequest");
    final resources = <PermissionResourceType>[];
    if (permissionRequest.resources.contains(PermissionResourceType.CAMERA)) {
      final cameraStatus = await Permission.camera.request();
      if (!cameraStatus.isDenied) {
        resources.add(PermissionResourceType.CAMERA);
      }
    }
    if (permissionRequest.resources
        .contains(PermissionResourceType.MICROPHONE)) {
      final microphoneStatus =
      await Permission.microphone.request();
      if (!microphoneStatus.isDenied) {
        resources.add(PermissionResourceType.MICROPHONE);
      }
    }
    // only for iOS and macOS
    if (permissionRequest.resources
        .contains(PermissionResourceType.CAMERA_AND_MICROPHONE)) {
      final cameraStatus = await Permission.camera.request();
      final microphoneStatus =
      await Permission.microphone.request();
      if (!cameraStatus.isDenied && !microphoneStatus.isDenied) {
        resources.add(PermissionResourceType.CAMERA_AND_MICROPHONE);
      }
    }
    //print("onPermissionRequest CAMERA ${resources.isEmpty?'DENY':'GRANT'}");
    return PermissionResponse(
        resources: resources,
        action: resources.isEmpty
            ? PermissionResponseAction.DENY
            : PermissionResponseAction.GRANT);



    //Permission.camera.request();
    /*if(permissionRequest.resources.length==1 && permissionRequest.resources.contains(PermissionResourceType.CAMERA)){
      print("onPermissionRequest CAMERA");

      final completer = Completer<PermissionResponse?>();
      Permission.camera
          .onDeniedCallback(() {
              print("onPermissionRequest CAMERA DENY");
              completer.complete(PermissionResponse(resources: permissionRequest.resources,action:  PermissionResponseAction.DENY));
            })
                .onGrantedCallback(() {
                  print("onPermissionRequest CAMERA isGranted");
                  completer.complete(PermissionResponse(resources: permissionRequest.resources,action:  PermissionResponseAction.GRANT));
            })
                .onPermanentlyDeniedCallback(() {
        print("onPermissionRequest CAMERA onPermanentlyDeniedCallback");
        completer.complete(PermissionResponse(resources: permissionRequest.resources,action:  PermissionResponseAction.DENY));
            })
                .onRestrictedCallback(() {
        print("onPermissionRequest CAMERA onRestrictedCallback");
        completer.complete(PermissionResponse(resources: permissionRequest.resources,action:  PermissionResponseAction.DENY));
            })
                .onLimitedCallback(() {
        print("onPermissionRequest CAMERA onLimitedCallback");
        completer.complete(PermissionResponse(resources: permissionRequest.resources,action:  PermissionResponseAction.DENY));
            })
                .onProvisionalCallback(() {
        print("onPermissionRequest CAMERA onProvisionalCallback");
        completer.complete(PermissionResponse(resources: permissionRequest.resources,action:  PermissionResponseAction.DENY));
            })
          .request();
      // if(permissionStatus.isGranted){
      //   print("onPermissionRequest CAMERA isGranted");
      //   completer.complete(PermissionResponse(resources: permissionRequest.resources,action:  PermissionResponseAction.GRANT));
      //   return PermissionResponse(resources: permissionRequest.resources,action:  PermissionResponseAction.GRANT);
      // }else{
      //   print("onPermissionRequest CAMERA DENY");
      //   return PermissionResponse(resources: permissionRequest.resources,action:  PermissionResponseAction.DENY);
      //
      // }
      return completer.future;
    }*/
    return null;
  }

}
class WebLoginManager {
  // String url = 'https://anawebykb.web.app/conn/auth';
  //
  // final settings = InAppBrowserClassSettings(
  //     browserSettings: InAppBrowserSettings(
  //         hideUrlBar: true,
  //         toolbarTopBackgroundColor: Colors.white,
  //         presentationStyle: ModalPresentationStyle.POPOVER,
  //         hideDefaultMenuItems: true,
  //
  //     ),
  //     webViewSettings: InAppWebViewSettings(
  //         isInspectable: kDebugMode));

  static Future<String?> login({
    required final String clientId,
    required final String scope,
    required final ConsentMode consentMode,
    final OnClickCallBack? onClick,
    required final Function(String result) onSuccess,
    //required final OnSuccessCallBack onSuccess,
    final OnErrorCallBack? onError,
  }) async {
   // await InAppWebViewController.setWebContentsDebuggingEnabled(true);
    final completer = Completer<String?>();

    final browser = MyInAppBrowser(
      onClick: onClick,
      onSuccess: (browser,result){
        completer.complete(result);
        onSuccess.call(result);
        browser.close();
      },
      onError: (PlatformException error, String? message){
        if(!completer.isCompleted){
          completer.complete(null);
          onError?.call(error,message);
        }
      },

    );

    String url=kDebugMode?"https://stagebas.yk-bank.com:9104":"https://online.ana.com.ye:4949";
    final uri=Uri(queryParameters: {
      "response_type":"code",
      "client_id":clientId,
      "scope":scope.replaceAll(",", " "),
      "redirect_uri":"$url/api/v1/auth/callback",
      "channel":"api",
      "consent_mode":consentMode.name
    });
    print("${uri.toString()}");
    if (!kIsWeb && !kDebugMode) {
      await CookieManager.instance().deleteAllCookies();
      WebStorageManager webStorageManager = WebStorageManager.instance();
      if (Platform.isAndroid) {
        // if current platform is Android, delete all data.
        await webStorageManager.deleteAllData();
      } else if (Platform.isIOS) {
        // if current platform is iOS, delete all data for "flutter.dev".
        var records = await webStorageManager
            .fetchDataRecords(dataTypes: WebsiteDataType.values);
        var recordsToDelete = <WebsiteDataRecord>[];
        for (var record in records) {
          if (['anawebykb.web.app','stagebas.yk-bank.com','online.ana.com.ye'].contains(record.displayName) ==true ) {
            recordsToDelete.add(record);
          }
        }
        await webStorageManager.removeDataFor(
          dataTypes: WebsiteDataType.values,
          dataRecords: recordsToDelete,
        );
      }
    }

    browser.openUrlRequest(
        urlRequest: URLRequest(url: WebUri("${url}/conn/auth${uri.toString()}"),),
        settings: InAppBrowserClassSettings(
            browserSettings: InAppBrowserSettings(
              hideUrlBar: true,
              toolbarTopBackgroundColor: Colors.white,
              presentationStyle: ModalPresentationStyle.POPOVER,
              hideDefaultMenuItems: true,
              toolbarTopFixedTitle: "منصة انا",
              allowGoBackWithBackButton: false,
              //closeOnCannotGoBack: false,
              shouldCloseOnBackButtonPressed: true,
                hideToolbarBottom:true,
                toolbarTopTintColor:Colors.black
            ),
            webViewSettings: InAppWebViewSettings(
                isInspectable: kDebugMode,
                clearSessionCache: true,
                mediaPlaybackRequiresUserGesture:false,
                allowsInlineMediaPlayback: true,
                //iframeAllow: "camera; microphone",
                //iframeAllowFullscreen: true,
                useOnRenderProcessGone: true,
                safeBrowsingEnabled: false
            ),

        )
    );
    return completer.future;
  }


}
