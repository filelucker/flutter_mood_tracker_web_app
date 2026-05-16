import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() {
  runApp(const MoodTrackerApp());
}

class MoodTrackerApp extends StatelessWidget {
  const MoodTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mood Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const MoodTrackerScreen(),
    );
  }
}

enum Mood {
  happy,
  neutral,
  sad;

  Color get color {
    switch (this) {
      case Mood.happy:
        return Colors.amber;
      case Mood.neutral:
        return Colors.blueGrey;
      case Mood.sad:
        return Colors.indigo;
    }
  }

  String get label {
    switch (this) {
      case Mood.happy:
        return 'Happy';
      case Mood.neutral:
        return 'Neutral';
      case Mood.sad:
        return 'Sad';
    }
  }
}

class MoodEntry {
  final Mood mood;
  final DateTime timestamp;

  MoodEntry({required this.mood, required this.timestamp});
}

class MoodPainter extends CustomPainter {
  final Mood mood;
  final Color color;

  MoodPainter({required this.mood, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    final facePaint = Paint()
      ..color = color.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final detailPaint = Paint()
      ..color = color.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    // Draw face circle
    canvas.drawCircle(center, radius, facePaint);
    canvas.drawCircle(center, radius, strokePaint);

    // Eyes
    final eyeOffsetWidth = radius * 0.35;
    final eyeOffsetHeight = radius * 0.25;
    canvas.drawCircle(
      Offset(center.dx - eyeOffsetWidth, center.dy - eyeOffsetHeight),
      radius * 0.1,
      detailPaint,
    );
    canvas.drawCircle(
      Offset(center.dx + eyeOffsetWidth, center.dy - eyeOffsetHeight),
      radius * 0.1,
      detailPaint,
    );

    // Mouth and Eyebrows based on Mood
    switch (mood) {
      case Mood.happy:
        // Smile
        final rect = Rect.fromCircle(center: center.translate(0, radius * 0.1), radius: radius * 0.5);
        canvas.drawArc(rect, 0.2, math.pi - 0.4, false, strokePaint);
        break;
      case Mood.neutral:
        // Straight mouth
        canvas.drawLine(
          Offset(center.dx - radius * 0.4, center.dy + radius * 0.3),
          Offset(center.dx + radius * 0.4, center.dy + radius * 0.3),
          strokePaint,
        );
        break;
      case Mood.sad:
        // Frown using Path
        final mouthPath = Path();
        mouthPath.moveTo(center.dx - radius * 0.4, center.dy + radius * 0.5);
        mouthPath.quadraticBezierTo(
          center.dx, center.dy + radius * 0.2,
          center.dx + radius * 0.4, center.dy + radius * 0.5,
        );
        canvas.drawPath(mouthPath, strokePaint);
        
        // Sad eyebrows using Path
        final leftEyebrow = Path();
        leftEyebrow.moveTo(center.dx - radius * 0.5, center.dy - radius * 0.5);
        leftEyebrow.lineTo(center.dx - radius * 0.2, center.dy - radius * 0.35);
        canvas.drawPath(leftEyebrow, strokePaint);

        final rightEyebrow = Path();
        rightEyebrow.moveTo(center.dx + radius * 0.5, center.dy - radius * 0.5);
        rightEyebrow.lineTo(center.dx + radius * 0.2, center.dy - radius * 0.35);
        canvas.drawPath(rightEyebrow, strokePaint);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant MoodPainter oldDelegate) => oldDelegate.mood != mood || oldDelegate.color != color;
}

class MoodTrackerScreen extends StatefulWidget {
  const MoodTrackerScreen({super.key});

  @override
  State<MoodTrackerScreen> createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends State<MoodTrackerScreen> {
  final List<MoodEntry> _entries = [];

  void _logMood(Mood mood) {
    setState(() {
      _entries.insert(0, MoodEntry(mood: mood, timestamp: DateTime.now()));
    });
  }

  @override
  Widget build(BuildContext context) {
    final pastEntries = _entries.take(7).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Tracker'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Column(
        children: [
          const SizedBox(height: 40),
          Text(
            'How are you feeling today?',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: Mood.values.map((mood) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => _logMood(mood),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: CustomPaint(
                          size: const Size(80, 80),
                          painter: MoodPainter(mood: mood, color: mood.color),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(mood.label, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              );
            }).toList(),
          ),
          const Spacer(),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Recent Moods (Past 7)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          SizedBox(
            height: 180,
            child: pastEntries.isEmpty
                ? const Center(child: Text('No entries yet. Start logging!'))
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: pastEntries.length,
                    itemBuilder: (context, index) {
                      return TimelineEntryCard(entry: pastEntries[index]);
                    },
                  ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class TimelineEntryCard extends StatefulWidget {
  final MoodEntry entry;

  const TimelineEntryCard({super.key, required this.entry});

  @override
  State<TimelineEntryCard> createState() => _TimelineEntryCardState();
}

class _TimelineEntryCardState extends State<TimelineEntryCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.2), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _playAnimation() {
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final entry = widget.entry;
    final dateStr = "${entry.timestamp.hour}:${entry.timestamp.minute.toString().padLeft(2, '0')}";
    final dayStr = "${entry.timestamp.day}/${entry.timestamp.month}";

    return GestureDetector(
      onTap: _playAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: 120,
          margin: const EdgeInsets.only(right: 16, bottom: 8, top: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: entry.mood.color.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: entry.mood.color.withOpacity(0.3), width: 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(dayStr, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              Text(dateStr, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              CustomPaint(
                size: const Size(50, 50),
                painter: MoodPainter(mood: entry.mood, color: entry.mood.color),
              ),
              const SizedBox(height: 12),
              Container(
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: entry.mood.color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
