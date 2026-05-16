import 'package:flutter/material.dart';

enum MoodType {
  happy,
  neutral,
  sad,
  excited,
  tired,
  angry;

  Color get color {
    switch (this) {
      case MoodType.happy:
        return Colors.green;
      case MoodType.neutral:
        return Colors.amber;
      case MoodType.sad:
        return Colors.indigo;
      case MoodType.excited:
        return Colors.orange;
      case MoodType.tired:
        return Colors.blueGrey;
      case MoodType.angry:
        return Colors.red;
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
      case MoodType.excited:
        return 'Excited';
      case MoodType.tired:
        return 'Tired';
      case MoodType.angry:
        return 'Angry';
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
