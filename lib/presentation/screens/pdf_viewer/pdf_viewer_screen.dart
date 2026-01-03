import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import '../../../data/models/exam_model.dart';

class PdfViewerScreen extends StatelessWidget {
  final ExamModel exam;

  const PdfViewerScreen({super.key, required this.exam});

  @override
  Widget build(BuildContext context) {
    final isLocal = exam.pdfLocalPath != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${exam.subject} ${exam.year}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: isLocal
          ? PDFView(
        filePath: exam.pdfLocalPath!,
        enableSwipe: true,
        swipeHorizontal: false,
      )
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.picture_as_pdf, size: 60),
            const SizedBox(height: 16),
            const Text(
              'This exam is not downloaded',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                // Later: download logic
              },
              child: const Text('Download Exam'),
            ),
          ],
        ),
      ),
    );
  }
}
