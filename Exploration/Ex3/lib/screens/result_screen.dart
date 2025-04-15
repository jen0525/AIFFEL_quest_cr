import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class ResultScreen extends StatelessWidget {
  final File resultImage;

  const ResultScreen({super.key, required this.resultImage});

  Future<void> _saveImage(BuildContext context) async {
    try {
      // 권한 요청
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
        if (!status.isGranted) {
          return;
        }
      }
      
      // 파일 복사 (외부 저장소에 저장)
      final directory = await getExternalStorageDirectory();
      if (directory == null) {
        throw Exception('외부 저장소를 찾을 수 없습니다.');
      }
      
      final imageName = 'background_changer_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savePath = '${directory.path}/$imageName';
      
      // 파일 복사
      final savedFile = await resultImage.copy(savePath);
      
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이미지가 저장되었습니다: ${savedFile.path}')),
      );
      
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이미지 저장 중 오류가 발생했습니다: $e')),
      );
    }
  }

  Future<void> _shareImage() async {
    try {
      await Share.shareXFiles([XFile(resultImage.path)], text: '배경 교체된 이미지');
    } catch (e) {
      // 에러는 위젯 트리 상위에 전달
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('결과 이미지'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Image.file(
                  resultImage,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _saveImage(context),
                  icon: const Icon(Icons.save_alt),
                  label: const Text('저장하기'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      await _shareImage();
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('이미지 공유 중 오류가 발생했습니다: $e')),
                      );
                    }
                  },
                  icon: const Icon(Icons.share),
                  label: const Text('공유하기'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
