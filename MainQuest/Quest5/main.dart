import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ✅ 플러그인 초기화

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI 뉴스 앱',
      theme: ThemeData.dark(),
      home: WelcomeScreen(), // ✅ 기존 홈 화면 유지
    );
  }
}