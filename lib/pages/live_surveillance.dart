import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class LiveSurveillancePage extends StatefulWidget {
  @override
  _LiveSurveillancePageState createState() => _LiveSurveillancePageState();
}

class _LiveSurveillancePageState extends State<LiveSurveillancePage> {
  late VideoPlayerController _controller;
  bool _isFrameReady = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _controller = VideoPlayerController.networkUrl(
      Uri.parse('http://192.168.1.29/hls/stream.m3u8'),
    )..setLooping(true);

    try {
      await _controller.initialize();
      _controller.play();
      _controller.addListener(_checkVideoStatus);
    } catch (error) {
      setState(() => _hasError = true);
      print("Error: $error");
    }
  }

  void _checkVideoStatus() {
    if (_controller.value.isInitialized && 
        !_controller.value.isBuffering && 
        !_isFrameReady) {
      setState(() => _isFrameReady = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _hasError
          ? Center(child: Text("Gagal memuat stream", style: TextStyle(color: Colors.red)))
          : Center( // ← Bagian kunci: Gunakan Center di root
              child: _isFrameReady
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text("Menyiapkan live stream..."),
                      ],
                    ),
            ),
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_checkVideoStatus);
    _controller.dispose();
    super.dispose();
  }
}