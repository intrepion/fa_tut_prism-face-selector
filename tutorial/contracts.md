# Contracts

Create the shared contract files:

```bash
mkdir -p workspace/lib/contracts
touch workspace/lib/contracts/normalized_rect.dart
just format
git add --all
git commit --message 'touch workspace/lib/contracts/normalized_rect.dart'
touch workspace/lib/contracts/prism_face_selection.dart
just format
git add --all
git commit --message 'touch workspace/lib/contracts/prism_face_selection.dart'
```

Put this exact content in `workspace/lib/contracts/normalized_rect.dart`:

```dart
class NormalizedRect {
  final double left;
  final double top;
  final double width;
  final double height;

  const NormalizedRect({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
  });
}
```

Put this exact content in `workspace/lib/contracts/prism_face_selection.dart`:

```dart
import 'normalized_rect.dart';

class PrismFaceSelection {
  final String faceName;
  final NormalizedRect? rect;

  const PrismFaceSelection({
    required this.faceName,
    required this.rect,
  });
}
```

Do not add tests here. Keep this layer limited to interfaces and small shared types.

Then run:

```bash
just format
just check-all
git add --all
git commit --message "Define prism-face-selector Flutter contracts"
```
