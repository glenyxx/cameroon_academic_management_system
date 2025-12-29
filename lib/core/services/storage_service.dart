import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import '../constants/app_constants.dart';

class StorageService {
  late final CloudinaryPublic _cloudinary;
  final ImagePicker _imagePicker = ImagePicker();

  StorageService() {
    _cloudinary = CloudinaryPublic(
      AppConstants.cloudinaryCloudName,
      AppConstants.cloudinaryUploadPreset,
      cache: false,
    );
  }

  // PROFILE IMAGE UPLOAD
  Future<String> uploadProfileImage(File imageFile, String userId) async {
    try {
      final response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          imageFile.path,
          folder: AppConstants.profileImagesFolder,
          resourceType: CloudinaryResourceType.Image,
          context: {'user_id': userId},
        ),
      );
      return response.secureUrl;
    } catch (e) {
      throw 'Failed to upload profile image: $e';
    }
  }

  // UPLOAD STUDY RESOURCE (PDF/DOC/IMAGE)
  Future<String> uploadStudyResource(
      File file,
      String resourceId,
      String subject,
      ) async {
    try {
      final extension = path.extension(file.path).toLowerCase();
      CloudinaryResourceType resourceType;

      if (['.pdf', '.doc', '.docx'].contains(extension)) {
        resourceType = CloudinaryResourceType.Raw;
      } else if (['.jpg', '.jpeg', '.png', '.gif'].contains(extension)) {
        resourceType = CloudinaryResourceType.Image;
      } else if (['.mp4', '.mov', '.avi'].contains(extension)) {
        resourceType = CloudinaryResourceType.Video;
      } else {
        resourceType = CloudinaryResourceType.Auto;
      }

      final response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          file.path,
          folder: '${AppConstants.resourcesFolder}/$subject',
          resourceType: resourceType,
          context: {'resource_id': resourceId},
        ),
      );
      return response.secureUrl;
    } catch (e) {
      throw 'Failed to upload resource: $e';
    }
  }

  // UPLOAD EXAM PAPER
  Future<String> uploadExamPaper(
      File file,
      String examType,
      String subject,
      int year,
      ) async {
    try {
      final response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          file.path,
          folder: '${AppConstants.examPapersFolder}/$examType/$subject',
          resourceType: CloudinaryResourceType.Raw,
          context: {
            'exam_type': examType,
            'subject': subject,
            'year': year.toString(),
          },
        ),
      );
      return response.secureUrl;
    } catch (e) {
      throw 'Failed to upload exam paper: $e';
    }
  }

  // UPLOAD CERTIFICATE/CREDENTIAL
  Future<String> uploadCertificate(File file, String userId) async {
    try {
      final response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          file.path,
          folder: AppConstants.certificatesFolder,
          resourceType: CloudinaryResourceType.Image,
          context: {'user_id': userId},
        ),
      );
      return response.secureUrl;
    } catch (e) {
      throw 'Failed to upload certificate: $e';
    }
  }

  // UPLOAD PORTFOLIO ITEM (FOR TUTORS)
  Future<String> uploadPortfolioItem(File file, String tutorId) async {
    try {
      final extension = path.extension(file.path).toLowerCase();
      final resourceType = ['.jpg', '.jpeg', '.png'].contains(extension)
          ? CloudinaryResourceType.Image
          : ['.mp4', '.mov'].contains(extension)
          ? CloudinaryResourceType.Video
          : CloudinaryResourceType.Auto;

      final response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          file.path,
          folder: '${AppConstants.portfolioFolder}/$tutorId',
          resourceType: resourceType,
          context: {'tutor_id': tutorId},
        ),
      );
      return response.secureUrl;
    } catch (e) {
      throw 'Failed to upload portfolio item: $e';
    }
  }

  // DELETE FILE FROM CLOUDINARY
  Future<void> deleteFile(String publicId) async {
    throw UnsupportedError(
      'File deletion must be handled on the backend for security reasons.',
    );
  }


  // PICK IMAGE FROM GALLERY
  Future<File?> pickImage({int maxWidth = 1024, int quality = 85}) async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: maxWidth.toDouble(),
      imageQuality: quality,
    );

    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  // PICK IMAGE FROM CAMERA
  Future<File?> takePhoto({int maxWidth = 1024, int quality = 85}) async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: maxWidth.toDouble(),
      imageQuality: quality,
    );

    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  // PICK MULTIPLE IMAGES
  Future<List<File>> pickMultipleImages({int maxImages = 5}) async {
    final pickedFiles = await _imagePicker.pickMultiImage(
      maxWidth: 1024,
      imageQuality: 85,
    );

    if (pickedFiles.isNotEmpty) {
      return pickedFiles.take(maxImages).map((xFile) => File(xFile.path)).toList();
    }
    return [];
  }

  // PICK DOCUMENT (PDF, DOC, etc.)
  Future<File?> pickDocument({
    List<String> allowedExtensions = const ['pdf', 'doc', 'docx'],
  }) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
    );

    if (result != null && result.files.single.path != null) {
      return File(result.files.single.path!);
    }
    return null;
  }

  // PICK VIDEO
  Future<File?> pickVideo() async {
    final pickedFile = await _imagePicker.pickVideo(
      source: ImageSource.gallery,
      maxDuration: const Duration(minutes: 10),
    );

    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  // GET FILE SIZE IN MB
  double getFileSizeInMB(File file) {
    final bytes = file.lengthSync();
    return bytes / (1024 * 1024);
  }

  // VALIDATE FILE SIZE
  bool validateFileSize(File file, int maxSizeMB) {
    final sizeMB = getFileSizeInMB(file);
    return sizeMB <= maxSizeMB;
  }

  // VALIDATE IMAGE FILE
  bool validateImage(File file) {
    final extension = path.extension(file.path).toLowerCase();
    return ['.jpg', '.jpeg', '.png', '.gif'].contains(extension) &&
        validateFileSize(file, AppConstants.maxImageSize);
  }

  // VALIDATE DOCUMENT FILE
  bool validateDocument(File file) {
    final extension = path.extension(file.path).toLowerCase();
    return ['.pdf', '.doc', '.docx'].contains(extension) &&
        validateFileSize(file, AppConstants.maxDocumentSize);
  }

  // VALIDATE VIDEO FILE
  bool validateVideo(File file) {
    final extension = path.extension(file.path).toLowerCase();
    return ['.mp4', '.mov', '.avi'].contains(extension) &&
        validateFileSize(file, AppConstants.maxVideoSize);
  }
}