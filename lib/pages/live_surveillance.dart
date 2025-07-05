import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LiveSurveillancePage extends StatefulWidget {
  @override
  _LiveSurveillancePageState createState() => _LiveSurveillancePageState();
}

class _LiveSurveillancePageState extends State<LiveSurveillancePage> {

  VideoPlayerController? _controller; 

  bool _isFrameReady = false;
  bool _hasError = false;
  bool _isLoading = false;

  late TextEditingController _ipController;

  String _currentStreamUrl = '';
  final String _storageKey = 'last_stream_url';

  bool _isDisposed = false; 

  @override
  void initState() {
    super.initState();
    _ipController = TextEditingController();
    _loadSavedUrl();
  }

  Future<void> _loadSavedUrl() async {
    if (!mounted) 
        return; 
    
    final prefs = await SharedPreferences.getInstance();
    final savedUrl = prefs.getString(_storageKey);
    
    if (savedUrl != null && savedUrl.isNotEmpty) {
      _ipController.text = savedUrl;
      await _initializeVideo(savedUrl);
    }
  }

  Future<void> _saveUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, url);
  }

  Future<void> _initializeVideo(String uri) async {
    if (uri.isEmpty || !mounted) return;

    if (mounted) {
      setState(() {
        _isLoading = true;
        _hasError = false;
        _isFrameReady = false;
        _currentStreamUrl = uri;
      });
    }

    await _disposeController();

    try {
      final newController = VideoPlayerController.networkUrl(
        Uri.parse(uri),
      )..setLooping(true);

      await newController.initialize();
      
      if (!mounted) {
        await newController.dispose();
        return;
      }

      _controller = newController;
      await _controller?.play();
      _controller?.addListener(_checkVideoStatus);
      
      await _saveUrl(uri);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
      print("Error: $error");
    }
  }

  Future<void> _disposeController() async {
    if (_controller != null) {
      _controller?.removeListener(_checkVideoStatus);
      await _controller?.dispose();
      _controller = null;
    }
  }

  void _checkVideoStatus() {
    if(_controller == null || !_controller!.value.isInitialized || !mounted) 
        return;
    
    if(!_controller!.value.isBuffering && !_isFrameReady) {
      if (mounted) {
        setState(() => _isFrameReady = true);
      }
    }
  }

  void _connectToStream() {
    if(_ipController.text.trim().isEmpty) 
        return;

    FocusScope.of(context).unfocus();
    _initializeVideo(_ipController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ipController,
                    decoration: InputDecoration(
                      labelText: 'Masukkan URL/IP Stream',
                      border: OutlineInputBorder(),
                      hintText: 'contoh: http://192.168.1.29/hls/stream.m3u8',
                    ),
                    keyboardType: TextInputType.url,
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _connectToStream,
                  child: Text('Connect'),
                ),
              ],
            ),
          ),
          Divider(),
          Expanded(
            child: _buildMainContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    if (_currentStreamUrl.isEmpty && !_isLoading && !_hasError) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.live_tv, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              "Masukkan URL stream dan tekan Connect",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      );
    }

    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Menyiapkan live stream..."),
          ],
        ),
      );
    }

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text("Gagal memuat stream"),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _initializeVideo(_currentStreamUrl),
              child: Text("Coba Lagi"),
            ),
          ],
        ),
      );
    }

    if (_isFrameReady && _controller != null) {
      return AspectRatio(
        aspectRatio: _controller!.value.aspectRatio,
        child: VideoPlayer(_controller!),
      );
    }

    return Center(child: CircularProgressIndicator());
  }

  @override
  void dispose() {
    _ipController.dispose();
    _disposeController();
    super.dispose();
  }
}