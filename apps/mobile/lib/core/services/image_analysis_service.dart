import 'dart:io';
import 'package:flutter/foundation.dart';

/// Image Analysis Service — Camera & Gallery Integration
///
/// Provides platform-aware image selection (camera/gallery).
/// Returns a File reference for upload to the AI backend.
///
/// In production, this uses the `image_picker` package.
/// In simulation mode (when image_picker is unavailable),
/// returns null so UI can handle gracefully.
class ImageAnalysisService {
  static const int _maxFileSizeBytes = 1024 * 1024; // 1 MB

  /// Check if the given file size is within acceptable limits.
  bool isFileSizeAcceptable(File file) {
    try {
      final size = file.lengthSync();
      if (size > _maxFileSizeBytes) {
        debugPrint(
            'ImageAnalysisService: File too large: ${size ~/ 1024}KB > 1024KB');
        return false;
      }
      return true;
    } catch (e) {
      debugPrint('ImageAnalysisService: Cannot read file size: $e');
      return false;
    }
  }

  /// Pick an image from the device gallery.
  /// Returns a [File] reference, or null if cancelled or unavailable.
  Future<File?> pickFromGallery() async {
    try {
      // Production implementation using image_picker:
      //
      // final ImagePicker picker = ImagePicker();
      // final XFile? pickedFile = await picker.pickImage(
      //   source: ImageSource.gallery,
      //   maxWidth: 1280,
      //   maxHeight: 1280,
      //   imageQuality: 85,
      // );
      // if (pickedFile != null) {
      //   return File(pickedFile.path);
      // }

      debugPrint('ImageAnalysisService: gallery picker (simulation mode)');
      return null;
    } catch (e) {
      debugPrint('ImageAnalysisService pickFromGallery error: $e');
      return null;
    }
  }

  /// Capture a photo using the device camera.
  /// Returns a [File] reference, or null if cancelled or unavailable.
  Future<File?> captureFromCamera() async {
    try {
      // Production implementation using image_picker:
      //
      // final ImagePicker picker = ImagePicker();
      // final XFile? pickedFile = await picker.pickImage(
      //   source: ImageSource.camera,
      //   maxWidth: 1280,
      //   maxHeight: 1280,
      //   imageQuality: 85,
      // );
      // if (pickedFile != null) {
      //   return File(pickedFile.path);
      // }

      debugPrint('ImageAnalysisService: camera capture (simulation mode)');
      return null;
    } catch (e) {
      debugPrint('ImageAnalysisService captureFromCamera error: $e');
      return null;
    }
  }

  /// Validate that the file is an image based on extension.
  bool isValidImageFile(File file) {
    final ext = file.path.split('.').last.toLowerCase();
    return ['jpg', 'jpeg', 'png', 'webp', 'heic'].contains(ext);
  }

  /// Get a human-readable file size string.
  String getFileSizeString(File file) {
    try {
      final size = file.lengthSync();
      if (size > 1024 * 1024) return '${(size / 1024 / 1024).toStringAsFixed(1)} MB';
      if (size > 1024) return '${(size / 1024).toStringAsFixed(0)} KB';
      return '$size B';
    } catch (_) {
      return 'Unknown size';
    }
  }
}
