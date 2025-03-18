import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class RedditNewsScreen extends StatefulWidget {
  @override
  _RedditNewsScreenState createState() => _RedditNewsScreenState();
}

class _RedditNewsScreenState extends State<RedditNewsScreen> {
  List<dynamic>? newsList;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRedditNews();
  }

  Future<void> _fetchRedditNews() async {
    setState(() => _isLoading = true);

    final url = Uri.parse("http://10.0.2.2:8001/reddit/ai-posts?limit=20");
    print("📢 [API 요청] URL: $url");

    try {
      final response = await http.get(url);
      print("✅ [서버 응답] 상태 코드: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("📌 [응답 데이터] ${data.toString().substring(0, 500)}..."); // 처음 500자만 출력

        setState(() {
          newsList = data["data"];
          _isLoading = false;
        });

        // 각 뉴스 항목 출력 (최대 3개까지만)
        for (int i = 0; i < (newsList!.length > 3 ? 3 : newsList!.length); i++) {
          print("📰 [${i + 1}] 제목: ${newsList![i]['title']}");
          print("📝 본문: ${newsList![i]['text']}");
          print("📷 미디어: ${newsList![i]['media_url'] ?? '없음'}");
        }
      } else {
        throw Exception("서버 응답 오류: ${response.statusCode}");
      }
    } catch (error) {
      print("🚨 [에러 발생] $error");
      setState(() {
        newsList = [];
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reddit 뉴스를 불러오는 중 오류 발생')),
      );
    }
  }

  Widget _buildNewsCard(Map<String, dynamic> news) {
    final String title = news["title"] ?? "제목 없음";
    final String url = news["url"] ?? "";
    final String author = news["author"] ?? "출처 없음";
    final String text = news["text"] ?? "본문 없음";
    final String? mediaUrl = news["media_url"];

    print("🔍 [UI 렌더링] 제목: $title | 미디어 URL: ${mediaUrl ?? '없음'}");

    return Card(
      color: Colors.grey[900],
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: GoogleFonts.notoSans(
                    fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 6),
            Text(author, style: TextStyle(color: Colors.grey, fontSize: 14)),
            SizedBox(height: 10),
            Text(
              text,
              style: TextStyle(color: Colors.white70, fontSize: 15),
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
            if (mediaUrl != null) ...[
              SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  mediaUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    print("🚨 [이미지 로드 실패] URL: $mediaUrl");
                    return Container(
                      height: 180,
                      color: Colors.grey[800],
                      child: Center(child: Icon(Icons.image_not_supported, color: Colors.white60)),
                    );
                  },
                ),
              ),
            ],
            SizedBox(height: 10),
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                icon: Icon(Icons.open_in_new, color: Colors.blueAccent),
                onPressed: () => _launchURL(url),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String urlString) async {
    if (await canLaunch(urlString)) {
      await launch(urlString);
    } else {
      print("🚨 [링크 열기 실패] URL: $urlString");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('링크를 열 수 없습니다: $urlString')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator(color: Colors.white))
                  : (newsList != null && newsList!.isNotEmpty)
                  ? ListView.builder(
                itemCount: newsList!.length,
                itemBuilder: (context, index) =>
                    _buildNewsCard(newsList![index]),
              )
                  : Center(
                child: Text(
                  "Reddit 뉴스를 불러올 수 없습니다.",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}