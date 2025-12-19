import 'package:doc_scanner_kit/document_scanner_method_channel.dart';
import 'package:doc_scanner_kit/models/pdf_edit_options.dart';
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

  /// Edit a PDF file with annotations and modifications
  Future<PdfEditResult> editPdf({
    required String pdfPath,
    required PdfEditOptions options,
  }) {
    throw UnimplementedError('editPdf() has not been implemented.');
  }

  /// Add annotations to an existing PDF
  Future<PdfEditResult> addAnnotationsToPdf({
    required String pdfPath,
    required List<PdfAnnotation> annotations,
    String? outputPath,
  }) {
    throw UnimplementedError('addAnnotationsToPdf() has not been implemented.');
  }

  /// Merge multiple PDFs into one
  Future<PdfEditResult> mergePdfs({
    required List<String> pdfPaths,
    String? outputPath,
  }) {
    throw UnimplementedError('mergePdfs() has not been implemented.');
  }

  /// Split a PDF into multiple files
  Future<List<PdfEditResult>> splitPdf({
    required String pdfPath,
    required List<int> pageRanges,
    String? outputDirectory,
  }) {
    throw UnimplementedError('splitPdf() has not been implemented.');
  }

  /// Extract specific pages from a PDF
  Future<PdfEditResult> extractPagesFromPdf({
    required String pdfPath,
    required List<int> pageNumbers,
    String? outputPath,
  }) {
    throw UnimplementedError('extractPagesFromPdf() has not been implemented.');
  }

  /// Rotate pages in a PDF
  Future<PdfEditResult> rotatePdfPages({
    required String pdfPath,
    required Map<int, int> pageRotations, // pageNumber -> rotation angle (90, 180, 270)
    String? outputPath,
  }) {
    throw UnimplementedError('rotatePdfPages() has not been implemented.');
  }

  /// Compress a PDF file
  Future<PdfEditResult> compressPdf({
    required String pdfPath,
    int quality = 80,
    String? outputPath,
  }) {
    throw UnimplementedError('compressPdf() has not been implemented.');
  }

  /// Get PDF information (page count, metadata, etc.)
  Future<Map<String, dynamic>> getPdfInfo({
    required String pdfPath,
  }) {
    throw UnimplementedError('getPdfInfo() has not been implemented.');
  }
}
