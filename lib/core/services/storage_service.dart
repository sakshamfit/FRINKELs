import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path_provider/path_provider.dart';

/// Service for handling file operations with Supabase Storage
class StorageService {
  final SupabaseClient _supabase;

  StorageService(this._supabase);

  /// Upload a file to Supabase Storage
  ///
  /// [file] - The file to upload
  /// [path] - The path within the bucket (e.g., 'avatars/user123.jpg')
  /// [bucket] - The bucket name (default: 'uploads')
  ///
  /// Returns the public URL of the uploaded file
  Future<String> uploadFile({
    required File file,
    required String path,
    String bucket = 'uploads',
  }) async {
    try {
      await _supabase.storage.from(bucket).upload(path, file);

      // Get public URL
      final publicUrl = _supabase.storage.from(bucket).getPublicUrl(path);
      return publicUrl;
    } catch (e) {
      throw Exception('Failed to upload file: $e');
    }
  }

  /// Upload a file and show progress
  ///
  /// [file] - The file to upload
  /// [path] - The path within the bucket
  /// [bucket] - The bucket name (default: 'uploads')
  /// [onProgress] - Callback with progress percentage (0.0 to 1.0)
  ///
  /// Returns the public URL of the uploaded file
  Future<String> uploadFileWithProgress({
    required File file,
    required String path,
    String bucket = 'uploads',
    required void Function(double progress) onProgress,
  }) async {
    try {
      // Note: Supabase Dart SDK doesn't have built-in progress for upload
      // We'll call the callback at start and end for now
      onProgress(0.0);

      await _supabase.storage.from(bucket).upload(path, file);

      onProgress(1.0);

      // Get public URL
      final publicUrl = _supabase.storage.from(bucket).getPublicUrl(path);
      return publicUrl;
    } catch (e) {
      throw Exception('Failed to upload file: $e');
    }
  }

  /// Download a file from Supabase Storage
  ///
  /// [path] - The path of the file in the bucket
  /// [bucket] - The bucket name (default: 'uploads')
  /// [filename] - Optional filename for the downloaded file
  ///
  /// Returns the local file path of the downloaded file
  Future<File> downloadFile({
    required String path,
    String bucket = 'uploads',
    String? filename,
  }) async {
    try {
      final fileBytes = await _supabase.storage.from(bucket).download(path);

      final String fileName = filename ?? path.split('/').last;
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/$fileName');

      await file.writeAsBytes(fileBytes);
      return file;
    } catch (e) {
      throw Exception('Failed to download file: $e');
    }
  }

  /// Delete a file from Supabase Storage
  ///
  /// [path] - The path of the file in the bucket
  /// [bucket] - The bucket name (default: 'uploads')
  Future<void> deleteFile({
    required String path,
    String bucket = 'uploads',
  }) async {
    try {
      await _supabase.storage.from(bucket).remove([path]);
    } catch (e) {
      throw Exception('Failed to delete file: $e');
    }
  }

  /// Get the public URL for a file (if it's public)
  ///
  /// [path] - The path of the file in the bucket
  /// [bucket] - The bucket name (default: 'uploads')
  String getPublicUrl({required String path, String bucket = 'uploads'}) {
    return _supabase.storage.from(bucket).getPublicUrl(path);
  }
}
