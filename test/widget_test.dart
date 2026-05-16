// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_mood_tracker_web_application/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Mood tracker smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MoodTrackerApp());

    // Verify that our tracker starts with no entries message.
    expect(find.text('No entries yet. Tap a face above to start!'), findsOneWidget);
    expect(find.text('Happy'), findsOneWidget);

    // Tap the 'Happy' mood icon.
    await tester.tap(find.text('Happy'));
    await tester.pump();

    // Verify that the entry is added.
    expect(find.text('No entries yet. Tap a face above to start!'), findsNothing);
  });
}
