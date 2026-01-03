import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import '../../../core/theme/colors.dart';
import '../../../data/models/exam_model.dart';
import '../../../data/services/exam_service.dart';
import '../../../shared/providers/connectivity_provider.dart';

class PastQuestionsScreen extends StatefulWidget {
  const PastQuestionsScreen({super.key});

  @override
  State<PastQuestionsScreen> createState() => _PastQuestionsScreenState();
}

class _PastQuestionsScreenState extends State<PastQuestionsScreen> {
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();

  final ExamService _examService = ExamService();
  List<FirestoreExamModel> _exams = [];
  List<FirestoreExamModel> _filteredExams = [];
  bool _loading = true;
  bool _downloading = false;
  String? _downloadingId;

  // For fallback mock data (with REAL Cloudinary URLs)
  final List<FirestoreExamModel> _mockExamsWithUrls = [
    FirestoreExamModel(
      id: 'maths_2022',
      title: 'GCE Advanced Level Mathematics Paper 2',
      subtitle: 'Includes Marking Guide',
      subject: 'Mathematics',
      year: '2022',
      examType: 'GCE Advanced Level',
      pdfUrl: 'http://res.cloudinary.com/dlehlwowc/raw/upload/v1767457271/a8u7l7t8trawnyhuv8n5.pdf',
      hasMarkingGuide: true,
    ),
    FirestoreExamModel(
      id: 'physics_2021',
      title: 'BEPC Physics',
      subtitle: 'Question Paper Only',
      subject: 'Physics',
      year: '2021',
      examType: 'BEPC',
      pdfUrl: 'https://res.cloudinary.com/dlehlwowc/raw/upload/v1767456898/uvhkhlv54ptcszwzvlfo.pdf',
      hasMarkingGuide: false,
    ),
    FirestoreExamModel(
      id: 'biology_2022',
      title: 'GCE Ordinary Level Biology Paper 1',
      subtitle: 'Includes Marking Guide',
      subject: 'Biology',
      year: '2022',
      examType: 'GCE Ordinary Level',
      pdfUrl: 'https://res.cloudinary.com/dlehlwowc/raw/upload/v1767457222/ryqqzqkmfqmp3yrn2gka.pdf',
      hasMarkingGuide: true,
    ),
    FirestoreExamModel(
      id: 'chemistry_2020',
      title: 'GCE Advanced Level Chemistry Paper 3',
      subtitle: 'Question Paper Only',
      subject: 'Chemistry',
      year: '2020',
      examType: 'GCE Advanced Level',
      pdfUrl: 'https://res.cloudinary.com/dlehlwowc/raw/upload/v1767457222/ryqqzqkmfqmp3yrn2gka.pdf', // Replace with actual URL
      hasMarkingGuide: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadExams();
  }

  Future<void> _loadExams() async {
    try {
      final exams = await _examService.fetchExams();
      setState(() {
        _exams = exams;
        _filteredExams = exams;
        _loading = false;
      });
    } catch (e) {
      print('Error loading exams from Firestore: $e');

      // Fallback to mock data if Firestore fails
      setState(() {
        _exams = _getExamsWithCloudinaryUrls();
        _filteredExams = _exams;
        _loading = false;
      });
    }
  }

  List<FirestoreExamModel> _getExamsWithCloudinaryUrls() {
    // Replace these with your actual Cloudinary URLs
    // You should have uploaded these 4 PDFs to Cloudinary
    return [
      FirestoreExamModel(
        id: 'maths_2022_al',
        title: 'GCE Advanced Level Mathematics Paper 2',
        subtitle: 'Includes Marking Guide',
        subject: 'Mathematics',
        year: '2022',
        examType: 'GCE Advanced Level',
        pdfUrl: 'http://res.cloudinary.com/dlehlwowc/raw/upload/v1767457271/a8u7l7t8trawnyhuv8n5.pdf',
        hasMarkingGuide: true,
      ),
      FirestoreExamModel(
        id: 'physics_2021_bepc',
        title: 'BEPC Physics',
        subtitle: 'Question Paper Only',
        subject: 'Physics',
        year: '2021',
        examType: 'BEPC',
        // Replace this with your actual Cloudinary URL
        pdfUrl: 'https://res.cloudinary.com/dlehlwowc/raw/upload/v1767456898/uvhkhlv54ptcszwzvlfo.pdf',
        hasMarkingGuide: false,
      ),
      FirestoreExamModel(
        id: 'biology_2022_ol',
        title: 'GCE Ordinary Level Biology Paper 1',
        subtitle: 'Includes Marking Guide',
        subject: 'Biology',
        year: '2022',
        examType: 'GCE Ordinary Level',
        // Replace this with your actual Cloudinary URL
        pdfUrl: 'https://res.cloudinary.com/dlehlwowc/raw/upload/v1767457222/ryqqzqkmfqmp3yrn2gka.pdf',
        hasMarkingGuide: true,
      ),
      FirestoreExamModel(
        id: 'chemistry_2020_al',
        title: 'GCE Advanced Level Chemistry Paper 3',
        subtitle: 'Question Paper Only',
        subject: 'Chemistry',
        year: '2020',
        examType: 'GCE Advanced Level',
        // Replace this with your actual Cloudinary URL
        pdfUrl: 'https://res.cloudinary.com/dlehlwowc/raw/upload/v1767457222/ryqqzqkmfqmp3yrn2gka.pdf',
        hasMarkingGuide: false,
      ),

      FirestoreExamModel(
        id: 'maths_2021_al',
        title: 'GCE Advanced Level Mathematics Paper 1',
        subtitle: 'Includes Marking Guide',
        subject: 'Mathematics',
        year: '2021',
        examType: 'GCE Advanced Level',
        pdfUrl: 'https://res.cloudinary.com/YOUR_CLOUD_NAME/raw/upload/v123456/gce_maths_2021_al_paper1.pdf',
        hasMarkingGuide: true,
      ),
      FirestoreExamModel(
        id: 'physics_2022_al',
        title: 'GCE Advanced Level Physics Paper 2',
        subtitle: 'Question Paper Only',
        subject: 'Physics',
        year: '2022',
        examType: 'GCE Advanced Level',
        pdfUrl: 'https://res.cloudinary.com/YOUR_CLOUD_NAME/raw/upload/v123456/gce_physics_2022_al_paper2.pdf',
        hasMarkingGuide: false,
      ),
    ];
  }

  void _filterExams(String filter) {
    setState(() {
      _selectedFilter = filter;

      if (filter == 'All') {
        _filteredExams = _exams;
      } else if (filter == 'GCE') {
        _filteredExams = _exams.where((exam) =>
            exam.examType.toLowerCase().contains('gce')).toList();
      } else if (filter == 'BEPC') {
        _filteredExams = _exams.where((exam) =>
            exam.examType.toLowerCase().contains('bepc')).toList();
      } else if (filter == 'By Subject') {
        // You can implement subject filtering here
        _filteredExams = _exams;
      }
    });
  }

  Future<void> _handleExamTap(FirestoreExamModel exam) async {
    // Check if user is offline
    final isOffline = !context.read<ConnectivityProvider>().isOnline;

    if (isOffline) {
      _showOfflineDialog();
      return;
    }

    // Show loading indicator
    setState(() {
      _downloading = true;
      _downloadingId = exam.id;
    });

    try {
      // Download and open the PDF
      await _downloadAndOpenExam(exam);
    } catch (e) {
      print('Error opening exam: $e');
      _showErrorDialog('Failed to open exam: ${e.toString()}');
    } finally {
      setState(() {
        _downloading = false;
        _downloadingId = null;
      });
    }
  }

  Future<void> _downloadAndOpenExam(FirestoreExamModel exam) async {
    // Show download progress
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading ${exam.title}...'),
        duration: const Duration(seconds: 2),
      ),
    );

