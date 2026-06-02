import 'package:flutter_test/flutter_test.dart';
import 'package:lr15_media/app/app.dart';

void main() {
  testWidgets('PhotoGalleryApp smoke test — renders without crashing',
      (WidgetTester tester) async {
    await tester.pumpWidget(const PhotoGalleryApp());
    // App scaffolding should be present.
    expect(find.text('My Photos'), findsOneWidget);
  });
}
