import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubePlayerScreen extends StatefulWidget {
  final String videoId;

  const YouTubePlayerScreen({Key? key, required this.videoId}) : super(key: key);

  @override
  _YouTubePlayerScreenState createState() => _YouTubePlayerScreenState();
}

class _YouTubePlayerScreenState extends State<YouTubePlayerScreen> {
  late YoutubePlayerController _controller;
  bool isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        disableDragSeek: false,
        loop: false,
        useHybridComposition: true, // ✅ OpenGL 관련 문제 해결
      ),
    )..addListener(() {
      if (mounted && !isPlayerReady) {
        setState(() {
          isPlayerReady = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // ✅ 메모리 누수 방지
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: isPlayerReady
            ? YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
        )
            : const CircularProgressIndicator(), // ✅ 로딩 화면 추가
      ),
    );
  }
}