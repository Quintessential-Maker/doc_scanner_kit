import 'dart:io';


import 'package:doc_scanner_kit/document_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(
    MaterialApp(
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  dynamic _scannedDocuments;

  Future<void> scanDocument() async {
    dynamic scannedDocuments;
    try {
      scannedDocuments = await DocumentScanner().getScanDocuments(page: 4) ??
          'Unknown platform documents';
    } on PlatformException {
      scannedDocuments = 'Failed to get scanned documents.';
    }
    print(scannedDocuments.toString());
    if (!mounted) return;
    setState(() {
      _scannedDocuments = scannedDocuments;
    });
    // await sharePDF(scannedDocuments);
    // Extract and share PDF URIs
    if (scannedDocuments is Map) {
      List<String> pdfUris = [];

      scannedDocuments.forEach((key, value) {
        print('Key: $key, Value: $value, Type: ${value.runtimeType}');
      });

      if (scannedDocuments.containsKey('pdfUri')) {
        String pdfUri = scannedDocuments['pdfUri'];
        pdfUris.add(pdfUri);
        print('PDF URI: $pdfUri');
      }


      if (pdfUris.isNotEmpty) {
        await sharePDF(pdfUris);
      } else {
        print('Error: No PDF URIs found in scanned documents.');
      }
    }
  }

  Future<void> sharePDF(List<String> pdfUris) async {
    try {
      if (pdfUris.isNotEmpty) {
        // Assume the first URI in the list is the PDF to share
        String pdfUri = pdfUris.first;

        // Remove the "file://" prefix from the URI
        String filePath = pdfUri.replaceFirst('file://', '');

        // Read the file as bytes
        File pdfFile = File(filePath);
        List<int> pdfBytes = await pdfFile.readAsBytes();

        // Get the directory to save the temporary PDF file
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = '${tempDir.path}/scanned_document.pdf';

        // Write the bytes to a temporary file
        File tempPdfFile = File(tempPath);
        await tempPdfFile.writeAsBytes(pdfBytes);

        // Use share_plus to share the PDF
        await Share.shareXFiles([XFile(tempPdfFile.path)], text: 'Here is the scanned document!');
      } else {
        print('Error: No PDF URIs provided for sharing.');
      }
    } catch (e) {
      print('Error sharing PDF: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Scanner Kit'),
      ),
      body: Stack(
        children: [
          // Center the main content vertically
          Center(
            child: _scannedDocuments != null
                ? Text(_scannedDocuments.toString())
                : const Text("No Documents Scanned"),
          ),

          // Align the button at the bottom center
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20), // Add some bottom padding
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.deepOrange,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(50),
                    ),
                  ),
                ),
                onPressed: scanDocument,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Icon(
                        Icons.scanner,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 5),
                    Flexible(
                      child: FittedBox(
                        child: Text(
                          'Scan',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
