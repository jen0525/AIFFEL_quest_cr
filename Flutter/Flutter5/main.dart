import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 디버그 배너 제거
      home: JellyfishClassifier(),
    );
  }
}

class JellyfishClassifier extends StatefulWidget {
  const JellyfishClassifier({super.key});

  @override
  State<JellyfishClassifier> createState() => _JellyfishClassifierState();
}

class _JellyfishClassifierState extends State<JellyfishClassifier> {

  // 🔹 FastAPI에서 예측된 클래스 가져오기 (왼쪽 버튼)
  Future<void> _fetchPredictionClass() async {
    var uri = Uri.parse("https://bd41-34-19-50-72.ngrok-free.app/sample");
    print("🔹 FastAPI에 요청 보냄: $uri");

    try {
      var response = await http.get(uri, headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Connection": "keep-alive",
      });

      print("🔹 응답 코드: ${response.statusCode}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print("✅ 예측 클래스: ${data['predicted_label']}");  // ✅ 콘솔에만 출력
      } else {
        print("🚨 FastAPI 요청 실패: ${response.statusCode}");
      }
    } catch (e) {
      print("🚨 FastAPI 연결 오류: $e");
    }
  }

  // 🔹 FastAPI에서 예측된 확률 가져오기 (오른쪽 버튼)
  Future<void> _fetchPredictionScore() async {
    var uri = Uri.parse("https://bd41-34-19-50-72.ngrok-free.app/sample");
    print("🔹 FastAPI에 요청 보냄: $uri");

    try {
      var response = await http.get(uri);
      print("🔹 응답 코드: ${response.statusCode}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        // 🔹 String을 double로 변환 후 소수점 6자리까지 유지
        double score = double.tryParse(data['prediction_score'].toString()) ?? 0.0;

        print("✅ 예측 확률: ${score.toStringAsFixed(6)}%");  // ✅ 소수점 6자리 출력
      } else {
        print("🚨 FastAPI 요청 실패: ${response.statusCode}");
      }
    } catch (e) {
      print("🚨 FastAPI 연결 오류: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Jellyfish Classifier"),
        leading: const Icon(Icons.blur_circular), // 해파리 아이콘
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 🔹 해파리 이미지 표시
          Image.asset("assets/image.png", width: 300, height: 300, fit: BoxFit.cover),

          const SizedBox(height: 20),

          // 🔹 버튼 두 개 배치 (좌측: 클래스 예측, 우측: 확률 확인)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  ElevatedButton(
                    onPressed: _fetchPredictionClass, // 좌측 버튼: 예측된 클래스 가져오기
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(), // 원형 버튼 스타일
                      padding: const EdgeInsets.all(20),
                    ),
                    child: const Icon(Icons.search),
                  ),
                  const SizedBox(height: 5),
                  const Text("클래스 예측하기"), // 버튼 설명 추가
                ],
              ),
              const SizedBox(width: 20),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: _fetchPredictionScore, // 우측 버튼: 예측 확률 가져오기
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(), // 원형 버튼 스타일
                      padding: const EdgeInsets.all(20),
                    ),
                    child: const Icon(Icons.percent),
                  ),
                  const SizedBox(height: 5),
                  const Text("확률 확인하기"), // 버튼 설명 추가
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// 회고 😰
// 허재은: FastAPI가 Flutter에서 연결되지 않음 (Connection refused, 403 Forbidden)이 오류때문에 한참 걸렸다...
// 퀘스트 진행방식은 같이 하는건 어려울거 같아 따로 하고 성공하는 사람의 것을 하자고 했다. 엔그록을 이용하여 /docs 에 확률정보를 띄웠고 플러터를 구현하고 있는데 다시 연결이 끊어지고 플러터는 작동되지 않고, 재은님의 코드를 받아서 했는데 내 안드로이드 스튜디오에서는 실행되지 않아서 거의 포기 직전이었는데 재은님의 성공소식이 들려왔다. 기적이었다.