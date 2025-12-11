import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  // Replace with your Cloudinary credentials
  static const String _cloudName = 'YOUR_CLOUD_NAME';
  static const String _uploadPreset = 'YOUR_UPLOAD_PRESET';

  late final CloudinaryPublic _cloudinary;

  StorageService() {
    _cloudinary = CloudinaryPublic(_cloudName, _uploadPreset, cache: false);
  }

  // Upload Profile Image
  Future<String> uploadProfileImage(File imageFile, String userId) async {
    try {
      final response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          imageFile.path,
          folder: 'profile_images',
          resourceType: CloudinaryResourceType.Image,
          context: {'user_id': userId},
        ),
      );
      return response.secureUrl;
    } catch (e) {
      throw 'Failed to upload image: $e';
    }
  }

  // Upload Document/PDF (for small files only)
  Future<String> uploadDocument(File file, String folder) async {
    try {
      final response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          file.path,
          folder: folder,
          resourceType: CloudinaryResourceType.Auto,
        ),
      );
      return response.secureUrl;
    } catch (e) {
      throw 'Failed to upload document: $e';
    }
  }

  // Pick Image from Gallery
  Future<File?> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  // Pick Image from Camera
  Future<File?> takePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  // Delete from Cloudinary (optional)
  Future<void> deleteFile(String publicId) async {
    try {
      await _cloudinary.deleteFile(
        publicId: publicId,
        resourceType: CloudinaryResourceType.Image,
        invalidate: true,
      );
    } catch (e) {
      throw 'Failed to delete file: $e';
    }
  }
}