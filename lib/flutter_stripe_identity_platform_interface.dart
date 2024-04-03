import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_stripe_identity_method_channel.dart';

abstract class FlutterStripeIdentityPlatform extends PlatformInterface {
  /// Constructs a FlutterStripeIdentityPlatform.
  FlutterStripeIdentityPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterStripeIdentityPlatform _instance =
      MethodChannelFlutterStripeIdentity();

  /// The default instance of [FlutterStripeIdentityPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterStripeIdentity].
  static FlutterStripeIdentityPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterStripeIdentityPlatform] when
  /// they register themselves.
  static set instance(FlutterStripeIdentityPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  showStripeIdentityVerification(
      String verificationSessionId, String ephemeralKeySecret) {
    instance.showStripeIdentityVerification(
        verificationSessionId, ephemeralKeySecret);
  }
}
