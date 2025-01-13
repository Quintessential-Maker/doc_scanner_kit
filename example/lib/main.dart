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
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    // Switch case for handling different actions
    switch (index) {
      case 0:
        scanDocument();
        break;
      case 1:
        scanDocumentAsImages();
        break;
      case 2:
        scanDocumentAsPdf();
        break;
      case 3:
        scanDocumentUri();
        break;
    }
  }
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


  Future<void> scanDocumentAsImages() async {
    dynamic scannedDocuments;
    try {
      scannedDocuments = await DocumentScanner().getScannedDocumentAsImages(page: 4) ??
              'Unknown platform documents';
    } on PlatformException {
      scannedDocuments = 'Failed to get scanned documents.';
    }
    print(scannedDocuments.toString());
    if (!mounted) return;
    setState(() {
      _scannedDocuments = scannedDocuments;
    });
    await Share.shareXFiles([scannedDocuments.path], text: 'Here is my inspection XML request!');
  }

  Future<void> scanDocumentAsPdf() async {
    dynamic scannedDocuments;
    try {
      scannedDocuments = await DocumentScanner().getScannedDocumentAsPdf(page: 4) ?? 'Unknown platform documents';
    } on PlatformException {
      scannedDocuments = 'Failed to get scanned documents.';
    }
    print(scannedDocuments.toString());

    if (!mounted) return;
    setState(() {
      _scannedDocuments = scannedDocuments;
    });
    await Share.shareXFiles(
        [scannedDocuments.path], text: 'Here is my inspection XML request!');
  }

  Future<void> scanDocumentUri() async {
    //This Feature only supported for Android.
    dynamic scannedDocuments;
    try {
      scannedDocuments =
          await DocumentScanner().getScanDocumentsUri(page: 4) ??
              'Unknown platform documents';
    } on PlatformException {
      scannedDocuments = 'Failed to get scanned documents.';
    }
    print(scannedDocuments.toString());
    if (!mounted) return;
    setState(() {
      _scannedDocuments = scannedDocuments;
    });
    await Share.shareXFiles(
        [scannedDocuments.path], text: 'Here is my inspection XML request!');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Document Scanner',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Document Scanner'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _scannedDocuments != null
                    ? Text(_scannedDocuments.toString())
                    : const Text("No Documents Scanned"),

              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.scanner),
              label: 'Scan', backgroundColor: Colors.black54,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.image),
              label: 'Images', backgroundColor: Colors.black54,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.picture_as_pdf),
              label: 'PDF', backgroundColor: Colors.black54,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.link),
              label: 'URI', backgroundColor: Colors.black54,
            ),
          ],
        ),
      ),
    );
  }
}
