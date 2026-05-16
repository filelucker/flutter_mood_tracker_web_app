import 'package:flutter/material.dart';
import '../models/mood_model.dart';
import '../painters/mood_painter.dart';

class TimelineCard extends StatefulWidget {
  final MoodEntry entry;

  const TimelineCard({super.key, required this.entry});

  @override
  State<TimelineCard> createState() => _TimelineCardState();
}

class _TimelineCardState extends State<TimelineCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Local controller for the isolated "visual pop" animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    // Bounce sequence: scales up and then back to normal
    _animation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0).chain(CurveTween(curve: Curves.easeInQuad)),
        weight: 50,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    // Restart animation from beginning on every tap
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final timeStr = "${widget.entry.timestamp.hour}:${widget.entry.timestamp.minute.toString().padLeft(2, '0')}";
    final dateStr = "${widget.entry.timestamp.day}/${widget.entry.timestamp.month}";

    return GestureDetector(
      onTap: _onTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            width: 130,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: widget.entry.type.color.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: widget.entry.type.color.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  dateStr,
                  style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold),
                ),
                Text(
                  timeStr,
                  style: TextStyle(
                    fontSize: 16,
                    color: widget.entry.type.color,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                CustomPaint(
                  size: const Size(55, 55),
                  painter: MoodPainter(
                    moodType: widget.entry.type,
                    animationValue: _animation.value, // Pass local animation state
                  ),
                ),
                const SizedBox(height: 12),
                // Color accent bar
                Container(
                  height: 4,
                  width: 30,
                  decoration: BoxDecoration(
                    color: widget.entry.type.color,
                    borderRadius: BorderRadius.circular(2),
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
