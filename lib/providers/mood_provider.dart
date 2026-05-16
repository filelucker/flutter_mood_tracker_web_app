import 'package:flutter/material.dart';
import '../models/mood_model.dart';

class MoodProvider extends ChangeNotifier {
  final List<MoodEntry> _entries = [];

  // Getter for all entries (if needed)
  List<MoodEntry> get allEntries => List.unmodifiable(_entries);

  // Requirement: Explicitly return only the past 7 entries, newest first
  List<MoodEntry> get lastSevenEntries {
    // _entries is already "latest first" if we use .insert(0, ...)
    // but we'll ensure sorting just in case
    final sorted = List<MoodEntry>.from(_entries)
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    
    return sorted.take(7).toList();
  }

  void logMood(MoodType type) {
    final newEntry = MoodEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      type: type,
    );
    
    _entries.insert(0, newEntry);
    notifyListeners();
  }
}
