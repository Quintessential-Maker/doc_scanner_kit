import 'package:doc_scanner_kit/document_scanner.dart';
import 'package:doc_scanner_kit/models/pdf_edit_options.dart';

/// Helper class that provides convenient methods for common PDF editing tasks
class PdfEditHelper {
  static final DocumentScanner _scanner = DocumentScanner();

  /// Add a simple text annotation to a PDF
  static Future<PdfEditResult> addTextAnnotation({
    required String pdfPath,
    required String text,
    required double x,
    required double y,
    required double width,
    required double height,
    int pageNumber = 1,
    PdfColor? color,
    double? fontSize,
    String? outputPath,
  }) async {
    final annotation = PdfAnnotation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: PdfAnnotationType.text,
      pageNumber: pageNumber,
      position: PdfAnnotationPosition(
        x: x,
        y: y,
        width: width,
        height: height,
      ),
      text: text,
      color: color ?? PdfColor.black,
      fontSize: fontSize ?? 12,
    );

    return await _scanner.addAnnotationsToPdf(
      pdfPath: pdfPath,
      annotations: [annotation],
      outputPath: outputPath,
    );
  }

  /// Add a highlight annotation to a PDF
  static Future<PdfEditResult> addHighlight({
    required String pdfPath,
    required double x,
    required double y,
    required double width,
    required double height,
    int pageNumber = 1,
    PdfColor? color,
    String? outputPath,
  }) async {
    final annotation = PdfAnnotation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: PdfAnnotationType.highlight,
      pageNumber: pageNumber,
      position: PdfAnnotationPosition(
        x: x,
        y: y,
        width: width,
        height: height,
      ),
      color: color ?? PdfColor.yellow,
    );

    return await _scanner.addAnnotationsToPdf(
      pdfPath: pdfPath,
      annotations: [annotation],
      outputPath: outputPath,
    );
  }

  /// Add a stamp annotation to a PDF
  static Future<PdfEditResult> addStamp({
    required String pdfPath,
    required String stampText,
    required double x,
    required double y,
    required double width,
    required double height,
    int pageNumber = 1,
    PdfColor? color,
    String? outputPath,
  }) async {
    final annotation = PdfAnnotation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: PdfAnnotationType.stamp,
      pageNumber: pageNumber,
      position: PdfAnnotationPosition(
        x: x,
        y: y,
        width: width,
        height: height,
      ),
      text: stampText,
      color: color ?? PdfColor.reda,
    );

    return await _scanner.addAnnotationsToPdf(
      pdfPath: pdfPath,
      annotations: [annotation],
      outputPath: outputPath,
    );
  }

  /// Create a simple PDF with text annotations
  static Future<PdfEditResult> createAnnotatedPdf({
    required String sourcePdfPath,
    required List<Map<String, dynamic>> annotations,
    String? outputPath,
  }) async {
    final pdfAnnotations = annotations.map((annotation) {
      return PdfAnnotation(
        id: annotation['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
        type: PdfAnnotationType.values.firstWhere(
          (type) => type.name == annotation['type'],
          orElse: () => PdfAnnotationType.text,
        ),
        pageNumber: annotation['pageNumber'] ?? 1,
        position: PdfAnnotationPosition(
          x: annotation['x']?.toDouble() ?? 0.0,
          y: annotation['y']?.toDouble() ?? 0.0,
          width: annotation['width']?.toDouble() ?? 100.0,
          height: annotation['height']?.toDouble() ?? 20.0,
        ),
        text: annotation['text'],
        color: annotation['color'] != null
            ? PdfColor.fromHex(annotation['color'])
            : PdfColor.black,
        fontSize: annotation['fontSize']?.toDouble(),
      );
    }).toList();

    return await _scanner.addAnnotationsToPdf(
      pdfPath: sourcePdfPath,
      annotations: pdfAnnotations,
      outputPath: outputPath,
    );
  }

  /// Quick merge multiple PDFs
  static Future<PdfEditResult> quickMerge({
    required List<String> pdfPaths,
    String? outputPath,
  }) async {
    return await _scanner.mergePdfs(
      pdfPaths: pdfPaths,
      outputPath: outputPath,
    );
  }

  /// Quick compress a PDF
  static Future<PdfEditResult> quickCompress({
    required String pdfPath,
    int quality = 80,
    String? outputPath,
  }) async {
    return await _scanner.compressPdf(
      pdfPath: pdfPath,
      quality: quality,
      outputPath: outputPath,
    );
  }

  /// Get basic PDF information
  static Future<Map<String, dynamic>> getBasicInfo({
    required String pdfPath,
  }) async {
    return await _scanner.getPdfInfo(pdfPath: pdfPath);
  }

  /// Check if PDF editing is supported
  static bool isPdfEditingSupported() {
    // This can be extended to check platform-specific capabilities
    return true;
  }

  /// Create a watermark annotation
  static Future<PdfEditResult> addWatermark({
    required String pdfPath,
    required String watermarkText,
    int pageNumber = 1,
    PdfColor? color,
    String? outputPath,
  }) async {
    final annotation = PdfAnnotation(
      id: 'watermark_${DateTime.now().millisecondsSinceEpoch}',
      type: PdfAnnotationType.text,
      pageNumber: pageNumber,
      position: const PdfAnnotationPosition(
        x: 200,
        y: 300,
        width: 200,
        height: 50,
      ),
      text: watermarkText,
      color: color ?? PdfColor.fromRgb(200, 200, 200, alpha: 0.5),
      fontSize: 24,
    );

    return await _scanner.addAnnotationsToPdf(
      pdfPath: pdfPath,
      annotations: [annotation],
      outputPath: outputPath,
    );
  }
}
