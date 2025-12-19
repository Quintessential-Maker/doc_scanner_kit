import 'package:doc_scanner_kit/document_scanner_platform_interface.dart';
import 'package:doc_scanner_kit/models/pdf_edit_options.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';



/// An implementation of [DocumentScannerPlatform] that uses method channels.
class MethodChannelDocumentScanner extends DocumentScannerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('doc_scanner_kit');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<dynamic> getScanDocuments([int page = 1]) async {
    final data = await methodChannel.invokeMethod<dynamic>(
      'getScanDocuments',
      {'page': page},
    );
    return data;
  }

  @override
  Future<dynamic> getScannedDocumentAsImages([int page = 1]) async {
    final data = await methodChannel.invokeMethod<dynamic>(
      'getScannedDocumentAsImages',
      {'page': page},
    );
    return data;
  }

  @override
  Future<dynamic> getScannedDocumentAsPdf([int page = 1]) async {
    final data = await methodChannel.invokeMethod<dynamic>(
      'getScannedDocumentAsPdf',
      {'page': page},
    );
    return data;
  }

  @override
  Future<dynamic> getScanDocumentsUri([int page = 1]) async {
    final data = await methodChannel.invokeMethod<dynamic>(
      'getScanDocumentsUri',
      {'page': page},
    );
    return data;
  }

  // PDF Editing Method Channel Implementations

  @override
  Future<PdfEditResult> editPdf({
    required String pdfPath,
    required PdfEditOptions options,
  }) async {
    final result = await methodChannel.invokeMethod<Map<Object?, Object?>>(
      'editPdf',
      {
        'pdfPath': pdfPath,
        'options': options.toMap(),
      },
    );
    return PdfEditResult.fromMap(Map<String, dynamic>.from(result ?? {}));
  }

  @override
  Future<PdfEditResult> addAnnotationsToPdf({
    required String pdfPath,
    required List<PdfAnnotation> annotations,
    String? outputPath,
  }) async {
    final result = await methodChannel.invokeMethod<Map<Object?, Object?>>(
      'addAnnotationsToPdf',
      {
        'pdfPath': pdfPath,
        'annotations': annotations.map((a) => a.toMap()).toList(),
        'outputPath': outputPath,
      },
    );
    return PdfEditResult.fromMap(Map<String, dynamic>.from(result ?? {}));
  }

  @override
  Future<PdfEditResult> mergePdfs({
    required List<String> pdfPaths,
    String? outputPath,
  }) async {
    final result = await methodChannel.invokeMethod<Map<Object?, Object?>>(
      'mergePdfs',
      {
        'pdfPaths': pdfPaths,
        'outputPath': outputPath,
      },
    );
    return PdfEditResult.fromMap(Map<String, dynamic>.from(result ?? {}));
  }

  @override
  Future<List<PdfEditResult>> splitPdf({
    required String pdfPath,
    required List<int> pageRanges,
    String? outputDirectory,
  }) async {
    final result = await methodChannel.invokeMethod<List<Object?>>(
      'splitPdf',
      {
        'pdfPath': pdfPath,
        'pageRanges': pageRanges,
        'outputDirectory': outputDirectory,
      },
    );
    return (result ?? [])
        .map((r) => PdfEditResult.fromMap(Map<String, dynamic>.from(r as Map)))
        .toList();
  }

  @override
  Future<PdfEditResult> extractPagesFromPdf({
    required String pdfPath,
    required List<int> pageNumbers,
    String? outputPath,
  }) async {
    final result = await methodChannel.invokeMethod<Map<Object?, Object?>>(
      'extractPagesFromPdf',
      {
        'pdfPath': pdfPath,
        'pageNumbers': pageNumbers,
        'outputPath': outputPath,
      },
    );
    return PdfEditResult.fromMap(Map<String, dynamic>.from(result ?? {}));
  }

  @override
  Future<PdfEditResult> rotatePdfPages({
    required String pdfPath,
    required Map<int, int> pageRotations,
    String? outputPath,
  }) async {
    final result = await methodChannel.invokeMethod<Map<Object?, Object?>>(
      'rotatePdfPages',
      {
        'pdfPath': pdfPath,
        'pageRotations': pageRotations,
        'outputPath': outputPath,
      },
    );
    return PdfEditResult.fromMap(Map<String, dynamic>.from(result ?? {}));
  }

  @override
  Future<PdfEditResult> compressPdf({
    required String pdfPath,
    int quality = 80,
    String? outputPath,
  }) async {
    final result = await methodChannel.invokeMethod<Map<Object?, Object?>>(
      'compressPdf',
      {
        'pdfPath': pdfPath,
        'quality': quality,
        'outputPath': outputPath,
      },
    );
    return PdfEditResult.fromMap(Map<String, dynamic>.from(result ?? {}));
  }

  @override
  Future<Map<String, dynamic>> getPdfInfo({
    required String pdfPath,
  }) async {
    final result = await methodChannel.invokeMethod<Map<Object?, Object?>>(
      'getPdfInfo',
      {
        'pdfPath': pdfPath,
      },
    );
    return Map<String, dynamic>.from(result ?? {});
  }
}
