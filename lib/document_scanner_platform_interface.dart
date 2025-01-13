import 'package:doc_scanner_kit/document_scanner_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';



abstract class DocumentScannerPlatform extends PlatformInterface {
  /// Constructs a DocumentScannerPlatform.
  DocumentScannerPlatform() : super(token: _token);

  static final Object _token = Object();

  static DocumentScannerPlatform _instance = MethodChannelDocumentScanner();

  /// The default instance of [DocumentScannerPlatform] to use.
  ///
  /// Defaults to [MethodChannelDocumentScanner].
  static DocumentScannerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DocumentScannerPlatform] when
  /// they register themselves.
  static set instance(DocumentScannerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<dynamic> getScanDocuments([int page = 4]) {
    throw UnimplementedError('ScanDocuments() has not been implemented.');
  }

  Future<dynamic> getScannedDocumentAsImages([int page = 4]) {
    throw UnimplementedError('ScanDocuments() has not been implemented.');
  }

  Future<dynamic> getScannedDocumentAsPdf([int page = 4]) {
    throw UnimplementedError('ScanDocuments() has not been implemented.');
  }

  Future<dynamic> getScanDocumentsUri([int page = 4]) {
    throw UnimplementedError('ScanDocuments() has not been implemented.');
  }
}
