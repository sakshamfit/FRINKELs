import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:video_compress/video_compress.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

/// Service for handling media processing (compression, thumbnails, etc.)
class MediaService {
  final _uuid = Uuid();

  /// Compress an image file
  ///
  /// [sourcePath] - Path to the original image file
  /// [targetPath] - Path where the compressed image will be saved
  /// [quality] - Compression quality (0-100), default 85
  Future<String> compressImage({
    required String sourcePath,
    required String targetPath,
    int quality = 85,
  }) async {
    try {
      final result = await FlutterImageCompress.compressAndGetFile(
        sourcePath,
        targetPath,
        quality: quality,
      );

      return result!.path;
    } catch (e) {
      throw Exception('Failed to compress image: $e');
    }
  }

  /// Generate a thumbnail for a video
  ///
  /// [videoPath] - Path to the video file
  /// [thumbnailPath] - Path where the thumbnail will be saved
  /// [maxWidth] - Maximum width of the thumbnail
  /// [maxHeight] - Maximum height of the thumbnail
  /// [imageFormat] - Format of the thumbnail (default: PNG)
  /// [quality] - Quality of the thumbnail (0-100, default: 75)
  Future<String> generateVideoThumbnail({
    required String videoPath,
    required String thumbnailPath,
    int? maxWidth,
    int? maxHeight,
    ImageFormat imageFormat = ImageFormat.PNG,
    int quality = 75,
  }) async {
    try {
      final thumbnail = await VideoThumbnail.thumbnailFile(
        video: videoPath,
        thumbnailPath: thumbnailPath,
        imageFormat: imageFormat,
        maxWidth: maxWidth ?? 320,
        maxHeight: maxHeight ?? 240,
        quality: quality,
      );

      return thumbnail!;
    } catch (e) {
      throw Exception('Failed to generate video thumbnail: $e');
    }
  }

  /// Compress a video file
  ///
  /// [videoPath] - Path to the original video file
  /// [outputPath] - Path where the compressed video will be saved
  /// [quality] - Video quality (Default, Low, Medium, High)
  Future<String> compressVideo({
    required String videoPath,
    required String outputPath,
    VideoQuality quality = VideoQuality.MediumQuality,
  }) async {
    try {
      final MediaInfo? mediaInfo = await VideoCompress.compressVideo(
        videoPath,
        quality: quality,
        deleteOrigin: false,
        includeAudio: true,
      );

      // VideoCompress saves to a temporary location by default
      // We need to move/copy it to our desired outputPath
      if (mediaInfo != null) {
        final source = File(mediaInfo.path!);
        final destination = File(outputPath);

        // Ensure the destination directory exists
        await destination.parent.create(recursive: true);

        // Copy the compressed video to our desired location
        await source.copy(outputPath);

        // Delete the temporary file
        await source.delete();

        return outputPath;
      } else {
        throw Exception('Video compression failed');
      }
    } catch (e) {
      throw Exception('Failed to compress video: $e');
    }
  }

  /// Get video information (duration, size, etc.)
  ///
  /// [videoPath] - Path to the video file
  Future<MediaInfo?> getVideoInfo(String videoPath) async {
    try {
      return await VideoCompress.getMediaInfo(videoPath);
    } catch (e) {
      throw Exception('Failed to get video info: $e');
    }
  }

  /// Generate a unique filename with extension
  String generateFileName({String extension = 'jpg'}) {
    return '${_uuid.v4()}.$extension';
  }

  /// Get temporary directory path
  Future<String> getTempDirPath() async {
    final dir = await getTemporaryDirectory();
    return dir.path;
  }

  /// Get application documents directory path
  Future<String> getAppDocDirPath() async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }
}
