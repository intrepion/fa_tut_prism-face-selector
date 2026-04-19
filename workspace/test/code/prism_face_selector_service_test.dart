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
}
