import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController newsController = TextEditingController();
  final TextEditingController redditController = TextEditingController();
  final TextEditingController youtubeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  /// ✅ 저장된 설정 불러오기
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      newsController.text = prefs.getString('newsQuery') ?? 'AI';
      redditController.text = prefs.getString('redditQuery') ?? 'OpenAI';
      youtubeController.text = prefs.getString('youtubeQuery') ?? '테디노트';
    });
  }

  /// ✅ 설정 저장
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('newsQuery', newsController.text.trim());
    await prefs.setString('redditQuery', redditController.text.trim());
    await prefs.setString('youtubeQuery', youtubeController.text.trim());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('설정이 저장되었습니다.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // ✅ 어두운 테마 적용
      appBar: AppBar(
        title: Text("설정", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey[900], // ✅ 어두운 배경 적용
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField("뉴스 검색어", newsController),
            const SizedBox(height: 10),
            _buildTextField("Reddit 검색어", redditController),
            const SizedBox(height: 10),
            _buildTextField("YouTube 검색어", youtubeController),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveSettings,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                foregroundColor: Colors.white,
              ),
              child: Text("저장"),
            ),
          ],
        ),
      ),
    );
  }

  /// ✅ 입력 필드 UI 설정
  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Colors.white), // ✅ 텍스트 색상 변경
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white70),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white70),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent),
        ),
        filled: true,
        fillColor: Colors.grey[850], // ✅ 입력 필드 배경색 변경
      ),
    );
  }
}