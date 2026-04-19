import 'package:prism_face_selector/code/prism_face_selector_service.dart';
import 'package:test/test.dart';

void main() {
  test('defaultFaceSelectionMap returns all empty canonical face slots', () {
    final selections = defaultFaceSelectionMap();

    expect(selections.keys, [
      'front',
      'back',
      'left',
      'right',
      'top',
      'bottom',
    ]);
    expect(selections.values.every((rect) => rect == null), isTrue);
  });

  test(
    'normalizeSelectionRect converts image coordinates into normalized values',
    () {
      final rect = normalizeSelectionRect(
        imageWidth: 300,
        imageHeight: 210,
        left: 30,
        top: 21,
        width: 90,
        height: 84,
      );

      expect(rect.left, closeTo(0.10, 0.001));
      expect(rect.top, closeTo(0.10, 0.001));
      expect(rect.width, closeTo(0.30, 0.001));
      expect(rect.height, closeTo(0.40, 0.001));
    },
  );
}
