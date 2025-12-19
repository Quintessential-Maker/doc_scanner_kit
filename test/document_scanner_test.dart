import 'package:doc_scanner_kit/document_scanner.dart';
import 'package:doc_scanner_kit/document_scanner_method_channel.dart';
import 'package:doc_scanner_kit/document_scanner_platform_interface.dart';
import 'package:doc_scanner_kit/models/pdf_edit_options.dart';
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

  // PDF Editing method implementations
  @override
  Future<PdfEditResult> editPdf({
    required String pdfPath,
    required PdfEditOptions options,
  }) => Future.value(PdfEditResult(success: true, outputPath: pdfPath));

  @override
  Future<PdfEditResult> addAnnotationsToPdf({
    required String pdfPath,
    required List<PdfAnnotation> annotations,
    String? outputPath,
  }) => Future.value(PdfEditResult(success: true, outputPath: outputPath ?? pdfPath));

  @override
  Future<PdfEditResult> mergePdfs({
    required List<String> pdfPaths,
    String? outputPath,
  }) => Future.value(PdfEditResult(success: true, outputPath: outputPath ?? 'merged.pdf'));

  @override
  Future<List<PdfEditResult>> splitPdf({
    required String pdfPath,
    required List<int> pageRanges,
    String? outputDirectory,
  }) => Future.value([
    PdfEditResult(success: true, outputPath: 'split_1.pdf'),
    PdfEditResult(success: true, outputPath: 'split_2.pdf'),
  ]);

  @override
  Future<PdfEditResult> extractPagesFromPdf({
    required String pdfPath,
    required List<int> pageNumbers,
    String? outputPath,
  }) => Future.value(PdfEditResult(success: true, outputPath: outputPath ?? 'extracted.pdf'));

  @override
  Future<PdfEditResult> rotatePdfPages({
    required String pdfPath,
    required Map<int, int> pageRotations,
    String? outputPath,
  }) => Future.value(PdfEditResult(success: true, outputPath: outputPath ?? pdfPath));

  @override
  Future<PdfEditResult> compressPdf({
    required String pdfPath,
    int quality = 80,
    String? outputPath,
  }) => Future.value(PdfEditResult(success: true, outputPath: outputPath ?? pdfPath));

  @override
  Future<Map<String, dynamic>> getPdfInfo({
    required String pdfPath,
  }) => Future.value({
    'pageCount': 1,
    'fileSize': 1024,
    'title': 'Test PDF',
  });
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
