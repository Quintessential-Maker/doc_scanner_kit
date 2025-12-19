import 'dart:io';
import 'package:doc_scanner_kit/document_scanner.dart';
import 'package:doc_scanner_kit/models/pdf_edit_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'home_page.dart';

class PdfEditorPage extends StatefulWidget {
  final PdfDocument pdfDocument;
  final Function(PdfDocument) onPdfUpdated;

  const PdfEditorPage({
    Key? key,
    required this.pdfDocument,
    required this.onPdfUpdated,
  }) : super(key: key);

  @override
  State<PdfEditorPage> createState() => _PdfEditorPageState();
}

class _PdfEditorPageState extends State<PdfEditorPage> {
  List<PdfAnnotation> _annotations = [];
  bool _isLoading = false;
  String _currentPdfPath = '';
  int _currentPageCount = 1;
  int _currentPageIndex = 0;
  List<String> _allPages = [];

  @override
  void initState() {
    super.initState();
    _currentPdfPath = widget.pdfDocument.path;
    _getPdfInfo();
    _loadAllPages();
  }

  Future<void> _loadAllPages() async {
    try {
      // For now, we'll simulate having multiple pages
      // In a real implementation, you would extract individual pages from the PDF
      setState(() {
        _allPages = List.generate(_currentPageCount, (index) => 'Page ${index + 1}');
      });
    } catch (e) {
      print('Error loading pages: $e');
    }
  }

  Future<void> _getPdfInfo() async {
    try {
      final info = await DocumentScanner().getPdfInfo(pdfPath: _currentPdfPath);
      setState(() {
        _currentPageCount = info['pageCount'] ?? 1;
      });
      _loadAllPages(); // Reload pages when info is updated
    } catch (e) {
      print('Error getting PDF info: $e');
    }
  }

  Future<void> _addNewPage() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Scan a new page
      final scannedDocuments = await DocumentScanner().getScanDocuments(page: 1);
      
