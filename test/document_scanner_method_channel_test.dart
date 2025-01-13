import 'package:doc_scanner_kit/document_scanner_method_channel.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';




void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelDocumentScanner platform = MethodChannelDocumentScanner();
  const MethodChannel channel = MethodChannel('doc_scanner_kit');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
