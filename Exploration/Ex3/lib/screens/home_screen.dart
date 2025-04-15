import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/segmentation_service.dart';
import 'result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _userImage;
  File? _backgroundImage;
  bool _isProcessing = false;
  final ImagePicker _picker = ImagePicker();
  final SegmentationService _segmentationService = SegmentationService();
  BackgroundOption _backgroundOption = BackgroundOption.custom;

  Future<void> _pickUserImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _userImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      // 에러 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이미지를 불러오는데 실패했습니다: $e')),
      );
    }
  }

  Future<void> _pickBackgroundImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _backgroundImage = File(pickedFile.path);
          _backgroundOption = BackgroundOption.custom;
        });
      }
    } catch (e) {
      // 에러 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('배경 이미지를 불러오는데 실패했습니다: $e')),
      );
    }
  }

  Future<void> _processImage() async {
    if (_userImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('먼저 사용자 이미지를 선택해주세요')),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      // 세그멘테이션 처리
      final File? resultImage = await _segmentationService.processImage(
        _userImage!,
        _backgroundImage,
        _backgroundOption,
      );

      setState(() {
        _isProcessing = false;
      });

      if (resultImage != null) {
        // 결과 화면으로 이동
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(resultImage: resultImage),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이미지 처리 중 오류가 발생했습니다: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('배경 교체 앱'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1단계: 사용자 사진 선택
              const Text(
                '1단계: 사용자 사진 업로드',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _pickUserImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('카메라'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _pickUserImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: const Text('갤러리'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 사용자 이미지 미리보기
              if (_userImage != null) ...[
                Center(
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        _userImage!,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // 2단계: 배경 선택
              const Text(
                '2단계: 배경 선택',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // 배경 옵션
              Column(
                children: [
                  RadioListTile<BackgroundOption>(
                    title: const Text('직접 업로드'),
                    value: BackgroundOption.custom,
                    groupValue: _backgroundOption,
                    onChanged: (value) {
                      setState(() {
                        _backgroundOption = value!;
                      });
                    },
                  ),
                  RadioListTile<BackgroundOption>(
                    title: const Text('흐린 배경'),
                    value: BackgroundOption.blur,
                    groupValue: _backgroundOption,
                    onChanged: (value) {
                      setState(() {
                        _backgroundOption = value!;
                      });
                    },
                  ),
                  RadioListTile<BackgroundOption>(
                    title: const Text('단색 배경 (하늘색)'),
                    value: BackgroundOption.color,
                    groupValue: _backgroundOption,
                    onChanged: (value) {
                      setState(() {
                        _backgroundOption = value!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 직접 업로드 선택 시 배경 이미지 선택 버튼
              if (_backgroundOption == BackgroundOption.custom)
                Center(
                  child: ElevatedButton.icon(
                    onPressed: _pickBackgroundImage,
                    icon: const Icon(Icons.wallpaper),
                    label: const Text('배경 이미지 선택'),
                  ),
                ),
              
              // 배경 이미지 미리보기
              if (_backgroundOption == BackgroundOption.custom && _backgroundImage != null) ...[
                const SizedBox(height: 16),
                Center(
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        _backgroundImage!,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
              
              const SizedBox(height: 32),

              // 3단계: 이미지 처리
              Center(
                child: ElevatedButton.icon(
                  onPressed: _isProcessing ? null : _processImage,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  icon: _isProcessing 
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : const Icon(Icons.auto_fix_high),
                  label: Text(_isProcessing ? '처리 중...' : '배경 교체하기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
