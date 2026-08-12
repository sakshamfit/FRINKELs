import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:video_compress/video_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_lucide/flutter_lucide.dart';
import 'dart:convert';
import 'dart:io';

class MediaDrawer extends ConsumerStatefulWidget {
  final Function(String) onMediaSelected;
  final Function() onCameraPressed;
  final Function() onGalleryPressed;
  final Function() onVideoPressed;
  final Function() onDocumentPressed;
  final Function() onLocationPressed;
  final Function() onVoicePressed;
  final Function(String) onGifSelected;
  final Function(String) onStickerSelected;
  final Function(String) onAiStickerGenerated;

  const MediaDrawer({
    super.key,
    required this.onMediaSelected,
    required this.onCameraPressed,
    required this.onGalleryPressed,
    required this.onVideoPressed,
    required this.onDocumentPressed,
    required this.onLocationPressed,
    required this.onVoicePressed,
    required this.onGifSelected,
    required this.onStickerSelected,
    required this.onAiStickerGenerated,
  });

  @override
  ConsumerState<MediaDrawer> createState() => _MediaDrawerState();
}

class _MediaDrawerState extends MediaDrawerState {
  @override
  void initState() {
    super.initState();
    _loadStickerPacks();
    _fetchTrendingGifs();
  }
}

abstract class MediaDrawerState extends ConsumerState<MediaDrawer>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  List<Map<String, dynamic>> _gifResults = [];
  bool _isLoadingGifs = false;
  bool _isLoadingStickers = false;
  List<Map<String, dynamic>> _stickerPacks = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 8, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadStickerPacks() async {
    setState(() => _isLoadingStickers = true);
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        _isLoadingStickers = false;
        _stickerPacks = [];
      });
    }
  }

  Future<void> _fetchTrendingGifs() async {
    if (!mounted) return;
    setState(() => _isLoadingGifs = true);
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.giphy.com/v1/gifs/trending?api_key=CxprtBQaMpOSUJShB2y7BwysWOgW7trk&limit=25',
        ),
      );
      if (response.statusCode == 200 && mounted) {
        final data = json.decode(response.body);
        setState(() {
          _gifResults = List<Map<String, dynamic>>.from(data['data']);
          _isLoadingGifs = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingGifs = false);
    }
  }

  Future<void> _searchGifs(String query) async {
    if (query.isEmpty) {
      _fetchTrendingGifs();
      return;
    }

    setState(() => _isLoadingGifs = true);
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.giphy.com/v1/gifs/search?api_key=CxprtBQaMpOSUJShB2y7BwysWOgW7trk&q=$query&limit=25',
        ),
      );
      if (response.statusCode == 200 && mounted) {
        final data = json.decode(response.body);
        setState(() {
          _gifResults = List<Map<String, dynamic>>.from(data['data']);
          _isLoadingGifs = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingGifs = false);
    }
  }

  Future<XFile?> _compressImage(File image) async {
    try {
      final result = await FlutterImageCompress.compressAndGetFile(
        image.absolute.path,
        '${(await getTemporaryDirectory()).path}/${DateTime.now().millisecondsSinceEpoch}.jpg',
        quality: 85,
        minWidth: 800,
        minHeight: 800,
      );
      return result;
    } catch (e) {
      return null;
    }
  }

  Future<File?> _compressVideo(File video) async {
    try {
      MediaInfo? mediaInfo = await VideoCompress.compressVideo(
        video.absolute.path,
        quality: VideoQuality.MediumQuality,
        deleteOrigin: false,
        includeAudio: true,
      );
      return mediaInfo != null ? File(mediaInfo.path!) : null;
    } catch (e) {
      return null;
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        final compressed = await _compressImage(File(pickedFile.path));
        if (mounted) {
          widget.onMediaSelected(compressed?.path ?? pickedFile.path);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error selecting image: $e')));
      }
    }
  }

  Future<void> _pickVideo() async {
    try {
      final XFile? pickedFile = await _picker.pickVideo(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        final compressed = await _compressVideo(File(pickedFile.path));
        if (mounted) {
          widget.onMediaSelected(compressed?.path ?? pickedFile.path);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error selecting video: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.3,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.2)
                      : Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search GIFs, Stickers...',
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _searchGifs('');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: isDark
                        ? Colors.grey.withValues(alpha: 0.2)
                        : Colors.grey.withValues(alpha: 0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: _searchGifs,
                ),
              ),

              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.1)
                          : Colors.black.withValues(alpha: 0.1),
                    ),
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  indicatorColor: Theme.of(context).colorScheme.primary,
                  labelColor: Theme.of(context).colorScheme.primary,
                  unselectedLabelColor: isDark
                      ? Colors.white.withValues(alpha: 0.6)
                      : Colors.black.withValues(alpha: 0.6),
                  tabs: [
                    Tab(text: 'Photos'),
                    Tab(text: 'Videos'),
                    Tab(text: 'GIFs'),
                    Tab(text: 'Stickers'),
                    Tab(text: 'Emoji'),
                    Tab(text: 'Files'),
                    Tab(text: 'Location'),
                    Tab(text: 'Voice'),
                  ],
                ),
              ),

              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildPhotosTab(),
                    _buildVideosTab(),
                    _buildGifsTab(),
                    _buildStickersTab(),
                    _buildEmojiTab(),
                    _buildFilesTab(),
                    _buildLocationTab(),
                    _buildVoiceTab(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPhotosTab() {
    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: 20,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _pickImageFromGallery(),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[300],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.photo_library, size: 32, color: Colors.grey[600]),
                SizedBox(height: 4),
                Text(
                  'Gallery',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildVideosTab() {
    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: 20,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _pickVideo(),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[300],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.videocam, size: 32, color: Colors.grey[600]),
                SizedBox(height: 4),
                Text(
                  'Videos',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGifsTab() {
    return _isLoadingGifs
        ? Center(child: CircularProgressIndicator())
        : _gifResults.isEmpty
        ? Center(child: Text('No GIFs found'))
        : GridView.builder(
            padding: EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: _gifResults.length,
            itemBuilder: (context, index) {
              final gif = _gifResults[index];
              final url = gif['images']['fixed_height']['url'];
              return GestureDetector(
                onTap: () => widget.onGifSelected(url),
                child: Image.network(url, fit: BoxFit.cover),
              );
            },
          );
  }

  Widget _buildStickersTab() {
    return _isLoadingStickers
        ? Center(child: CircularProgressIndicator())
        : _stickerPacks.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_search,
                  size: 48,
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.5),
                ),
                SizedBox(height: 16),
                Text(
                  'No stickers installed',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.7),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Sticker packs will appear here once available',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.5),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        : SizedBox.shrink();
  }

  Widget _buildEmojiTab() {
    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: 50,
      itemBuilder: (context, index) {
        return Center(
          child: Text(
            String.fromCharCode(0x1F600 + index),
            style: TextStyle(fontSize: 24),
          ),
        );
      },
    );
  }

  Widget _buildFilesTab() {
    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        final IconData icon;
        final String label;
        switch (index) {
          case 0:
            icon = Icons.picture_as_pdf;
            label = 'PDF';
            break;
          case 1:
            icon = Icons.description;
            label = 'Document';
            break;
          case 2:
            icon = Icons.folder_zip;
            label = 'ZIP';
            break;
          case 3:
            icon = Icons.android;
            label = 'APK';
            break;
          case 4:
            icon = Icons.insert_drive_file;
            label = 'Other';
            break;
          default:
            icon = Icons.insert_drive_file;
            label = 'File';
        }

        return GestureDetector(
          onTap: widget.onDocumentPressed,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[300],
                ),
                child: Icon(icon, size: 24, color: Colors.grey[600]),
              ),
              SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLocationTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.place, size: 64, color: Colors.grey[400]),
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: widget.onLocationPressed,
            icon: Icon(Icons.my_location),
            label: Text('Share Location'),
          ),
        ],
      ),
    );
  }

  Widget _buildVoiceTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.mic, size: 64, color: Colors.grey[400]),
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: widget.onVoicePressed,
            icon: Icon(Icons.mic),
            label: Text('Send Voice Message'),
          ),
          SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {},
            icon: Icon(LucideIcons.bot),
            label: Text('AI Voice'),
          ),
        ],
      ),
    );
  }
}
