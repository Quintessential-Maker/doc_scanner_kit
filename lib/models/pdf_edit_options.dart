import 'dart:typed_data';
import 'dart:ui';

/// Represents different types of annotations that can be added to a PDF
enum PdfAnnotationType {
  text,
  highlight,
  underline,
  strikethrough,
  freehand,
  rectangle,
  circle,
  arrow,
  stamp,
}

/// Represents the position and size of an annotation on a PDF page
class PdfAnnotationPosition {
  final double x;
  final double y;
  final double width;
  final double height;

  const PdfAnnotationPosition({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  Map<String, dynamic> toMap() {
    return {
      'x': x,
      'y': y,
      'width': width,
      'height': height,
    };
  }

  factory PdfAnnotationPosition.fromMap(Map<String, dynamic> map) {
    return PdfAnnotationPosition(
      x: map['x']?.toDouble() ?? 0.0,
      y: map['y']?.toDouble() ?? 0.0,
      width: map['width']?.toDouble() ?? 0.0,
      height: map['height']?.toDouble() ?? 0.0,
    );
  }
}

/// Represents a color for PDF annotations
class PdfColor {
  final double red;
  final double green;
  final double blue;
  final double alpha;

  const PdfColor({
    required this.red,
    required this.green,
    required this.blue,
    this.alpha = 1.0,
  });

  /// Create a color from RGB values (0-255)
  factory PdfColor.fromRgb(int red, int green, int blue, {double alpha = 1.0}) {
    return PdfColor(
      red: red / 255.0,
      green: green / 255.0,
      blue: blue / 255.0,
      alpha: alpha,
    );
  }

  /// Create a color from hex string (e.g., "#FF0000" or "FF0000")
  factory PdfColor.fromHex(String hex) {
    String cleanHex = hex.replaceAll('#', '');
    if (cleanHex.length == 6) {
      return PdfColor(
        red: int.parse(cleanHex.substring(0, 2), radix: 16) / 255.0,
        green: int.parse(cleanHex.substring(2, 4), radix: 16) / 255.0,
        blue: int.parse(cleanHex.substring(4, 6), radix: 16) / 255.0,
      );
    }
    throw ArgumentError('Invalid hex color format: $hex');
  }

  Map<String, dynamic> toMap() {
    return {
      'red': red,
      'green': green,
      'blue': blue,
      'alpha': alpha,
    };
  }

  factory PdfColor.fromMap(Map<String, dynamic> map) {
    return PdfColor(
      red: map['red']?.toDouble() ?? 0.0,
      green: map['green']?.toDouble() ?? 0.0,
      blue: map['blue']?.toDouble() ?? 0.0,
      alpha: map['alpha']?.toDouble() ?? 1.0,
    );
  }

  // Common colors
  static final PdfColor reda = PdfColor.fromRgb(255, 0, 0);
  static final PdfColor greena = PdfColor.fromRgb(0, 255, 0);
  static final PdfColor bluea = PdfColor.fromRgb(0, 0, 255);
  static final PdfColor yellow = PdfColor.fromRgb(255, 255, 0);
  static final PdfColor black = PdfColor.fromRgb(0, 0, 0);
  static final PdfColor white = PdfColor.fromRgb(255, 255, 255);
}

/// Represents an annotation to be added to a PDF
class PdfAnnotation {
  final String id;
  final PdfAnnotationType type;
  final int pageNumber;
  final PdfAnnotationPosition position;
  final String? text;
  final PdfColor? color;
  final double? fontSize;
  final String? fontFamily;
  final List<Offset>? freehandPoints;
  final Uint8List? imageData;
  final Map<String, dynamic>? customProperties;

  const PdfAnnotation({
    required this.id,
    required this.type,
    required this.pageNumber,
    required this.position,
    this.text,
    this.color,
    this.fontSize,
    this.fontFamily,
    this.freehandPoints,
    this.imageData,
    this.customProperties,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.name,
      'pageNumber': pageNumber,
      'position': position.toMap(),
      'text': text,
      'color': color?.toMap(),
      'fontSize': fontSize,
      'fontFamily': fontFamily,
      'freehandPoints': freehandPoints?.map((p) => p != null ? {'x': p.dx, 'y': p.dy} : null).toList(),
      'imageData': imageData,
      'customProperties': customProperties,
    };
  }

  factory PdfAnnotation.fromMap(Map<String, dynamic> map) {
    return PdfAnnotation(
      id: map['id'] ?? '',
      type: PdfAnnotationType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => PdfAnnotationType.text,
      ),
      pageNumber: map['pageNumber'] ?? 0,
      position: PdfAnnotationPosition.fromMap(map['position'] ?? {}),
      text: map['text'],
      color: map['color'] != null ? PdfColor.fromMap(map['color']) : null,
      fontSize: map['fontSize']?.toDouble(),
      fontFamily: map['fontFamily'],
      freehandPoints: map['freehandPoints'] != null
          ? (map['freehandPoints'] as List)
              .where((p) => p != null)
              .map((p) => Offset(p['x']?.toDouble() ?? 0.0, p['y']?.toDouble() ?? 0.0))
              .toList()
          : null,
      imageData: map['imageData'],
      customProperties: map['customProperties'],
    );
  }
}

/// Represents options for editing a PDF
class PdfEditOptions {
  final String? outputPath;
  final bool preserveOriginal;
  final List<PdfAnnotation> annotations;
  final Map<String, dynamic>? metadata;
  final bool compressOutput;
  final int? quality;

  const PdfEditOptions({
    this.outputPath,
    this.preserveOriginal = true,
    this.annotations = const [],
    this.metadata,
    this.compressOutput = false,
    this.quality,
  });

  Map<String, dynamic> toMap() {
    return {
      'outputPath': outputPath,
      'preserveOriginal': preserveOriginal,
      'annotations': annotations.map((a) => a.toMap()).toList(),
      'metadata': metadata,
      'compressOutput': compressOutput,
      'quality': quality,
    };
  }

  factory PdfEditOptions.fromMap(Map<String, dynamic> map) {
    return PdfEditOptions(
      outputPath: map['outputPath'],
      preserveOriginal: map['preserveOriginal'] ?? true,
      annotations: (map['annotations'] as List?)
              ?.map((a) => PdfAnnotation.fromMap(a))
              .toList() ??
          [],
      metadata: map['metadata'],
      compressOutput: map['compressOutput'] ?? false,
      quality: map['quality'],
    );
  }
}

/// Represents the result of a PDF editing operation
class PdfEditResult {
  final bool success;
  final String? outputPath;
  final String? errorMessage;
  final Map<String, dynamic>? metadata;

  const PdfEditResult({
    required this.success,
    this.outputPath,
    this.errorMessage,
    this.metadata,
  });

  Map<String, dynamic> toMap() {
    return {
      'success': success,
      'outputPath': outputPath,
      'errorMessage': errorMessage,
      'metadata': metadata,
    };
  }

  factory PdfEditResult.fromMap(Map<String, dynamic> map) {
    return PdfEditResult(
      success: map['success'] ?? false,
      outputPath: map['outputPath'],
      errorMessage: map['errorMessage'],
      metadata: map['metadata'],
    );
  }
}
