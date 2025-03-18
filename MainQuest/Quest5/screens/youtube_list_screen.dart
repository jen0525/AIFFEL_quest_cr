import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart'; // ✅ URL 열기 위한 패키지 추가

const String apiKey = 'YOUR_YOUTUBE_API_KEY'; // 🚨 환경 변수로 API 키 관리
const String apiUrl = 'https://www.googleapis.com/youtube/v3/search';

class YouTubeListScreen extends StatefulWidget {
  @override
  _YouTubeListScreenState createState() => _YouTubeListScreenState();
}

class _YouTubeListScreenState extends State<YouTubeListScreen> {
  List<YouTubeVideo> videos = [];
  bool isLoading = false;
  bool hasMoreVideos = true;
  String? nextPageToken;
  String searchQuery = '테디노트'; // ✅ 기본 검색어
  String? lastSavedQuery; // 🔹 마지막으로 저장된 검색어 (중복 요청 방지)
  int requestCount = 0; // ✅ API 요청 횟수 제한

  @override
  void initState() {
    super.initState();
    _loadSearchQuery(initialLoad: true);
  }

  /// ✅ 설정에서 저장된 YouTube 검색어 불러오기
  Future<void> _loadSearchQuery({bool initialLoad = false}) async {
    final prefs = await SharedPreferences.getInstance();
    String? newSearchQuery = prefs.getString('youtubeQuery')?.trim();

    if (newSearchQuery == null || newSearchQuery.isEmpty) {
      print("🚨 저장된 검색어가 없음, 기본값 사용: 테디노트");
      newSearchQuery = '테디노트';
    }

    print("🔹 저장된 검색어 확인: $newSearchQuery");

    if (!initialLoad && newSearchQuery == lastSavedQuery) {
      print("✅ 검색어 변경 없음, API 요청 생략");
      return;
    }

    setState(() {
      searchQuery = newSearchQuery!;
      lastSavedQuery = newSearchQuery;
    });

    await fetchYouTubeVideos(isNewSearch: true);
  }

  /// ✅ YouTube API에서 영상 가져오기
  Future<void> fetchYouTubeVideos({bool isNewSearch = false}) async {
    if (!hasMoreVideos || isLoading || requestCount >= 10) return; // ✅ API 요청 횟수 제한

    setState(() {
      isLoading = true;
      requestCount++;
    });

    if (nextPageToken == null && !isNewSearch) {
      print("🚨 더 이상 불러올 데이터 없음!");
      setState(() {
        hasMoreVideos = false;
      });
      return;
    }

    final url = Uri.parse(
      '$apiUrl?part=snippet&q=$searchQuery&type=video&order=date&key=$apiKey&maxResults=3&pageToken=${nextPageToken ?? ""}',
    );

    try {
      final startTime = DateTime.now();
      print("📡 요청 URL: $url");

      final response = await http.get(url);
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime).inMilliseconds;
      print("⏳ API 응답 시간: ${duration}ms");
      print("📡 응답 코드: ${response.statusCode}");

      if (response.statusCode == 403) {
        print("🚨 **403 오류 발생: API 제한일 가능성 있음. 새로운 API 키를 발급하거나 요청 제한을 확인하세요.**");
        setState(() {
          isLoading = false;
        });
        return;
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['items'] == null || (data['items'] as List).isEmpty) {
          print("🚨 YouTube API에서 데이터를 가져오지 못함.");
          setState(() {
            isLoading = false;
            hasMoreVideos = false;
          });
          return;
        }

        setState(() {
          videos.addAll((data['items'] as List)
              .map((item) => YouTubeVideo.fromJson(item))
              .where((video) => video.videoId.isNotEmpty)
              .toList());
          nextPageToken = data['nextPageToken'];
          hasMoreVideos = nextPageToken != null;
          isLoading = false;
        });
      } else {
        throw Exception('API 요청 실패: ${response.statusCode}');
      }
    } catch (e) {
      print("❌ API 요청 오류 발생: $e");
      setState(() {
        isLoading = false;
        hasMoreVideos = false;
      });
    }
  }

  /// ✅ 유튜브 링크 열기 (YouTube 앱 또는 웹 브라우저)
  void openYouTubeApp(String videoId) async {
    final url = 'https://www.youtube.com/watch?v=$videoId';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("🚨 유튜브 URL 열기 실패: $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: videos.isEmpty && isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];
          return _buildVideoItem(video);
        },
      ),
    );
  }

  /// ✅ 유튜브 리스트 UI
  Widget _buildVideoItem(YouTubeVideo video) {
    return InkWell(
      onTap: () => openYouTubeApp(video.videoId), // ✅ 클릭 시 YouTube 앱 또는 웹 브라우저 열기
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.1), blurRadius: 4, spreadRadius: 1)],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                video.thumbnailUrl,
                width: 100,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                video.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ✅ YouTube API 응답을 객체로 변환
class YouTubeVideo {
  final String title;
  final String videoId;
  final String thumbnailUrl;

  YouTubeVideo({required this.title, required this.videoId, required this.thumbnailUrl});

  factory YouTubeVideo.fromJson(Map<String, dynamic> json) {
    return YouTubeVideo(
      title: json['snippet']['title'],
      videoId: json['id']['videoId'] ?? '',
      thumbnailUrl: json['snippet']['thumbnails']['high']['url'],
    );
  }
}