import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_stripe_identity/flutter_stripe_identity.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _flutterStripeIdentityPlugin = FlutterStripeIdentity();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _flutterStripeIdentityPlugin.getPlatformVersion() ??
              'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              Text('Running on: $_platformVersion\n'),
              TextButton(
                  onPressed: () async {
                    final result = await _flutterStripeIdentityPlugin
                        .showStripeIdentityVerification(
                            'vs_1P11PsLU2cdGz51KXfNPcaOo',
                            'ek_test_YWNjdF8xT0xDSmZMVTJjZEd6NTFLLDV6NUswS0h3b1lZeFhEUFZGZHFZczBjMU5DeVBialA_00IInhDYe4');
                    setState(() {
                      _platformVersion = result ?? '';
                    });
                  },
                  child: const Text('stripe identity verification'))
            ],
          ),
        ),
      ),
    );
  }
}
