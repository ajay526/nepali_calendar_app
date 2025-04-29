import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 0.7, curve: Curves.easeIn),
      ),
    );

    _rotateAnimation = Tween<double>(begin: 0.0, end: 2 * 3.14159).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeInOut),
      ),
    );

    _controller.forward().then((_) {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/home');
        }
      });
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Transform.rotate(
                angle: _rotateAnimation.value,
                child: Opacity(
                  opacity: _opacityAnimation.value,
                  child: const HawkeyeLogo(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class HawkeyeLogo extends StatelessWidget {
  const HawkeyeLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Bird silhouette
          CustomPaint(
            size: const Size(120, 120),
            painter: BirdPainter(),
          ),
          // Circular text
          SizedBox(
            width: 200,
            height: 200,
            child: CustomPaint(
              painter: CircularTextPainter(),
            ),
          ),
          // Wave line at bottom
          Positioned(
            bottom: 30,
            child: Container(
              width: 100,
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black,
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BirdPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final path = Path();

    // Drawing a simplified hawk silhouette
    path.moveTo(size.width * 0.5, size.height * 0.3);
    // Head
    path.quadraticBezierTo(
      size.width * 0.6,
      size.height * 0.25,
      size.width * 0.65,
      size.height * 0.3,
    );
    // Right wing
    path.quadraticBezierTo(
      size.width * 0.9,
      size.height * 0.4,
      size.width * 0.8,
      size.height * 0.6,
    );
    // Tail
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.7,
      size.width * 0.2,
      size.height * 0.6,
    );
    // Left wing
    path.quadraticBezierTo(
      size.width * 0.1,
      size.height * 0.4,
      size.width * 0.35,
      size.height * 0.3,
    );
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CircularTextPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const text = 'HAWKEYE';
    const double radius = 90;
    const double startAngle = -90 * (3.14159 / 180); // Start from top

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    final double angleStep = (2 * 3.14159) / text.length;

    for (int i = 0; i < text.length; i++) {
      textPainter.text = TextSpan(
        text: text[i],
        style: const TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      );

      textPainter.layout();

      final double angle = startAngle + (i * angleStep);
      final double x =
          size.width / 2 + radius * cos(angle) - textPainter.width / 2;
      final double y =
          size.height / 2 + radius * sin(angle) - textPainter.height / 2;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(angle + 3.14159 / 2);
      textPainter.paint(canvas, Offset.zero);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
