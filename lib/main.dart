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
      title: 'Vector Mood Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFFF8FAF9),
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
  // Native state management: local instance of ChangeNotifier
  final MoodProvider _moodProvider = MoodProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mood Tracker',
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          // Top Section: Constrained for readability
          Expanded(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'How are you feeling right now?',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueGrey,
                      ),
                    ),
                    const SizedBox(height: 48),
                    // Mood Logging Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: MoodType.values
                          .map((type) => _MoodButton(
                                type: type,
                                onTap: () => _moodProvider.logMood(type),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Timeline Section: Full Width of the screen
          Container(
            padding: const EdgeInsets.symmetric(vertical: 32),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 20,
                  offset: const Offset(0, -10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Recent Vibes (Past 7)',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Timeline List: Uses ListenableBuilder to react to provider changes
                SizedBox(
                  height: 220,
                  child: ListenableBuilder(
                    listenable: _moodProvider,
                    builder: (context, child) {
                      final entries = _moodProvider.lastSevenEntries;

                      if (entries.isEmpty) {
                        return const Center(
                          child: Text(
                            'No entries yet. Tap a face above to start!',
                            style: TextStyle(
                                color: Colors.grey,
                                fontStyle: FontStyle.italic),
                          ),
                        );
                      }

                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        physics: const BouncingScrollPhysics(),
                        itemCount: entries.length,
                        itemBuilder: (context, index) {
                          return TimelineCard(entry: entries[index]);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MoodButton extends StatelessWidget {
  final MoodType type;
  final VoidCallback onTap;

  const _MoodButton({required this.type, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: type.color.withOpacity(0.05),
                shape: BoxShape.circle,
                border: Border.all(color: type.color.withOpacity(0.2), width: 2),
              ),
              child: CustomPaint(
                size: const Size(85, 85),
                painter: MoodPainter(moodType: type),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          type.label,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: type.color.withOpacity(0.8),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
