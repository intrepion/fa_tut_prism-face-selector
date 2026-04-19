import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prism_face_selector/adapter/prism_face_selector_page.dart';

void main() {
  testWidgets(
    'selects a face and stores a normalized rectangle from a drag gesture',
    (tester) async {
      await tester.pumpWidget(const MaterialApp(home: PrismFaceSelectorPage()));
      await tester.pumpAndSettle();

      expect(find.text('front'), findsWidgets);

      final canvas = find.byKey(const Key('selection-canvas'));
      final topLeft = tester.getTopLeft(canvas);
      final gesture = await tester.startGesture(topLeft + const Offset(30, 21));
      await gesture.moveTo(topLeft + const Offset(120, 105));
      await gesture.up();
      await tester.pumpAndSettle();

      expect(find.text('front | 0.10, 0.10, 0.30, 0.40'), findsOneWidget);
    },
  );
}
