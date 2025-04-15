import 'dart:math' as math;
import 'package:flutter/material.dart';

/// 스플래시 화면에 사용할 로고 위젯
class SplashLogo extends StatelessWidget {
  final double size;
  
  const SplashLogo({
    super.key,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: size * 0.75,
          height: size * 0.75,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF42A5F5), Color(0xFF1976D2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1976D2).withOpacity(0.5),
                blurRadius: 10,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.auto_fix_high,
              color: Colors.white,
              size: size * 0.4,
            ),
          ),
        ),
      ),
    );
  }
}

/// 배경에 표시될 파티클 애니메이션
class ParticleBackground extends StatefulWidget {
  final int particleCount;
  
  const ParticleBackground({
    super.key,
    this.particleCount = 30,
  });

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Particle> _particles;
  final random = math.Random();

  @override
  void initState() {
    super.initState();
    
    // 애니메이션 컨트롤러
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    
    // 파티클 초기화
    _generateParticles();
  }
  
  void _generateParticles() {
    _particles = List.generate(widget.particleCount, (index) {
      return Particle(
        position: Offset(
          random.nextDouble() * 400,
          random.nextDouble() * 800,
        ),
        speed: Offset(
          (random.nextDouble() - 0.5) * 2,
          (random.nextDouble() - 0.5) * 2,
        ),
        radius: random.nextDouble() * 4 + 1,
        opacity: random.nextDouble() * 0.7 + 0.3,
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlePainter(
            particles: _particles,
            animation: _animationController.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

/// 파티클 클래스
class Particle {
  Offset position;
  Offset speed;
  final double radius;
  final double opacity;

  Particle({
    required this.position,
    required this.speed,
    required this.radius,
    required this.opacity,
  });
}

/// 파티클을 그리기 위한 CustomPainter
class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animation;

  ParticlePainter({
    required this.particles,
    required this.animation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    for (var i = 0; i < particles.length; i++) {
      final particle = particles[i];
      
      // 애니메이션에 따라 위치 조정
      particle.position += particle.speed;
      
      // 화면 경계를 벗어나면 반대편에서 다시 등장
      if (particle.position.dx < 0) {
        particle.position = Offset(size.width, particle.position.dy);
      } else if (particle.position.dx > size.width) {
        particle.position = Offset(0, particle.position.dy);
      }
      
      if (particle.position.dy < 0) {
        particle.position = Offset(particle.position.dx, size.height);
      } else if (particle.position.dy > size.height) {
        particle.position = Offset(particle.position.dx, 0);
      }
      
      // 파티클 그리기
      paint.color = Colors.white.withOpacity(particle.opacity * (math.sin(animation * 2 * math.pi + i) * 0.1 + 0.9));
      canvas.drawCircle(particle.position, particle.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// 로딩 인디케이터 위젯
class LoadingIndicator extends StatefulWidget {
  const LoadingIndicator({super.key});

  @override
  State<LoadingIndicator> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: 60,
          height: 10,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Stack(
            children: [
              Positioned(
                left: _controller.value * 50,
                top: 0,
                bottom: 0,
                width: 10,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
