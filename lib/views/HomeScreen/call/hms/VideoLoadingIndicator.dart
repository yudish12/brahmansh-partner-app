import 'package:flutter/material.dart';

class VideoLoadingIndicator extends StatefulWidget {
  const VideoLoadingIndicator({super.key});

  @override
  State<VideoLoadingIndicator> createState() => _VideoLoadingIndicatorState();
}

class _VideoLoadingIndicatorState extends State<VideoLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue[900]!.withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Animated border
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return CustomPaint(
                painter: _BorderPainter(_animation.value),
                size: Size.infinite,
              );
            },
          ),
          
          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Video icon with pulsing animation
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 1 + 0.1 * _animation.value,
                      child: Icon(
                        Icons.video_library,
                        size: 48,
                        color: Colors.blue[300]!.withOpacity(0.8 + 0.2 * _animation.value),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Loading text
                const Text(
                  'Connecting..',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Progress indicator
                SizedBox(
                  width: 120,
                  child: LinearProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[400]!),
                    backgroundColor: Colors.grey[800],
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Pulsing dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _PulsingDot(delay: 0, color: Colors.blue[400]!),
                    const SizedBox(width: 8),
                    _PulsingDot(delay: 200, color: Colors.blue[400]!),
                    const SizedBox(width: 8),
                    _PulsingDot(delay: 400, color: Colors.blue[400]!),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom border painter for the rotating effect
class _BorderPainter extends CustomPainter {
  final double progress;

  _BorderPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = SweepGradient(
        colors: [
          Colors.blue[900]!.withOpacity(0.5),
          Colors.blue[400]!,
          Colors.blue[900]!.withOpacity(0.5),
        ],
        stops: const [0.0, 0.5, 1.0],
        startAngle: 0,
        endAngle: 3.14 * 2,
        transform: GradientRotation(3.14 * 2 * progress),
      ).createShader(Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2,
      ))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final rect = Rect.fromPoints(
      const Offset(5, 5),
      Offset(size.width - 5, size.height - 5),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(12)),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Pulsing dot widget
class _PulsingDot extends StatefulWidget {
  final int delay;
  final Color color;

  const _PulsingDot({required this.delay, required this.color});

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: 0.2 + 0.8 * _animation.value,
          child: Transform.scale(
            scale: 0.6 + 0.6 * _animation.value,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: widget.color,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }
}