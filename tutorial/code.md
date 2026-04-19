# Code

### 1. Red: Build The Empty Face Selection Map

Create the first code test file:

```bash
mkdir -p workspace/test/code
touch workspace/test/code/prism_face_selector_service_test.dart
just format
git add --all
git commit --message 'touch workspace/test/code/prism_face_selector_service_test.dart'
```

Put this exact content in `workspace/test/code/prism_face_selector_service_test.dart`:

```dart
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
```

Run:

```bash
just format
just check-all
git add --all
git commit --message "1. Red: Build The Empty Face Selection Map"
```

### 2. Green: Return The Canonical Empty Face Selection Map

Create the first production file:

```bash
mkdir -p workspace/lib/code
touch workspace/lib/code/prism_face_selector_service.dart
just format
git add --all
git commit --message 'touch workspace/lib/code/prism_face_selector_service.dart'
```

Put this exact content in `workspace/lib/code/prism_face_selector_service.dart`:

```dart
import '../contracts/normalized_rect.dart';

const canonicalPrismFaces = [
  'front',
  'back',
  'left',
  'right',
  'top',
  'bottom',
];

Map<String, NormalizedRect?> defaultFaceSelectionMap() {
  return {
    for (final face in canonicalPrismFaces) face: null,
  };
}
```

Run:

```bash
just format
just check-all
git add --all
git commit --message "2. Green: Return The Canonical Empty Face Selection Map"
```

### 3. Red: Normalize A Selection Rectangle

Replace `workspace/test/code/prism_face_selector_service_test.dart` with:

```dart
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

  test('normalizeSelectionRect converts image coordinates into normalized values', () {
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
  });
}
```

Run:

```bash
just format
just check-all
git add --all
git commit --message "3. Red: Normalize A Selection Rectangle"
```

### 4. Green: Normalize A Selection Rectangle

Replace `workspace/lib/code/prism_face_selector_service.dart` with:

```dart
import '../contracts/normalized_rect.dart';

const canonicalPrismFaces = [
  'front',
  'back',
  'left',
  'right',
  'top',
  'bottom',
];

Map<String, NormalizedRect?> defaultFaceSelectionMap() {
  return {
    for (final face in canonicalPrismFaces) face: null,
  };
}

NormalizedRect normalizeSelectionRect({
  required double imageWidth,
  required double imageHeight,
  required double left,
  required double top,
  required double width,
  required double height,
}) {
  return NormalizedRect(
    left: left / imageWidth,
    top: top / imageHeight,
    width: width / imageWidth,
    height: height / imageHeight,
  );
}
```

Run:

```bash
just format
just check-all
git add --all
git commit --message "4. Green: Normalize A Selection Rectangle"
```

### 5. Red: Assign One Face Without Changing The Others

Replace `workspace/test/code/prism_face_selector_service_test.dart` with:

```dart
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

  test('normalizeSelectionRect converts image coordinates into normalized values', () {
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
  });

  test('assignFaceSelection updates only the requested face slot', () {
    final rect = normalizeSelectionRect(
      imageWidth: 300,
      imageHeight: 210,
      left: 30,
      top: 21,
      width: 90,
      height: 84,
    );

    final updated = assignFaceSelection(defaultFaceSelectionMap(), 'front', rect);

    expect(updated['front'], isNotNull);
    expect(updated['back'], isNull);
    expect(updated['left'], isNull);
    expect(updated['right'], isNull);
    expect(updated['top'], isNull);
    expect(updated['bottom'], isNull);
  });
}
```

Run:

```bash
just format
just check-all
git add --all
git commit --message "5. Red: Assign One Face Without Changing The Others"
```

### 6. Green: Assign One Face Without Changing The Others

Replace `workspace/lib/code/prism_face_selector_service.dart` with:

```dart
import '../contracts/normalized_rect.dart';

const canonicalPrismFaces = [
  'front',
  'back',
  'left',
  'right',
  'top',
  'bottom',
];

Map<String, NormalizedRect?> defaultFaceSelectionMap() {
  return {
    for (final face in canonicalPrismFaces) face: null,
  };
}

NormalizedRect normalizeSelectionRect({
  required double imageWidth,
  required double imageHeight,
  required double left,
  required double top,
  required double width,
  required double height,
}) {
  return NormalizedRect(
    left: left / imageWidth,
    top: top / imageHeight,
    width: width / imageWidth,
    height: height / imageHeight,
  );
}

Map<String, NormalizedRect?> assignFaceSelection(
  Map<String, NormalizedRect?> selections,
  String faceName,
  NormalizedRect rect,
) {
  if (!canonicalPrismFaces.contains(faceName)) {
    throw ArgumentError.value(faceName, 'faceName', 'Unknown face slot');
  }

  return {
    for (final entry in selections.entries)
      entry.key: entry.key == faceName ? rect : entry.value,
  };
}
```

Run:

```bash
just format
just check-all
git add --all
git commit --message "6. Green: Assign One Face Without Changing The Others"
```
