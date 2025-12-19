import 'dart:io';
import 'package:doc_scanner_kit/document_scanner.dart';
import 'package:doc_scanner_kit/models/pdf_edit_options.dart';
import 'package:doc_scanner_kit/utils/pdf_edit_helper.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// Comprehensive example demonstrating PDF editing capabilities
class PdfEditingExample extends StatefulWidget {
  const PdfEditingExample({Key? key}) : super(key: key);

  @override
  State<PdfEditingExample> createState() => _PdfEditingExampleState();
}

class _PdfEditingExampleState extends State<PdfEditingExample> {
  String? _currentPdfPath;
  List<PdfAnnotation> _annotations = [];
  bool _isLoading = false;
  String _statusMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Editing Examples'),
        backgroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status display
            if (_statusMessage.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  border: Border.all(color: Colors.blue[200]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _statusMessage,
                  style: const TextStyle(color: Colors.blue),
                ),
              ),

            // PDF Info Section
            _buildSection(
              'PDF Information',
              Icons.info,
              [
                _buildButton(
                  'Load Sample PDF',
                  Icons.upload_file,
                  _loadSamplePdf,
                ),
                if (_currentPdfPath != null) ...[
                  _buildButton(
                    'Get PDF Info',
                    Icons.info_outline,
                    _getPdfInfo,
                  ),
                  _buildButton(
                    'Compress PDF',
                    Icons.compress_outlined,
                    _compressPdf,
                  ),
                ],
              ],
            ),

            // Annotation Section
            _buildSection(
              'Annotations',
              Icons.edit,
              [
                _buildButton(
                  'Add Text Annotation',
                  Icons.text_fields,
                  _addTextAnnotation,
                ),
                _buildButton(
                  'Add Highlight',
                  Icons.highlight,
                  _addHighlight,
                ),
                      _buildButton(
                        'Add Stamp',
                        Icons.verified,
                        _addStamp,
                      ),
                _buildButton(
                  'Add Watermark',
                  Icons.water,
                  _addWatermark,
                ),
              ],
            ),

            // PDF Operations Section
            _buildSection(
              'PDF Operations',
              Icons.transform,
              [
                _buildButton(
                  'Rotate Pages',
                  Icons.rotate_right,
                  _rotatePages,
                ),
                _buildButton(
                  'Extract Pages',
                  Icons.content_cut,
                  _extractPages,
                ),
                _buildButton(
                  'Split PDF',
                  Icons.call_split,
                  _splitPdf,
                ),
              ],
            ),

            // Advanced Operations Section
            _buildSection(
              'Advanced Operations',
              Icons.settings,
              [
                _buildButton(
                  'Create Annotated PDF',
                  Icons.create,
                  _createAnnotatedPdf,
                ),
                _buildButton(
                  'Batch Operations',
                  Icons.batch_prediction,
                  _batchOperations,
                ),
              ],
            ),

