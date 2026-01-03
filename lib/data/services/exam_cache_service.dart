import 'dart:typed_data';
import 'package:hive/hive.dart';

class ExamCacheService {
  static const String _boxName = 'downloaded_exams';
  late Box<Uint8List> _box;

  // Initialize Hive box
  Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      _box = await Hive.openBox<Uint8List>(_boxName);
    } else {
      _box = Hive.box<Uint8List>(_boxName);
    }
  }

  // Save exam PDF to local storage
  Future<void> saveExam(String id, Uint8List bytes) async {
    await init();
    await _box.put(id, bytes);
  }

  // Get exam PDF from local storage
  Future<Uint8List?> getExam(String id) async {
    await init();
    return _box.get(id);
  }

  // Check if exam is downloaded
  Future<bool> isDownloaded(String id) async {
    await init();
    return _box.containsKey(id);
  }

  // Delete exam from local storage
  Future<void> deleteExam(String id) async {
    await init();
    await _box.delete(id);
  }

  // Get all downloaded exam IDs
  List<String> getDownloadedExamIds() {
    return _box.keys.cast<String>().toList();
  }

  // Clear all downloaded exams
  Future<void> clearAll() async {
    await init();
    await _box.clear();
  }
}