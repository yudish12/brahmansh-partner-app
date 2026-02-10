
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class LinearProgressBar extends StatefulWidget {
  final int value; // Value between 0-100
  final Duration animationDuration;
  const LinearProgressBar({
    super.key,
    required this.value,
    this.animationDuration = const Duration(milliseconds: 500),
  })  : assert(value >= 0 && value <= 100, 'Value must be between 0 and 100');

  @override
  State<LinearProgressBar> createState() => _LinearProgressBarState();
}

class _LinearProgressBarState extends State<LinearProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: widget.value / 100)
        .animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();
  }

  @override
  void didUpdateWidget(LinearProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _animation = Tween<double>(
        begin: oldWidget.value / 100,
        end: widget.value / 100,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ));
      _controller.forward(from: 0);
    }
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
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFE57373),
                    Color(0xFFFFB74D),
                    Color(0xFFFFD54F),
                    Color(0xFF81C784),
                  ],
                ),
              ),
            ),

            // Emoji indicator
            Positioned(
              left:
                  _animation.value * (MediaQuery.of(context).size.width - 112) -
                      20,
              top: -17,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 8,
                      offset:const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    _getEmoji(widget.value),
                    style:const TextStyle(fontSize: 35),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String _getEmoji(int value) {
    if (value < 25) return '😢';
    if (value < 50) return '😐';
    if (value < 75) return '🙂';
    return '😊';
  }
}

class CustomTag extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CustomTag({
    super.key,
    required this.icon,
    required this.isSelected,
    required this.label,
    required this.onTap,
    this.iconColor = Colors.red, // default color if not provided
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(7),
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color:
              isSelected ? Colors.red.withOpacity(0.1) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
              color: isSelected ? Colors.red : Colors.grey.shade200,
              width: 0.5),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 18),
            SizedBox(width: MediaQuery.of(context).size.width * 0.02),
            Text(
              label,
              style: Get.textTheme.titleMedium!.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.red : Colors.black),
            ).tr(),
          ],
        ),
      ),
    );
  }
}
