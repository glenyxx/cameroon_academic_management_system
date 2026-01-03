import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ExamOpener {
  // Open PDF from bytes
  static Future<void> openPdfFromBytes(Uint8List bytes, String filename) async {
    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/${_sanitizeFilename(filename)}.pdf');
      await file.writeAsBytes(bytes);
      await OpenFile.open(file.path);
    } catch (e) {
      print('Error opening PDF: $e');
      rethrow;
    }
  }

  // Download PDF from URL
  static Future<Uint8List> downloadPdf(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw Exception('Failed to download PDF: ${response.statusCode}');
      }
    } catch (e) {
      print('Error downloading PDF: $e');
      rethrow;
    }
  }

  // Sanitize filename for safe storage
  static String _sanitizeFilename(String filename) {
    return filename.replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(RegExp(r'[\s]+'), '_')
        .replaceAll(RegExp(r'[_\s]+$'), '');
  }

  // Get file size in readable format
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}