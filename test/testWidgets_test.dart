import 'package:brahmanshtalk/main.dart';
import 'package:flutter_test/flutter_test.dart';

// Create a mock class for FirebaseApp

void main() {
  testWidgets('Test Firebase initialization', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const MyApp());
  });
}
