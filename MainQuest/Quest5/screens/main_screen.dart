import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:ainews/screens/reddit.dart';
import 'package:ainews/screens/youtube_list_screen.dart';
import 'package:ainews/screens/settings_screen.dart'; // ✅ 설정 페이지 추가

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<dynamic>? newsList;
  int _selectedIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  Future<void> _fetchNews() async {
    setState(() => _isLoading = true);

    final url = Uri.parse("http://10.0.2.2:8000/news/?query=AI");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          newsList = data["articles"];
          _isLoading = false;
        });
      } else {
        throw Exception("서버 응답 오류: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching news: $error");
      setState(() {
        newsList = [];
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('뉴스를 불러오는 중 오류 발생')),
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      _buildNewsListWithRefresh(), // ✅ 뉴스 화면
      RedditNewsScreen(),          // ✅ Reddit 화면
      YouTubeListScreen(),         // ✅ YouTube 화면
      SettingsScreen(),            // ✅ 설정 화면 추가
    ];

    return Scaffold(
      backgroundColor: Colors.black, // ✅ 다크 모드 적용
      body: _screens[_selectedIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
        child: Container(
          color: Colors.grey[900],
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(icon: Icons.article, index: 0),
              _buildNavItem(icon: Icons.reddit, index: 1),
              _buildNavItem(icon: Icons.ondemand_video, index: 2),
              _buildNavItem(icon: Icons.settings, index: 3), // ✅ 설정 버튼 추가
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, required int index}) {
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 250),
          opacity: isSelected ? 1.0 : 0.7,
          child: Icon(
            icon,
            size: isSelected ? 36 : 30,
            color: isSelected ? Colors.white.withOpacity(0.9) : Colors.grey[500],
          ),
        ),
      ),
    );
  }

  /// ✅ 뉴스 화면 (새로고침 가능)
  Widget _buildNewsListWithRefresh() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    if (newsList == null || newsList!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("뉴스를 불러올 수 없습니다.", style: TextStyle(color: Colors.white)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchNews,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                foregroundColor: Colors.white,
              ),
              child: Text("다시 시도"),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchNews,
      color: Colors.white,
      backgroundColor: Colors.blueGrey,
      child: ListView.builder(
        padding: EdgeInsets.all(15),
        itemCount: newsList!.length,
        itemBuilder: (context, index) {
          var news = newsList![index];
          return _buildNewsCard(news);
        },
      ),
    );
  }

  /// ✅ 뉴스 카드 UI
  Widget _buildNewsCard(Map<String, dynamic> news) {
    final url = news["url"];

    return InkWell(
      onTap: () => _launchURL(url),
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.2), blurRadius: 8, spreadRadius: 1)],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              news["image"] != null
                  ? Image.network(news["image"], height: 180, fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 180,
                      color: Colors.grey[800],
                      child: Center(child: Icon(Icons.image_not_supported, color: Colors.white60)),
                    );
                  })
                  : Container(
                height: 180,
                color: Colors.grey[800],
                child: Center(child: Icon(Icons.image_not_supported, color: Colors.white60)),
              ),
              Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(news["title"] ?? "제목 없음",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    SizedBox(height: 8),
                    Text(news["summary"] ?? "요약 없음",
                        style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.8))),
                    SizedBox(height: 10),
                    Text(news["date"] ?? "", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ✅ 뉴스 링크 열기
  Future<void> _launchURL(String? urlString) async {
    if (urlString == null || urlString.trim().isEmpty) {
      return;
    }

    if (!urlString.startsWith('http://') && !urlString.startsWith('https://')) {
      urlString = 'https://$urlString';
    }

    try {
      final Uri url = Uri.parse(urlString);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      print("URL 열기 오류: $e");
    }
  }
}