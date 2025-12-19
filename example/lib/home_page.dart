import 'dart:io';
import 'package:doc_scanner_kit/document_scanner.dart';
import 'package:doc_scanner_kit/models/pdf_edit_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'pdf_editor_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<PdfDocument> _scannedPdfs = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadExistingPdfs();
  }

  Future<void> _loadExistingPdfs() async {
    // Load any existing PDFs from the documents directory
    try {
      final directory = await getApplicationDocumentsDirectory();
      final pdfFiles = directory.listSync()
          .where((file) => file.path.endsWith('.pdf'))
          .map((file) => PdfDocument(
                name: file.path.split('/').last,
                path: file.path,
                dateCreated: file.statSync().modified,
              ))
          .toList();
      
      setState(() {
        _scannedPdfs = pdfFiles;
      });
    } catch (e) {
      print('Error loading existing PDFs: $e');
    }
  }

  Future<void> _scanNewDocument() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final scannedDocuments = await DocumentScanner().getScanDocuments(page: 4);
      
      if (scannedDocuments != null && scannedDocuments is Map) {
        if (scannedDocuments.containsKey('pdfUri')) {
          String pdfUri = scannedDocuments['pdfUri'];
          String filePath = pdfUri.replaceFirst('file://', '');
          
          // Add to our list
          final newPdf = PdfDocument(
            name: 'Scanned Document ${DateTime.now().millisecondsSinceEpoch}',
            path: filePath,
            dateCreated: DateTime.now(),
          );
          
          setState(() {
            _scannedPdfs.insert(0, newPdf); // Add to top of list
          });
          
          _showSnackBar('Document scanned successfully!');
        }
      }
    } on PlatformException catch (e) {
      _showSnackBar('Failed to scan document: ${e.message}');
    } catch (e) {
      _showSnackBar('Error scanning document: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deletePdf(PdfDocument pdf) async {
    try {
      final file = File(pdf.path);
      if (await file.exists()) {
        await file.delete();
        setState(() {
          _scannedPdfs.removeWhere((p) => p.path == pdf.path);
        });
        _showSnackBar('PDF deleted successfully!');
      }
    } catch (e) {
      _showSnackBar('Error deleting PDF: $e');
    }
  }

  Future<void> _sharePdf(PdfDocument pdf) async {
    try {
      final file = File(pdf.path);
      if (await file.exists()) {
        await Share.shareXFiles([XFile(file.path)], text: 'Here is the scanned document!');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Scanner & Editor'),
        backgroundColor: Colors.deepOrange,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.deepOrange,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.picture_as_pdf,
                  size: 50,
                  color: Colors.white,
                ),
                const SizedBox(height: 10),
                Text(
                  'Your Scanned Documents',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${_scannedPdfs.length} documents',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          // PDF List
          Expanded(
            child: _scannedPdfs.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _scannedPdfs.length,
                    itemBuilder: (context, index) {
                      final pdf = _scannedPdfs[index];
                      return _buildPdfCard(pdf);
                    },
                  ),
          ),

          // Scan Button
          Container(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _scanNewDocument,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.scanner),
                label: Text(_isLoading ? 'Scanning...' : 'Scan New Document'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.document_scanner_outlined,
            size: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          Text(
            'No Documents Yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Scan your first document to get started',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPdfCard(PdfDocument pdf) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _navigateToEditor(pdf),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // PDF Icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: const Icon(
                  Icons.picture_as_pdf,
                  color: Colors.red,
                  size: 30,
                ),
              ),
              
              const SizedBox(width: 16),
              
              // PDF Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pdf.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Created: ${_formatDate(pdf.dateCreated)}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tap to edit or add pages',
                      style: TextStyle(
                        color: Colors.blue[600],
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Action Buttons
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Edit Button
                  IconButton(
                    onPressed: () => _navigateToEditor(pdf),
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    tooltip: 'Edit PDF',
                  ),
                  
                  // Share Button
                  IconButton(
                    onPressed: () => _sharePdf(pdf),
                    icon: const Icon(Icons.share, color: Colors.green),
                    tooltip: 'Share PDF',
                  ),
                  
                  // Delete Button
                  IconButton(
                    onPressed: () => _showDeleteDialog(pdf),
                    icon: const Icon(Icons.delete, color: Colors.red),
                    tooltip: 'Delete PDF',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToEditor(PdfDocument pdf) {
    /*Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfEditorPage(
          pdfDocument: pdf,
          onPdfUpdated: (updatedPdf) {
            // Update the PDF in our list
            setState(() {
              final index = _scannedPdfs.indexWhere((p) => p.path == pdf.path);
              if (index != -1) {
                _scannedPdfs[index] = updatedPdf;
              }
            });
          },
        ),
      ),
    );*/
  }

  void _showDeleteDialog(PdfDocument pdf) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete PDF'),
        content: Text('Are you sure you want to delete "${pdf.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deletePdf(pdf);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}

class PdfDocument {
  final String name;
  final String path;
  final DateTime dateCreated;

  PdfDocument({
    required this.name,
    required this.path,
    required this.dateCreated,
  });
}
