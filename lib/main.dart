import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'models/mood_model.dart';
import 'painters/mood_painter.dart';
import 'providers/mood_provider.dart';
import 'widgets/timeline_card.dart';

void main() {
  runApp(const MoodTrackerApp());
}

class MoodTrackerApp extends StatelessWidget {
  const MoodTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VibeCheck',
      debugShowCheckedModeBanner: false,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown
        },
      ),
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF6366F1),
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF1F5F9),
        textTheme: const TextTheme(
          displaySmall: TextStyle(
            fontWeight: FontWeight.w900,
            color: Color(0xFF1E293B),
            letterSpacing: -0.5,
          ),
          titleLarge: TextStyle(
            fontWeight: FontWeight.w800,
            color: Color(0xFF334155),
            letterSpacing: -0.2,
          ),
        ),
      ),
      home: const MoodTrackerHome(),
    );
  }
}

class MoodTrackerHome extends StatefulWidget {
  const MoodTrackerHome({super.key});

  @override
  State<MoodTrackerHome> createState() => _MoodTrackerHomeState();
}

class _MoodTrackerHomeState extends State<MoodTrackerHome> {
  // Controller instance that holds the business logic
  final MoodProvider _moodProvider = MoodProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFEEF2FF),
              Color(0xFFE0E7FF),
              Color(0xFFF1F5F9),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ListenableBuilder(
              listenable: _moodProvider,
              builder: (context, _) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 48),
                  child: Column(
                    children: [
                      // Header Section (Pure UI rendering based on Provider data)
                      _HeaderSection(greeting: _moodProvider.greeting),
                      const SizedBox(height: 56),

                      // Mood Selector (Input actions delegated to Provider)
                      _MoodSelector(
                        onMoodSelected: _moodProvider.logMood,
                      ),
                      const SizedBox(height: 64),

                      // History Section (Data sourced from Provider)
                      _HistorySection(entries: _moodProvider.lastSevenEntries),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  final String greeting;
  const _HeaderSection({required this.greeting});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 700),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text(
            greeting,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: const Color(0xFF6366F1),
                  fontSize: 18,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'How is your vibe today?',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontSize: 32,
                ),
          ),
        ],
      ),
    );
  }
}

class _MoodSelector extends StatelessWidget {
  final Function(MoodType) onMoodSelected;
  const _MoodSelector({required this.onMoodSelected});

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Container(
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.indigo.withOpacity(0.05),
                blurRadius: 40,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: MoodType.values
                .map((type) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: _MoodButton(
                        type: type,
                        onTap: () => onMoodSelected(type),
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}

class _HistorySection extends StatelessWidget {
  final List<MoodEntry> entries;
  const _HistorySection({required this.entries});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 700),
            child: const Padding(
              padding: EdgeInsets.only(left: 8, bottom: 20),
              child: Text(
                'Your Recent Journey (Last 7)',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF475569),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 260,
          width: double.infinity,
          child: entries.isEmpty
              ? _EmptyHistoryState()
              : Scrollbar(
                  thumbVisibility: true,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    physics: const BouncingScrollPhysics(),
                    itemCount: entries.length,
                    itemBuilder: (context, index) => TimelineCard(entry: entries[index]),
                  ),
                ),
        ),
      ],
    );
  }
}

class _EmptyHistoryState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 700),
          width: double.infinity,
          height: 180,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.4),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.5)),
          ),
          child: const Center(
            child: Text(
              'Your timeline is empty. Log a mood to start!',
              style: TextStyle(
                color: Color(0xFF94A3B8),
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MoodButton extends StatefulWidget {
  final MoodType type;
  final VoidCallback onTap;

  const _MoodButton({required this.type, required this.onTap});

  @override
  State<_MoodButton> createState() => _MoodButtonState();
}

class _MoodButtonState extends State<_MoodButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? 1.1 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutBack,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: widget.type.color.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: _isHovered
                        ? widget.type.color.withOpacity(0.4)
                        : widget.type.color.withOpacity(0.1),
                    width: 2,
                  ),
                ),
                child: CustomPaint(
                  size: const Size(60, 60),
                  painter: MoodPainter(moodType: widget.type),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.type.label,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: widget.type.color.withOpacity(0.9),
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
