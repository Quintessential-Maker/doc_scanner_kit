# doc_scanner_kit

A Flutter plugin for document scanning on Android and iOS using ML Kit's Document Scanner API and VisionKit. It enables real-time edge detection, auto-cropping, and high-quality image output. Ideal for building mobile scanning solutions.

## Example

Check out the `example` directory for a sample Flutter app using `doc_scanner_kit`.

## Screenshots
| ![Screenshot 1](https://raw.githubusercontent.com/Quintessential-Maker/doc_scanner_kit/main/demo/screen_shot_1.jpg?raw=true) | ![Screenshot 2](https://raw.githubusercontent.com/Quintessential-Maker/doc_scanner_kit/main/demo/screen_shot_2.jpg?raw=true) | ![Screenshot 3](https://raw.githubusercontent.com/Quintessential-Maker/doc_scanner_kit/main/demo/screen_shot_3.jpg?raw=true) |
|----------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------|
| ![Screenshot 4](https://raw.githubusercontent.com/Quintessential-Maker/doc_scanner_kit/main/demo/screen_shot_4.jpg?raw=true) | ![Screenshot 5](https://raw.githubusercontent.com/Quintessential-Maker/doc_scanner_kit/main/demo/screen_shot_5.jpg?raw=true) | ![Screenshot 6](https://raw.githubusercontent.com/Quintessential-Maker/doc_scanner_kit/main/demo/screen_shot_6.jpg?raw=true) |


## Features

### Document Scanning
- High-quality and consistent user interface for digitizing physical documents.
- Accurate document detection with precise corner and edge detection for optimal scanning results.
- Flexible functionality allows users to crop scanned documents, apply filters, remove fingers, remove stains and other blemishes.
- On-device processing helps preserve privacy.
- Support for sending digitized files in PDF and JPEG formats back to your app.
- Ability to set a scan page limit.
- Support for image(png,jpeg) format and PDF has been added through various methods.

### PDF Editing (NEW!)
- **Add Annotations**: Add text, highlights, underlines, and other annotations to PDFs
- **Merge PDFs**: Combine multiple PDF documents into one
- **Split PDFs**: Split a single PDF into multiple files
- **Extract Pages**: Extract specific pages from a PDF
- **Rotate Pages**: Rotate individual pages in a PDF (90°, 180°, 270°)
- **Compress PDFs**: Reduce file size while maintaining quality
- **PDF Information**: Get detailed information about PDF files
- **Custom Annotations**: Support for various annotation types including freehand drawing, shapes, and stamps


## Installation

To use this plugin, add `doc_scanner_kit` as a dependency in your `pubspec.yaml` file.

```yaml
dependencies:
  flutter:
    sdk: flutter
  doc_scanner_kit: ^0.0.10

```
Got it! Here's a more detailed explanation:

## Usage

Use the following function for document scanning on Android and iOS:

```dart
  Future<void> scanDocument() async {
  //by default way they fetch pdf for android and png for iOS
  dynamic scannedDocuments;
  try {
    scannedDocuments = await DocumentScanner().getScanDocuments(page: 3) ??
        'Unknown platform documents';
  } on PlatformException {
    scannedDocuments = 'Failed to get scanned documents.';
  }
  print(scannedDocuments.toString());
}
```
**Note-: If you want to obtain only a PDF scanned document, call getScannedDocumentAsPdf(). Similarly, if you want to get a scanned document in image format, use getScannedDocumentAsImages().**

## PDF Editing Usage

### Adding Annotations to PDFs

```dart
import 'package:doc_scanner_kit/models/pdf_edit_options.dart';

// Add text annotation
final textAnnotation = PdfAnnotation(
  id: 'text_1',
  type: PdfAnnotationType.text,
  pageNumber: 1,
  position: PdfAnnotationPosition(x: 100, y: 100, width: 200, height: 50),
  text: 'Sample Text',
  color: PdfColor.red,
  fontSize: 16,
);

final result = await DocumentScanner().addAnnotationsToPdf(
  pdfPath: '/path/to/your/pdf',
  annotations: [textAnnotation],
);

if (result.success) {
  print('Annotation added successfully!');
  print('Output path: ${result.outputPath}');
}
```

### Merging PDFs

```dart
final result = await DocumentScanner().mergePdfs(
  pdfPaths: ['/path/to/pdf1.pdf', '/path/to/pdf2.pdf'],
  outputPath: '/path/to/merged.pdf',
);

if (result.success) {
  print('PDFs merged successfully!');
}
```

### Splitting PDFs

```dart
final results = await DocumentScanner().splitPdf(
  pdfPath: '/path/to/large.pdf',
  pageRanges: [1, 2, 3], // Split into individual pages
  outputDirectory: '/path/to/output/',
);

for (final result in results) {
  if (result.success) {
    print('Split successful: ${result.outputPath}');
  }
}
```

### Extracting Pages

```dart
final result = await DocumentScanner().extractPagesFromPdf(
  pdfPath: '/path/to/source.pdf',
  pageNumbers: [1, 3, 5], // Extract pages 1, 3, and 5
  outputPath: '/path/to/extracted.pdf',
);
```

### Rotating Pages

```dart
final result = await DocumentScanner().rotatePdfPages(
  pdfPath: '/path/to/pdf',
  pageRotations: {
    1: 90,   // Rotate page 1 by 90 degrees
    2: 180,  // Rotate page 2 by 180 degrees
  },
  outputPath: '/path/to/rotated.pdf',
);
```

### Compressing PDFs

```dart
final result = await DocumentScanner().compressPdf(
  pdfPath: '/path/to/large.pdf',
  quality: 80, // Quality from 1-100
  outputPath: '/path/to/compressed.pdf',
);
```

### Getting PDF Information

```dart
final info = await DocumentScanner().getPdfInfo(
  pdfPath: '/path/to/pdf',
);

print('Page count: ${info['pageCount']}');
print('File size: ${info['fileSize']}');
print('Title: ${info['title']}');
```

### Advanced PDF Editing

```dart
// Create comprehensive edit options
final editOptions = PdfEditOptions(
  outputPath: '/path/to/edited.pdf',
  preserveOriginal: true,
  annotations: [
    PdfAnnotation(
      id: 'highlight_1',
      type: PdfAnnotationType.highlight,
      pageNumber: 1,
      position: PdfAnnotationPosition(x: 50, y: 200, width: 300, height: 20),
      color: PdfColor.yellow,
    ),
    PdfAnnotation(
      id: 'text_1',
      type: PdfAnnotationType.text,
      pageNumber: 1,
      position: PdfAnnotationPosition(x: 100, y: 100, width: 200, height: 50),
      text: 'Important Note',
      color: PdfColor.red,
      fontSize: 14,
    ),
  ],
  compressOutput: true,
  quality: 85,
);

final result = await DocumentScanner().editPdf(
  pdfPath: '/path/to/source.pdf',
  options: editOptions,
);
```

### Annotation Types

The plugin supports various annotation types:

- `PdfAnnotationType.text` - Text annotations
- `PdfAnnotationType.highlight` - Highlight text
- `PdfAnnotationType.underline` - Underline text
- `PdfAnnotationType.strikethrough` - Strikethrough text
- `PdfAnnotationType.freehand` - Freehand drawing
- `PdfAnnotationType.rectangle` - Rectangle shapes
- `PdfAnnotationType.circle` - Circle shapes
- `PdfAnnotationType.arrow` - Arrow annotations
- `PdfAnnotationType.stamp` - Stamp annotations

### Color Support

```dart
// Predefined colors
PdfColor.red
PdfColor.green
PdfColor.blue
PdfColor.yellow
PdfColor.black
PdfColor.white

// Custom RGB colors
PdfColor.fromRgb(255, 128, 0) // Orange

// Hex colors
PdfColor.fromHex('#FF5733')
PdfColor.fromHex('FF5733')
```


## Project Setup
Follow the steps below to set up your Flutter project on Android, iOS, and Web.

### Android

#### Minimum Version Configuration
Ensure you meet the minimum version requirements to run the application on Android devices.
In the `android/app/build.gradle` file, verify that `minSdkVersion` is at least 21. This setting specifies the minimum Android API level required to run your app, ensuring compatibility with a wide range of Android devices.

```gradle
android {
    ...
    defaultConfig {
        ...
        minSdkVersion 21
        ...
    }
    ...
}
```

### iOS
#### Minimum Version Configuration
Ensure you meet the minimum version requirements to run the application on iOS devices.
In the `ios/Podfile` file, make sure the iOS platform version is at least 12.0 or higher. This setting specifies the minimum iOS version required to run your app, ensuring compatibility with a wide range of iOS devices.

```ruby
platform :ios, '12.0'
```

#### Permission Configuration
1. Add a String property to the app's Info.plist file with the key `NSCameraUsageDescription` and the value as the description for why your app needs camera access. This step is required by Apple to explain to users why the app needs access to the camera, and it's crucial for App Store approval.

```ruby
  <key>NSCameraUsageDescription</key>
  <string>Camera Permission Description</string>
```

2. The `permission_handler` dependency used by `doc_scanner_kit` uses macros to control whether a permission is enabled. To enable camera permission, add the following to your `Podfile` file. This step ensures that your app can request and handle camera permissions on iOS devices:

 ```ruby
   post_install do |installer|
     installer.pods_project.targets.each do |target|
       ... # Here are some configurations automatically generated by flutter

       # Start of the permission_handler configuration
       target.build_configurations.each do |config|

         # You can enable the permissions needed here. For example, to enable camera
         # permission, just remove the `#` character in front so it looks like this:
         #
         # ## dart: PermissionGroup.camera
         # 'PERMISSION_CAMERA=1'
         #
         #  Preprocessor definitions can be found at: https://github.com/Baseflow/flutter-permission-handler/blob/master/permission_handler_apple/ios/Classes/PermissionHandlerEnums.h
         config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
           '$(inherited)',

           ## dart: PermissionGroup.camera
           'PERMISSION_CAMERA=1',
         ]

       end
       # End of the permission_handler configuration
     end
   end
   ```


## Issues and Feedback

Please file [issues](https://github.com/Quintessential-Maker/doc_scanner_kit/issues) to send feedback or report a bug. Thank you!

## License

The MIT License (MIT) Copyright (c) 2025 Pallavii Sharrma

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
associated documentation files (the "Software"), to deal in the Software without restriction,
including without limitation the rights to use, copy, modify, merge, publish, distribute,
sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial
portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES
OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