      if (scannedDocuments != null && scannedDocuments is Map) {
        if (scannedDocuments.containsKey('pdfUri')) {
          String newPageUri = scannedDocuments['pdfUri'];
          String newPagePath = newPageUri.replaceFirst('file://', '');
          
          // Merge the new page with existing PDF
          final result = await DocumentScanner().mergePdfs(
            pdfPaths: [_currentPdfPath, newPagePath],
            outputPath: _currentPdfPath,
          );
          
          if (result.success) {
            setState(() {
              _currentPageCount++;
              _currentPageIndex = _currentPageCount - 1; // Go to the new page
            });
            _loadAllPages(); // Reload all pages
            _showSnackBar('New page added successfully!');
            _getPdfInfo(); // Refresh page count
          } else {
            _showSnackBar('Failed to add page: ${result.errorMessage}');
          }
        }
      }
    } catch (e) {
      _showSnackBar('Error adding new page: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addTextAnnotation() async {
    final annotation = PdfAnnotation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: PdfAnnotationType.text,
      pageNumber: 1,
      position: const PdfAnnotationPosition(x: 100, y: 100, width: 200, height: 50),
      text: 'Sample Text Annotation',
      color: PdfColor.reda,
      fontSize: 16,
    );

    setState(() {
      _annotations.add(annotation);
    });

    try {
      final result = await DocumentScanner().addAnnotationsToPdf(
        pdfPath: _currentPdfPath,
        annotations: [annotation],
      );

      if (result.success) {
        _showSnackBar('Text annotation added successfully!');
        setState(() {
          _currentPdfPath = result.outputPath ?? _currentPdfPath;
        });
      } else {
        _showSnackBar('Failed to add annotation: ${result.errorMessage}');
      }
    } catch (e) {
      _showSnackBar('Error adding annotation: $e');
    }
  }

  Future<void> _addHighlight() async {
    final annotation = PdfAnnotation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: PdfAnnotationType.highlight,
      pageNumber: 1,
      position: const PdfAnnotationPosition(x: 50, y: 200, width: 300, height: 20),
      color: PdfColor.yellow,
    );

    setState(() {
      _annotations.add(annotation);
    });

    try {
      final result = await DocumentScanner().addAnnotationsToPdf(
        pdfPath: _currentPdfPath,
        annotations: [annotation],
      );

      if (result.success) {
        _showSnackBar('Highlight added successfully!');
        setState(() {
          _currentPdfPath = result.outputPath ?? _currentPdfPath;
        });
      } else {
        _showSnackBar('Failed to add highlight: ${result.errorMessage}');
      }
    } catch (e) {
      _showSnackBar('Error adding highlight: $e');
    }
  }

  Future<void> _addStamp() async {
    final annotation = PdfAnnotation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: PdfAnnotationType.stamp,
      pageNumber: 1,
      position: const PdfAnnotationPosition(x: 200, y: 300, width: 100, height: 50),
      text: 'APPROVED',
      color: PdfColor.greena,
    );

    setState(() {
      _annotations.add(annotation);
    });

    try {
      final result = await DocumentScanner().addAnnotationsToPdf(
        pdfPath: _currentPdfPath,
        annotations: [annotation],
      );

      if (result.success) {
        _showSnackBar('Stamp added successfully!');
        setState(() {
          _currentPdfPath = result.outputPath ?? _currentPdfPath;
        });
      } else {
        _showSnackBar('Failed to add stamp: ${result.errorMessage}');
      }
    } catch (e) {
      _showSnackBar('Error adding stamp: $e');
    }
  }

  Future<void> _compressPdf() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await DocumentScanner().compressPdf(
        pdfPath: _currentPdfPath,
        quality: 80,
      );

      if (result.success) {
        _showSnackBar('PDF compressed successfully!');
        setState(() {
          _currentPdfPath = result.outputPath ?? _currentPdfPath;
        });
      } else {
        _showSnackBar('Failed to compress PDF: ${result.errorMessage}');
      }
    } catch (e) {
      _showSnackBar('Error compressing PDF: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _sharePdf() async {
    try {
      final file = File(_currentPdfPath);
      if (await file.exists()) {
        await Share.shareXFiles([XFile(file.path)], text: 'Here is the edited document!');
      }
    } catch (e) {
      _showSnackBar('Error sharing PDF: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _goToPreviousPage() {
    if (_currentPageIndex > 0) {
      setState(() {
        _currentPageIndex--;
      });
    }
  }

  void _goToNextPage() {
    if (_currentPageIndex < _currentPageCount - 1) {
      setState(() {
        _currentPageIndex++;
      });
    }
  }

  void _goToPage(int pageIndex) {
    if (pageIndex >= 0 && pageIndex < _currentPageCount) {
      setState(() {
        _currentPageIndex = pageIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pdfDocument.name),
        backgroundColor: Colors.deepOrange,
        actions: [
          IconButton(
            onPressed: _sharePdf,
            icon: const Icon(Icons.share),
            tooltip: 'Share PDF',
          ),
        ],
      ),
      body: Column(
        children: [
          // PDF Info Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Row(
              children: [
                const Icon(Icons.picture_as_pdf, color: Colors.red, size: 30),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.pdfDocument.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Pages: $_currentPageCount | Annotations: ${_annotations.length}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                if (_isLoading)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
          ),

          // PDF Preview Area
          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                children: [
                  // Page Navigation Header
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Previous Page Button
                        IconButton(
                          onPressed: _currentPageIndex > 0 ? _goToPreviousPage : null,
                          icon: const Icon(Icons.chevron_left),
                          style: IconButton.styleFrom(
                            backgroundColor: _currentPageIndex > 0 ? Colors.blue : Colors.grey[300],
                            foregroundColor: Colors.white,
                          ),
                        ),
                        
                        // Page Info
                        Column(
                          children: [
                            Text(
                              'Page ${_currentPageIndex + 1} of $_currentPageCount',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            if (_annotations.isNotEmpty)
                              Text(
                                '${_annotations.length} annotations',
                                style: TextStyle(
                                  color: Colors.blue[600],
                                  fontSize: 12,
                                ),
                              ),
                          ],
                        ),
                        
                        // Next Page Button
                        IconButton(
                          onPressed: _currentPageIndex < _currentPageCount - 1 ? _goToNextPage : null,
                          icon: const Icon(Icons.chevron_right),
                          style: IconButton.styleFrom(
                            backgroundColor: _currentPageIndex < _currentPageCount - 1 ? Colors.blue : Colors.grey[300],
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // PDF Page Preview
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Page Preview
                          Container(
                            width: double.infinity,
                            height: 300,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey[400]!),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.picture_as_pdf,
                                  size: 60,
                                  color: Colors.red,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  _allPages.isNotEmpty ? _allPages[_currentPageIndex] : 'Page ${_currentPageIndex + 1}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'PDF Content Preview',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Page Thumbnails
                          if (_currentPageCount > 1) ...[
                            Text(
                              'All Pages',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 60,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _currentPageCount,
                                itemBuilder: (context, index) {
                                  final isSelected = index == _currentPageIndex;
                                  return GestureDetector(
                                    onTap: () => _goToPage(index),
                                    child: Container(
                                      width: 50,
                                      height: 60,
                                      margin: const EdgeInsets.symmetric(horizontal: 4),
                                      decoration: BoxDecoration(
                                        color: isSelected ? Colors.blue[100] : Colors.white,
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                          color: isSelected ? Colors.blue : Colors.grey[300]!,
                                          width: isSelected ? 2 : 1,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.picture_as_pdf,
                                            size: 20,
                                            color: isSelected ? Colors.blue : Colors.grey[600],
                                          ),
                                          Text(
                                            '${index + 1}',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: isSelected ? Colors.blue : Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Action Buttons
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Add New Page Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _addNewPage,
                    icon: const Icon(Icons.add),
                    label: const Text('Add New Page'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Annotation Tools
                Text(
                  'Annotation Tools',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildToolButton(
                      'Text',
                      Icons.text_fields,
                      Colors.blue,
                      _addTextAnnotation,
                    ),
                    _buildToolButton(
                      'Highlight',
                      Icons.highlight,
                      Colors.yellow,
                      _addHighlight,
                    ),
                    _buildToolButton(
                      'Stamp',
                      Icons.verified,
                      Colors.green,
                      _addStamp,
                    ),
                    _buildToolButton(
                      'Compress',
                      Icons.compress_outlined,
                      Colors.orange,
                      _compressPdf,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolButton(String label, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: _isLoading ? null : onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  @override
  void dispose() {
    // Update the PDF document when leaving the editor
    final updatedPdf = PdfDocument(
      name: widget.pdfDocument.name,
      path: _currentPdfPath,
      dateCreated: widget.pdfDocument.dateCreated,
    );
    widget.onPdfUpdated(updatedPdf);
    super.dispose();
  }
}
