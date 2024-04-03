import 'flutter_stripe_identity_platform_interface.dart';

class FlutterStripeIdentity {
  Future<String?> getPlatformVersion() {
    return FlutterStripeIdentityPlatform.instance.getPlatformVersion();
  }

  Future<String?> showStripeIdentityVerification(
      String verificationSessionId, String ephemeralKeySecret) {
    return FlutterStripeIdentityPlatform.instance
        .showStripeIdentityVerification(
            verificationSessionId, ephemeralKeySecret);
  }
}
