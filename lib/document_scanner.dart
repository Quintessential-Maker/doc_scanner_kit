import 'package:doc_scanner_kit/document_scanner_platform_interface.dart';
import 'package:doc_scanner_kit/models/pdf_edit_options.dart';
import 'package:flutter/foundation.dart';


class DocumentScanner {
  Future<String?> getPlatformVersion() {
    return DocumentScannerPlatform.instance.getPlatformVersion();
  }

  Future<dynamic> getScanDocuments({int page = 4}) {
    return DocumentScannerPlatform.instance.getScanDocuments(page);
  }

  Future<dynamic> getScannedDocumentAsImages({int page = 4}) {
    return DocumentScannerPlatform.instance.getScannedDocumentAsImages(page);
  }

  Future<dynamic> getScannedDocumentAsPdf({int page = 4}) {
    return DocumentScannerPlatform.instance.getScannedDocumentAsPdf(page);
  }

  Future<dynamic> getScanDocumentsUri({int page = 4}) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return DocumentScannerPlatform.instance.getScanDocumentsUri(page);
    } else {
      return Future.error(
          "Currently, this feature is supported only on Android Platform");
    }
  }

  // PDF Editing Methods

  /// Edit a PDF file with annotations and modifications
  Future<PdfEditResult> editPdf({
    required String pdfPath,
    required PdfEditOptions options,
  }) {
    return DocumentScannerPlatform.instance.editPdf(
      pdfPath: pdfPath,
      options: options,
    );
  }

  /// Add annotations to an existing PDF
  Future<PdfEditResult> addAnnotationsToPdf({
    required String pdfPath,
    required List<PdfAnnotation> annotations,
    String? outputPath,
  }) {
    return DocumentScannerPlatform.instance.addAnnotationsToPdf(
      pdfPath: pdfPath,
      annotations: annotations,
      outputPath: outputPath,
    );
  }

  /// Merge multiple PDFs into one
  Future<PdfEditResult> mergePdfs({
    required List<String> pdfPaths,
    String? outputPath,
  }) {
    return DocumentScannerPlatform.instance.mergePdfs(
      pdfPaths: pdfPaths,
      outputPath: outputPath,
    );
  }

  /// Split a PDF into multiple files
  Future<List<PdfEditResult>> splitPdf({
    required String pdfPath,
    required List<int> pageRanges,
    String? outputDirectory,
  }) {
    return DocumentScannerPlatform.instance.splitPdf(
      pdfPath: pdfPath,
      pageRanges: pageRanges,
      outputDirectory: outputDirectory,
    );
  }

  /// Extract specific pages from a PDF
  Future<PdfEditResult> extractPagesFromPdf({
    required String pdfPath,
    required List<int> pageNumbers,
    String? outputPath,
  }) {
    return DocumentScannerPlatform.instance.extractPagesFromPdf(
      pdfPath: pdfPath,
      pageNumbers: pageNumbers,
      outputPath: outputPath,
    );
  }

  /// Rotate pages in a PDF
  Future<PdfEditResult> rotatePdfPages({
    required String pdfPath,
    required Map<int, int> pageRotations, // pageNumber -> rotation angle (90, 180, 270)
    String? outputPath,
  }) {
    return DocumentScannerPlatform.instance.rotatePdfPages(
      pdfPath: pdfPath,
      pageRotations: pageRotations,
      outputPath: outputPath,
    );
  }

  /// Compress a PDF file
  Future<PdfEditResult> compressPdf({
    required String pdfPath,
    int quality = 80,
    String? outputPath,
  }) {
    return DocumentScannerPlatform.instance.compressPdf(
      pdfPath: pdfPath,
      quality: quality,
      outputPath: outputPath,
    );
  }

  /// Get PDF information (page count, metadata, etc.)
  Future<Map<String, dynamic>> getPdfInfo({
    required String pdfPath,
  }) {
    return DocumentScannerPlatform.instance.getPdfInfo(
      pdfPath: pdfPath,
    );
  }
}
