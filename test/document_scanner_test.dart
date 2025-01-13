import 'package:doc_scanner_kit/document_scanner.dart';
import 'package:doc_scanner_kit/document_scanner_method_channel.dart';
import 'package:doc_scanner_kit/document_scanner_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';



class MockDocumentScannerPlatform
    with MockPlatformInterfaceMixin
    implements DocumentScannerPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<String?> getScanDocuments([int page = 5]) => Future.value();

  @override
  Future<String?> getScannedDocumentAsImages([int page = 5]) => Future.value();

  @override
  Future<String?> getScannedDocumentAsPdf([int page = 5]) => Future.value();

  @override
  Future<String?> getScanDocumentsUri([int page = 5]) => Future.value();
}

void main() {
  final DocumentScannerPlatform initialPlatform =
      DocumentScannerPlatform.instance;

  test('$MethodChannelDocumentScanner is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelDocumentScanner>());
  });

  test('getPlatformVersion', () async {
    DocumentScanner flutterDocScannerPlugin = DocumentScanner();
    MockDocumentScannerPlatform fakePlatform =
        MockDocumentScannerPlatform();
    DocumentScannerPlatform.instance = fakePlatform;

    expect(await flutterDocScannerPlugin.getPlatformVersion(), '42');
  });
}
