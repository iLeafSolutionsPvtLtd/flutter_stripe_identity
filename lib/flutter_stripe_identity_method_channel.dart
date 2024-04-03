import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_stripe_identity_platform_interface.dart';

/// An implementation of [FlutterStripeIdentityPlatform] that uses method channels.
class MethodChannelFlutterStripeIdentity extends FlutterStripeIdentityPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_stripe_identity');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> showStripeIdentityVerification(
      String verificationSessionId, String ephemeralKeySecret) async {
    final resultMessage =
        await methodChannel.invokeMethod('stripeIdentityVerification', {
      'verificationSessionId': verificationSessionId,
      'ephemeralKeySecret': ephemeralKeySecret
    });
    return resultMessage;
  }
}