            // Current PDF Path Display
            if (_currentPdfPath != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(top: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Current PDF:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _currentPdfPath!,
                      style: const TextStyle(fontSize: 12),
                    ),
                    if (_annotations.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Annotations: ${_annotations.length}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ],
                ),
              ),

            // Loading indicator
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.deepOrange),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: children,
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String label, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: _isLoading ? null : onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  void _setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  void _setStatus(String message) {
    setState(() {
      _statusMessage = message;
    });
  }

  // PDF Operations
  Future<void> _loadSamplePdf() async {
    _setLoading(true);
    try {
      // In a real app, you would load an actual PDF file
      // For demo purposes, we'll simulate this
      final directory = await getApplicationDocumentsDirectory();
      final samplePath = '${directory.path}/sample.pdf';
      
      setState(() {
        _currentPdfPath = samplePath;
      });
      
      _setStatus('Sample PDF loaded successfully!');
    } catch (e) {
      _setStatus('Error loading PDF: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _getPdfInfo() async {
    if (_currentPdfPath == null) {
      _setStatus('Please load a PDF first');
      return;
    }

    _setLoading(true);
    try {
      final info = await PdfEditHelper.getBasicInfo(pdfPath: _currentPdfPath!);
      _setStatus('PDF Info: ${info.toString()}');
    } catch (e) {
      _setStatus('Error getting PDF info: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _compressPdf() async {
    if (_currentPdfPath == null) {
      _setStatus('Please load a PDF first');
      return;
    }

    _setLoading(true);
    try {
      final result = await PdfEditHelper.quickCompress(
        pdfPath: _currentPdfPath!,
        quality: 80,
      );

      if (result.success) {
        setState(() {
          _currentPdfPath = result.outputPath ?? _currentPdfPath;
        });
        _setStatus('PDF compressed successfully!');
      } else {
        _setStatus('Failed to compress PDF: ${result.errorMessage}');
      }
    } catch (e) {
      _setStatus('Error compressing PDF: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Annotation Operations
  Future<void> _addTextAnnotation() async {
    if (_currentPdfPath == null) {
      _setStatus('Please load a PDF first');
      return;
    }

    _setLoading(true);
    try {
      final result = await PdfEditHelper.addTextAnnotation(
        pdfPath: _currentPdfPath!,
        text: 'Sample Text Annotation',
        x: 100,
        y: 100,
        width: 200,
        height: 50,
            color: PdfColor.reda,
        fontSize: 16,
      );

      if (result.success) {
        setState(() {
          _currentPdfPath = result.outputPath ?? _currentPdfPath;
          _annotations.add(PdfAnnotation(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            type: PdfAnnotationType.text,
            pageNumber: 1,
            position: const PdfAnnotationPosition(x: 100, y: 100, width: 200, height: 50),
            text: 'Sample Text Annotation',
            color: PdfColor.reda,
            fontSize: 16,
          ));
        });
        _setStatus('Text annotation added successfully!');
      } else {
        _setStatus('Failed to add text annotation: ${result.errorMessage}');
      }
    } catch (e) {
      _setStatus('Error adding text annotation: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _addHighlight() async {
    if (_currentPdfPath == null) {
      _setStatus('Please load a PDF first');
      return;
    }

    _setLoading(true);
    try {
      final result = await PdfEditHelper.addHighlight(
        pdfPath: _currentPdfPath!,
        x: 50,
        y: 200,
        width: 300,
        height: 20,
        color: PdfColor.yellow,
      );

      if (result.success) {
        setState(() {
          _currentPdfPath = result.outputPath ?? _currentPdfPath;
          _annotations.add(PdfAnnotation(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            type: PdfAnnotationType.highlight,
            pageNumber: 1,
            position: const PdfAnnotationPosition(x: 50, y: 200, width: 300, height: 20),
            color: PdfColor.yellow,
          ));
        });
        _setStatus('Highlight added successfully!');
      } else {
        _setStatus('Failed to add highlight: ${result.errorMessage}');
      }
    } catch (e) {
      _setStatus('Error adding highlight: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _addStamp() async {
    if (_currentPdfPath == null) {
      _setStatus('Please load a PDF first');
      return;
    }

    _setLoading(true);
    try {
      final result = await PdfEditHelper.addStamp(
        pdfPath: _currentPdfPath!,
        stampText: 'APPROVED',
        x: 200,
        y: 300,
        width: 100,
        height: 50,
        color: PdfColor.greena,
      );

      if (result.success) {
        setState(() {
          _currentPdfPath = result.outputPath ?? _currentPdfPath;
          _annotations.add(PdfAnnotation(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            type: PdfAnnotationType.stamp,
            pageNumber: 1,
            position: const PdfAnnotationPosition(x: 200, y: 300, width: 100, height: 50),
            text: 'APPROVED',
            color: PdfColor.greena,
          ));
        });
        _setStatus('Stamp added successfully!');
      } else {
        _setStatus('Failed to add stamp: ${result.errorMessage}');
      }
    } catch (e) {
      _setStatus('Error adding stamp: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _addWatermark() async {
    if (_currentPdfPath == null) {
      _setStatus('Please load a PDF first');
      return;
    }

    _setLoading(true);
    try {
      final result = await PdfEditHelper.addWatermark(
        pdfPath: _currentPdfPath!,
        watermarkText: 'CONFIDENTIAL',
        color: PdfColor.fromRgb(200, 200, 200, alpha: 0.5),
      );

      if (result.success) {
        setState(() {
          _currentPdfPath = result.outputPath ?? _currentPdfPath;
        });
        _setStatus('Watermark added successfully!');
      } else {
        _setStatus('Failed to add watermark: ${result.errorMessage}');
      }
    } catch (e) {
      _setStatus('Error adding watermark: $e');
    } finally {
      _setLoading(false);
    }
  }

  // PDF Operations
  Future<void> _rotatePages() async {
    if (_currentPdfPath == null) {
      _setStatus('Please load a PDF first');
      return;
    }

    _setLoading(true);
    try {
      final result = await DocumentScanner().rotatePdfPages(
        pdfPath: _currentPdfPath!,
        pageRotations: {1: 90}, // Rotate first page by 90 degrees
      );

      if (result.success) {
        setState(() {
          _currentPdfPath = result.outputPath ?? _currentPdfPath;
        });
        _setStatus('Pages rotated successfully!');
      } else {
        _setStatus('Failed to rotate pages: ${result.errorMessage}');
      }
    } catch (e) {
      _setStatus('Error rotating pages: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _extractPages() async {
    if (_currentPdfPath == null) {
      _setStatus('Please load a PDF first');
      return;
    }

    _setLoading(true);
    try {
      final result = await DocumentScanner().extractPagesFromPdf(
        pdfPath: _currentPdfPath!,
        pageNumbers: [1], // Extract first page
      );

      if (result.success) {
        setState(() {
          _currentPdfPath = result.outputPath ?? _currentPdfPath;
        });
        _setStatus('Pages extracted successfully!');
      } else {
        _setStatus('Failed to extract pages: ${result.errorMessage}');
      }
    } catch (e) {
      _setStatus('Error extracting pages: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _splitPdf() async {
    if (_currentPdfPath == null) {
      _setStatus('Please load a PDF first');
      return;
    }

    _setLoading(true);
    try {
      final results = await DocumentScanner().splitPdf(
        pdfPath: _currentPdfPath!,
        pageRanges: [1, 2], // Split into individual pages
      );

      int successCount = results.where((r) => r.success).length;
      _setStatus('PDF split into $successCount files successfully!');
    } catch (e) {
      _setStatus('Error splitting PDF: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Advanced Operations
  Future<void> _createAnnotatedPdf() async {
    if (_currentPdfPath == null) {
      _setStatus('Please load a PDF first');
      return;
    }

    _setLoading(true);
    try {
      final annotations = [
        {
          'id': 'text_1',
          'type': 'text',
          'pageNumber': 1,
          'x': 100,
          'y': 100,
          'width': 200,
          'height': 50,
          'text': 'Important Note',
          'color': '#FF0000',
          'fontSize': 16,
        },
        {
          'id': 'highlight_1',
          'type': 'highlight',
          'pageNumber': 1,
          'x': 50,
          'y': 200,
          'width': 300,
          'height': 20,
          'color': '#FFFF00',
        },
      ];

      final result = await PdfEditHelper.createAnnotatedPdf(
        sourcePdfPath: _currentPdfPath!,
        annotations: annotations,
      );

      if (result.success) {
        setState(() {
          _currentPdfPath = result.outputPath ?? _currentPdfPath;
        });
        _setStatus('Annotated PDF created successfully!');
      } else {
        _setStatus('Failed to create annotated PDF: ${result.errorMessage}');
      }
    } catch (e) {
      _setStatus('Error creating annotated PDF: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _batchOperations() async {
    if (_currentPdfPath == null) {
      _setStatus('Please load a PDF first');
      return;
    }

    _setLoading(true);
    try {
      // Perform multiple operations in sequence
      final compressResult = await PdfEditHelper.quickCompress(
        pdfPath: _currentPdfPath!,
        quality: 85,
      );

      if (compressResult.success) {
        setState(() {
          _currentPdfPath = compressResult.outputPath ?? _currentPdfPath;
        });

        // Add a watermark after compression
        final watermarkResult = await PdfEditHelper.addWatermark(
          pdfPath: _currentPdfPath!,
          watermarkText: 'PROCESSED',
        );

        if (watermarkResult.success) {
          setState(() {
            _currentPdfPath = watermarkResult.outputPath ?? _currentPdfPath;
          });
          _setStatus('Batch operations completed successfully!');
        } else {
          _setStatus('Compression successful, but watermark failed: ${watermarkResult.errorMessage}');
        }
      } else {
        _setStatus('Batch operations failed: ${compressResult.errorMessage}');
      }
    } catch (e) {
      _setStatus('Error in batch operations: $e');
    } finally {
      _setLoading(false);
    }
  }
}
