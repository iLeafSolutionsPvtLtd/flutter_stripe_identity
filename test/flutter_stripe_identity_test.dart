import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_stripe_identity/flutter_stripe_identity.dart';
import 'package:flutter_stripe_identity/flutter_stripe_identity_platform_interface.dart';
import 'package:flutter_stripe_identity/flutter_stripe_identity_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterStripeIdentityPlatform
    with MockPlatformInterfaceMixin
    implements FlutterStripeIdentityPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterStripeIdentityPlatform initialPlatform = FlutterStripeIdentityPlatform.instance;

  test('$MethodChannelFlutterStripeIdentity is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterStripeIdentity>());
  });

  test('getPlatformVersion', () async {
    FlutterStripeIdentity flutterStripeIdentityPlugin = FlutterStripeIdentity();
    MockFlutterStripeIdentityPlatform fakePlatform = MockFlutterStripeIdentityPlatform();
    FlutterStripeIdentityPlatform.instance = fakePlatform;

    expect(await flutterStripeIdentityPlugin.getPlatformVersion(), '42');
  });
}
