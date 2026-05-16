import 'package:flutter/material.dart';

enum MoodType {
  happy,
  neutral,
  sad;

  Color get color {
    switch (this) {
      case MoodType.happy:
        return Colors.green; // Emerald/Green
      case MoodType.neutral:
        return Colors.amber; // Amber/Yellow
      case MoodType.sad:
        return Colors.indigo; // Indigo/Blue
    }
  }

  String get label {
    switch (this) {
      case MoodType.happy:
        return 'Happy';
      case MoodType.neutral:
        return 'Neutral';
      case MoodType.sad:
        return 'Sad';
    }
  }
}

class MoodEntry {
  final String id;
  final DateTime timestamp;
  final MoodType type;

  MoodEntry({
    required this.id,
    required this.timestamp,
    required this.type,
  });
}
