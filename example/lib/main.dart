import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:ana_login_manager/ana_login_manager.dart';
import 'package:logger/logger.dart';

final logger = Logger();

void main() {
  runApp(
    const MaterialApp(
      localizationsDelegates: [
        DefaultMaterialLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', 'us'),
      ],
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _error;
  LoginResult? _result;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    AnaLoginManager.init("your_app_id");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: _error != null
            ? Text('Running on: $_result\n')
            : Column(
                children: [
                  ...?_result
                      ?.toJson()
                      .map((key, value) => MapEntry(
                          key,
                          ListTile(
                            title: Text('$key'),
                            subtitle: value is Map
                                ? Column(
                                    children: [
                                      ...value
                                          .map((key2, value2) => MapEntry(
                                              key2,
                                              ListTile(
                                                title: Text('$key2'),
                                                subtitle: Text(
                                                    value2?.toString() ?? ""),
                                                //subtitle: ,
                                              )))
                                          .values
                                          .toList()
                                    ],
                                  )
                                : Text(value?.toString() ?? ""),
                            //subtitle: ,
                          )))
                      .values
                      .toList(),
                ],
              ),
      ),
      bottomNavigationBar: IntrinsicHeight(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // AnaLoginManager.loginButtonBig(context,
                //     scope:
                //         "user.profile fullNameEn homeAddress idCard mail homePhone phone workInfo",
                //     onSuccess: (result) {
                //   if (kDebugMode) {
                //     logger.d(result.toString());
                //   }
                //   setState(() {
                //     _error = null;
                //     _result = result;
                //   });
                // }, onError: (PlatformException error, String? message) {
                //   if (kDebugMode) {
                //     logger.d(error.toString());
                //   }
                //   setState(() {
                //     _error = error.toString();
                //   });
                // }),

                ///...
                const SizedBox(height: 16.0),
                const Text('With No consentMode'),
                AnaLoginManager.loginButton(context,
                    scope:
                        "user.profile fullNameEn homeAddress idCard mail homePhone phone workInfo",
                    onSuccess: (result) {
                  if (kDebugMode) {
                    logger.d(result.toString());
                  }
                  setState(
                    () {
                      _error = null;
                      _result = result;
                    },
                  );
                }, onError: (PlatformException error, String? message) {
                  if (kDebugMode) {
                    logger.d(error.toString());
                  }
                  setState(() {
                    _error = error.toString();
                  });
                }),

                ///...
                const SizedBox(height: 16.0),
                const Text('With Face consentMode'),
                AnaLoginManager.loginButton(context,
                    consentMode: ConsentMode.Face,
                    scope:
                    "user.profile fullNameEn homeAddress idCard mail homePhone phone workInfo",
                    onSuccess: (result) {
                      if (kDebugMode) {
                        logger.d(result.toString());
                      }
                      setState(
                            () {
                          _error = null;
                          _result = result;
                        },
                      );
                    }, onError: (PlatformException error, String? message) {
                      if (kDebugMode) {
                        logger.d(error.toString());
                      }
                      setState(() {
                        _error = error.toString();
                      });
                    }),

                ///...
                const SizedBox(height: 16.0),
                const Text('With Phone consentMode'),
                AnaLoginManager.loginButton(context,
                    consentMode: ConsentMode.Phone,
                    scope:
                        "user.profile fullNameEn homeAddress idCard mail homePhone phone workInfo",
                    onSuccess: (result) {
                  if (kDebugMode) {
                    logger.d(result.toString());
                  }
                  setState(() {
                    _error = null;
                    _result = result;
                  });
                }, onError: (PlatformException error, String? message) {
                  if (kDebugMode) {
                    logger.d(error.toString());
                  }
                  setState(() {
                    _error = error.toString();
                  });
                }),

                ///...
                const SizedBox(height: 16.0),
                const Text('with Email consentMode'),
                AnaLoginManager.loginButton(context,
                    consentMode: ConsentMode.Email,
                    onClick: () {
                      logger.d('on Click');
                    },
                    scope:
                        "user.profile fullNameEn homeAddress idCard mail homePhone phone workInfo",
                    onSuccess: (result) {
                      if (kDebugMode) {
                        logger.d(result.toString());
                      }
                      setState(() {
                        _error = null;
                        _result = result;
                      });
                    },
                    onError: (PlatformException error, String? message) {
                      if (kDebugMode) {
                        logger.d(error.toString());
                      }
                      setState(() {
                        _error = error.toString();
                      });
                    }),

                ///...
                // const SizedBox(height: 16.0),
                // const Text('test show install app dialog'),
                // AnaLoginManager.testInstallAppDialogButton(context),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