    try {
      // Download PDF from Cloudinary URL
      final bytes = await _downloadPdfFromUrl(exam.pdfUrl);

      // Open the PDF file
      await _openPdfBytes(bytes, exam.title);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${exam.title} opened successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      throw Exception('Failed to download PDF: $e');
    }
  }

  Future<Uint8List> _downloadPdfFromUrl(String pdfUrl) async {
    final response = await http.get(Uri.parse(pdfUrl));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to download PDF: ${response.statusCode}');
    }
  }

  Future<void> _openPdfBytes(Uint8List bytes, String filename) async {
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/${_sanitizeFilename(filename)}.pdf');
    await tempFile.writeAsBytes(bytes);

    await OpenFile.open(tempFile.path);
  }

  String _sanitizeFilename(String filename) {
    return filename.replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(RegExp(r'[\s]+'), '_')
        .replaceAll(RegExp(r'[_\s]+$'), '');
  }

  void _showOfflineDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Offline Mode'),
        content: const Text('You are offline. Please connect to the internet to download exam papers.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    _buildSearchBar(),
                    _buildFilterChips(),
                    Expanded(child: _buildExamList()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Past Questions',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.tune, color: Colors.white),
            onPressed: () {
              // TODO: Show filter options
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (value) {
            _performSearch(value);
          },
          decoration: InputDecoration(
            hintText: 'Search by keyword, topic...',
            hintStyle: TextStyle(
              color: AppColors.textSecondary.withOpacity(0.6),
            ),
            prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ),
    );
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      _filterExams(_selectedFilter);
    } else {
      setState(() {
        _filteredExams = _exams.where((exam) =>
        exam.title.toLowerCase().contains(query.toLowerCase()) ||
            exam.subject.toLowerCase().contains(query.toLowerCase()) ||
            exam.year.toLowerCase().contains(query.toLowerCase())).toList();
      });
    }
  }

  Widget _buildFilterChips() {
    final filters = ['All', 'GCE', 'BEPC', 'By Subject'];

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _selectedFilter == filter;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                _filterExams(filter);
              },
              backgroundColor: Colors.white,
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? AppColors.primary : AppColors.inputBorder,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildExamList() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_filteredExams.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.quiz_outlined,
              size: 64,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No exam papers found',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            if (_exams.isEmpty)
              Text(
                'Check your internet connection',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Showing ${_filteredExams.length} results',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 16),
        ..._filteredExams.map((exam) => _buildExamCard(exam)),
      ],
    );
  }

  Widget _buildExamCard(FirestoreExamModel exam) {
    final examModel = exam.toExamModel();
    final color = _getExamTypeColor(examModel.type);

    return GestureDetector(
      onTap: () => _handleExamTap(exam),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _downloading && _downloadingId == exam.id
                      ? const CircularProgressIndicator()
                      : Icon(
                    Icons.description,
                    color: color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exam.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        exam.subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  _downloading && _downloadingId == exam.id
                      ? Icons.downloading
                      : Icons.download_outlined,
                  color: _downloading && _downloadingId == exam.id
                      ? AppColors.primary
                      : AppColors.textSecondary,
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                _buildTag(exam.subject, AppColors.primary),
                _buildTag(exam.year, AppColors.secondary),
                _buildTag(exam.examType, color),
                if (exam.hasMarkingGuide)
                  _buildTag('Has Guide', AppColors.info),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Color _getExamTypeColor(ExamType type) {
    switch (type) {
      case ExamType.gceOLevel:
        return AppColors.gceOLevel;
      case ExamType.gceALevel:
        return AppColors.gceALevel;
      case ExamType.bepc:
        return AppColors.bepc;
      case ExamType.probatoire:
        return AppColors.probatoire;
      case ExamType.bac:
        return AppColors.bac;
    }
  }
}