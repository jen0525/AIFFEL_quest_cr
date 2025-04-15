import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../home_screen.dart';
import 'splash_widgets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  // 애니메이션 컨트롤러
  late AnimationController _animationController;
  
  // 로고 애니메이션
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotateAnimation;
  
  // 배경 그라데이션 애니메이션
  late Animation<Color?> _gradientColor1;
  late Animation<Color?> _gradientColor2;
  
  // 파티클 애니메이션
  late Animation<double> _particleAnimation;
  
  // 텍스트 애니메이션
  late Animation<double> _textOpacityAnimation;
  late Animation<Offset> _textSlideAnimation;

  @override
  void initState() {
    super.initState();
    
    // 시스템 UI 설정
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    
    // 애니메이션 컨트롤러 설정
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    );
    
    // 로고 크기 애니메이션
    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );
    
    // 로고 회전 애니메이션
    _logoRotateAnimation = Tween<double>(begin: 0.0, end: 2 * 3.14159).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOutCubic),
      ),
    );
    
    // 배경 그라데이션 애니메이션
    _gradientColor1 = ColorTween(
      begin: const Color(0xFF1A237E),
      end: const Color(0xFF0D47A1),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );
    
    _gradientColor2 = ColorTween(
      begin: const Color(0xFF4527A0),
      end: const Color(0xFF1565C0),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );
    
    // 파티클 애니메이션
    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );
    
    // 텍스트 애니메이션
    _textOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.5, 0.8, curve: Curves.easeIn),
      ),
    );
    
    _textSlideAnimation = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.5, 0.8, curve: Curves.easeOut),
      ),
    );
    
    // 애니메이션 시작
    _animationController.forward();
    
    // 3.5초 후 홈 화면으로 이동
    Timer(const Duration(milliseconds: 3800), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOutCubic;

            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(position: offsetAnimation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _gradientColor1.value ?? const Color(0xFF1A237E),
                  _gradientColor2.value ?? const Color(0xFF4527A0),
                ],
              ),
            ),
            child: Stack(
              children: [
                // 파티클 효과
                Positioned.fill(
                  child: Opacity(
                    opacity: _particleAnimation.value,
                    child: const ParticleBackground(
                      particleCount: 50,
                    ),
                  ),
                ),
                
                // 가운데 로고와 텍스트
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 로고 애니메이션
                      Transform.scale(
                        scale: _logoScaleAnimation.value,
                        child: Transform.rotate(
                          angle: _logoRotateAnimation.value,
                          child: const SplashLogo(
                            size: 120,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      
                      // 앱 이름 애니메이션
                      FadeTransition(
                        opacity: _textOpacityAnimation,
                        child: SlideTransition(
                          position: _textSlideAnimation,
                          child: const Text(
                            "배경 교체 앱",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // 태그라인 애니메이션
                      FadeTransition(
                        opacity: _textOpacityAnimation,
                        child: SlideTransition(
                          position: _textSlideAnimation,
                          child: const Text(
                            "당신의 사진, 새로운 배경으로 다시 태어나다",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 60),
                      
                      // 로딩 인디케이터
                      FadeTransition(
                        opacity: _textOpacityAnimation,
                        child: const LoadingIndicator(),
                      ),
                    ],
                  ),
                ),
                
                // 아래 버전 정보
                Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: FadeTransition(
                    opacity: _textOpacityAnimation,
                    child: const Center(
                      child: Text(
                        "버전 1.0.0",
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
