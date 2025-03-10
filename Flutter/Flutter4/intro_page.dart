import 'package:flutter/material.dart';
import 'chat_screen.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 👉 배경을 완전 흰색으로 설정
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'DL TUTOR',
                style: TextStyle(
                  fontSize: 26,
                  color: Color(0xFFB71C1C),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'DL Tutor는\n'
                    '케라스 창시자에게 배우는 딥러닝을 기반으로 학습된 RAG 챗봇입니다.\n'
                    '딥러닝에 대한 모든 궁금증을 질문하면, 정확하고 깊이 있는 답변을 제공합니다!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5, // 줄 간격
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Image.asset('assets/intro.png', height: 300),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity, // 버튼을 가로로 꽉 채우기
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.red[900],
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(), // 버튼을 둥글게 만듦
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ChatScreen()),
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Continue', style: TextStyle(fontSize: 16)),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_ios_rounded, size: 18),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}