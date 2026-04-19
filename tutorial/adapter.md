# Adapter

### 1. Red: Add The Prism Face Selector Page Widget Test

Create the widget test file:

```bash
mkdir -p workspace/test/adapter
touch workspace/test/adapter/prism_face_selector_page_test.dart
just format
git add --all
git commit --message 'touch workspace/test/adapter/prism_face_selector_page_test.dart'
```

Put this exact content in `workspace/test/adapter/prism_face_selector_page_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prism_face_selector/adapter/prism_face_selector_page.dart';

void main() {
  testWidgets('selects a face and stores a normalized rectangle from a drag gesture', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: PrismFaceSelectorPage()),
    );
    await tester.pumpAndSettle();

    expect(find.text('front'), findsWidgets);

    final canvas = find.byKey(const Key('selection-canvas'));
    final topLeft = tester.getTopLeft(canvas);
    final gesture = await tester.startGesture(topLeft + const Offset(30, 21));
    await gesture.moveTo(topLeft + const Offset(120, 105));
    await gesture.up();
    await tester.pumpAndSettle();

    expect(find.text('front | 0.10, 0.10, 0.30, 0.40'), findsOneWidget);
  });
}
```

Run:

```bash
just format
just check-all
git add --all
git commit --message "1. Red: Add The Prism Face Selector Page Widget Test"
```

### 2. Green: Build The Prism Face Selector Page

Create the page production file:

```bash
mkdir -p workspace/lib/adapter
touch workspace/lib/adapter/prism_face_selector_page.dart
just format
git add --all
git commit --message 'touch workspace/lib/adapter/prism_face_selector_page.dart'
```

Put this exact content in `workspace/lib/adapter/prism_face_selector_page.dart`:

```dart
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../code/prism_face_selector_service.dart';
import '../contracts/normalized_rect.dart';

class PrismFaceSelectorPage extends StatefulWidget {
  const PrismFaceSelectorPage({super.key});

  @override
  State<PrismFaceSelectorPage> createState() => _PrismFaceSelectorPageState();
}

class _PrismFaceSelectorPageState extends State<PrismFaceSelectorPage> {
  static const _canvasWidth = 300.0;
  static const _canvasHeight = 210.0;

  String _selectedFace = 'front';
  Map<String, NormalizedRect?> _selections = defaultFaceSelectionMap();
  Offset? _dragStart;
  Rect? _draftRect;

  void _updateDraftRect(Offset currentPosition) {
    final start = _dragStart;
    if (start == null) {
      return;
    }

    final left = math.min(start.dx, currentPosition.dx).clamp(0.0, _canvasWidth);
    final top = math.min(start.dy, currentPosition.dy).clamp(0.0, _canvasHeight);
    final right = math.max(start.dx, currentPosition.dx).clamp(0.0, _canvasWidth);
    final bottom = math.max(start.dy, currentPosition.dy).clamp(0.0, _canvasHeight);

    setState(() {
      _draftRect = Rect.fromLTRB(left, top, right, bottom);
    });
  }

  String _summaryLine(String faceName, NormalizedRect? rect) {
    if (rect == null) {
      return '$faceName | unassigned';
    }

    return '$faceName | '
        '${rect.left.toStringAsFixed(2)}, '
        '${rect.top.toStringAsFixed(2)}, '
        '${rect.width.toStringAsFixed(2)}, '
        '${rect.height.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prism Face Selector')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Face slot'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: canonicalPrismFaces
                  .map(
                    (face) => ChoiceChip(
                      key: Key('face-$face'),
                      label: Text(face),
                      selected: _selectedFace == face,
                      onSelected: (_) {
                        setState(() {
                          _selectedFace = face;
                        });
                      },
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),
            const Text('Selection canvas'),
            const SizedBox(height: 8),
            GestureDetector(
              key: const Key('selection-canvas'),
              onPanStart: (details) {
                _dragStart = details.localPosition;
                _draftRect = null;
              },
              onPanUpdate: (details) {
                _updateDraftRect(details.localPosition);
              },
              onPanEnd: (_) {
                final rect = _draftRect;
                if (rect == null || rect.width <= 0 || rect.height <= 0) {
                  return;
                }

                final normalized = normalizeSelectionRect(
                  imageWidth: _canvasWidth,
                  imageHeight: _canvasHeight,
                  left: rect.left,
                  top: rect.top,
                  width: rect.width,
                  height: rect.height,
                );

                setState(() {
                  _selections = assignFaceSelection(
                    _selections,
                    _selectedFace,
                    normalized,
                  );
                  _draftRect = null;
                });
              },
              child: Container(
                width: _canvasWidth,
                height: _canvasHeight,
                decoration: BoxDecoration(
                  color: const Color(0xFFF6E7C1),
                  border: Border.all(color: Colors.brown),
                ),
                child: Stack(
                  children: [
                    const Positioned.fill(
                      child: Center(
                        child: Text('Sample cereal box sheet area'),
                      ),
                    ),
                    if (_draftRect != null)
                      Positioned(
                        left: _draftRect!.left,
                        top: _draftRect!.top,
                        child: Container(
                          width: _draftRect!.width,
                          height: _draftRect!.height,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue, width: 2),
                            color: Colors.blue.withValues(alpha: 0.15),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Selections'),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: canonicalPrismFaces
                    .map(
                      (face) => Text(
                        _summaryLine(face, _selections[face]),
                        key: Key('summary-$face'),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

Run:

```bash
just format
just check-all
git add --all
git commit --message "2. Green: Build The Prism Face Selector Page"
```

### 3. Red: Add The Integration Test

Create the integration test file:

```bash
mkdir -p workspace/integration_test
touch workspace/integration_test/app_test.dart
just format
git add --all
git commit --message 'touch workspace/integration_test/app_test.dart'
```

Put this exact content in `workspace/integration_test/app_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:prism_face_selector/adapter/prism_face_selector_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('renders the selector page title', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: PrismFaceSelectorPage()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Prism Face Selector'), findsOneWidget);
  });
}
```

Run:

```bash
just format
just check-all
git add --all
git commit --message "3. Red: Add The Integration Test"
```

### 4. Green: Wire The Real Application

Replace `workspace/lib/main.dart` with:

```dart
import 'package:flutter/material.dart';

import 'adapter/prism_face_selector_page.dart';

void main() {
  runApp(const PrismFaceSelectorApp());
}

class PrismFaceSelectorApp extends StatelessWidget {
  const PrismFaceSelectorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Prism Face Selector',
      home: PrismFaceSelectorPage(),
    );
  }
}
```

Run:

```bash
just format
just check-all
git add --all
git commit --message "4. Green: Wire The Real Application"
```
