import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/exam_model.dart';

class ExamService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<FirestoreExamModel>> fetchExams() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('exams')
          .orderBy('year', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => FirestoreExamModel.fromFirestore(
          doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error fetching exams: $e');
      return [];
    }
  }

  Future<List<FirestoreExamModel>> fetchExamsByExamType(String examType) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('exams')
          .where('examType', isEqualTo: examType)
          .orderBy('year', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => FirestoreExamModel.fromFirestore(
          doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error fetching exams by type: $e');
      return [];
    }
  }

  Future<List<FirestoreExamModel>> fetchExamsBySubject(String subject) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('exams')
          .where('subject', isEqualTo: subject)
          .orderBy('year', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => FirestoreExamModel.fromFirestore(
          doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error fetching exams by subject: $e');
      return [];
    }
  }

  Future<List<String>> fetchSubjects() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('exams')
          .get();

      final subjects = snapshot.docs
          .map((doc) => (doc.data() as Map<String, dynamic>)['subject'] as String?)
          .where((subject) => subject != null)
          .cast<String>()
          .toSet()
          .toList();

      return subjects;
    } catch (e) {
      print('Error fetching subjects: $e');
      return [];
    }
  }
}