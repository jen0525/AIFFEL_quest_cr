import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_mlkit_selfie_segmentation/google_mlkit_selfie_segmentation.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

enum BackgroundOption {
  custom,
  blur,
  color,
}

class SegmentationService {
  final SelfieSegmenter _segmenter = SelfieSegmenter(
    mode: SegmenterMode.single,
    enableRawSizeMask: true,
  );

  Future<File?> processImage(
    File inputImage,
    File? backgroundImage,
    BackgroundOption backgroundOption,
  ) async {
    try {
      // 입력 이미지를 InputImage로 변환
      final inputImageForSegmentation = InputImage.fromFile(inputImage);
      
      // 세그멘테이션 수행
      final mask = await _segmenter.processImage(inputImageForSegmentation);
      
      if (mask == null || mask.width == null || mask.height == null || mask.width == 0 || mask.height == 0) {
        throw Exception('세그멘테이션 마스크를 생성할 수 없습니다.');
      }
      
      // 마스크와 이미지 처리
      final foregroundBytes = await inputImage.readAsBytes();
      final foregroundImage = img.decodeImage(foregroundBytes);
      
      if (foregroundImage == null) {
        throw Exception('입력 이미지를 디코딩할 수 없습니다.');
      }
      
      // 배경 이미지 준비
      img.Image? background;
      switch (backgroundOption) {
        case BackgroundOption.custom:
          if (backgroundImage != null) {
            final backgroundBytes = await backgroundImage.readAsBytes();
            background = img.decodeImage(backgroundBytes);
            
            // 크기 조정
            if (background != null) {
              background = img.copyResize(
                background,
                width: foregroundImage.width,
                height: foregroundImage.height,
                interpolation: img.Interpolation.linear,
              );
            }
          } else {
            // 기본 배경 (흰색)
            background = img.Image(
              width: foregroundImage.width,
              height: foregroundImage.height,
            );
            img.fill(background, color: img.ColorRgba8(255, 255, 255, 255));
          }
          break;
          
        case BackgroundOption.blur:
          // 원본 이미지의 흐린 버전 생성
          background = img.copyResize(foregroundImage, width: foregroundImage.width, height: foregroundImage.height);
          background = img.gaussianBlur(background, radius: 20);
          break;
          
        case BackgroundOption.color:
          // 단색 배경 (하늘색)
          background = img.Image(
            width: foregroundImage.width,
            height: foregroundImage.height,
          );
          img.fill(background, color: img.ColorRgba8(135, 206, 235, 255)); // 하늘색
          break;
      }
      
      if (background == null) {
        throw Exception('배경 이미지를 준비할 수 없습니다.');
      }
      
      // 마스크 데이터 준비
      final maskWidth = mask.width!;
      final maskHeight = mask.height!;
      final maskConfidences = mask.confidences;
      
      if (maskConfidences == null) {
        throw Exception('세그멘테이션 마스크 데이터를 가져올 수 없습니다.');
      }
      
      // 최종 이미지 생성
      final resultImage = img.Image(
        width: foregroundImage.width,
        height: foregroundImage.height,
      );
      
      // 마스크 크기가 이미지 크기와 다를 수 있으므로 스케일링 계수 계산
      final scaleX = foregroundImage.width / maskWidth;
      final scaleY = foregroundImage.height / maskHeight;
      
      // 픽셀별로 처리하여 전경과 배경 합성
      for (int y = 0; y < foregroundImage.height; y++) {
        for (int x = 0; x < foregroundImage.width; x++) {
          // 마스크에서 해당 위치의 값 찾기 (스케일링 적용)
          final maskX = (x / scaleX).floor().clamp(0, maskWidth - 1);
          final maskY = (y / scaleY).floor().clamp(0, maskHeight - 1);
          final maskIndex = maskY * maskWidth + maskX;
          final maskConfidence = maskConfidences[maskIndex];
          
          // 전경 및 배경 픽셀 가져오기
          final foregroundPixel = foregroundImage.getPixel(x, y);
          final backgroundPixel = background.getPixel(x, y);
          
          // 마스크 값에 따라 전경/배경 혼합
          final fr = foregroundPixel.r.toDouble();
          final fg = foregroundPixel.g.toDouble();
          final fb = foregroundPixel.b.toDouble();
          
          final br = backgroundPixel.r.toDouble();
          final bg = backgroundPixel.g.toDouble();
          final bb = backgroundPixel.b.toDouble();
          
          final r = (fr * maskConfidence + br * (1 - maskConfidence)).round();
          final g = (fg * maskConfidence + bg * (1 - maskConfidence)).round();
          final b = (fb * maskConfidence + bb * (1 - maskConfidence)).round();
          
          resultImage.setPixelRgba(x, y, r, g, b, 255);
        }
      }
      
      // 결과 이미지를 파일로 저장
      final encodedImage = img.encodeJpg(resultImage, quality: 90);
      final tempDir = await getTemporaryDirectory();
      final outputFile = File('${tempDir.path}/result_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await outputFile.writeAsBytes(encodedImage);
      
      // 메모리 정리
      _segmenter.close();
      
      return outputFile;
    } catch (e) {
      print('세그멘테이션 처리 중 오류: $e');
      // 메모리 정리
      _segmenter.close();
      rethrow;
    }
  }
}
