import '../contracts/normalized_rect.dart';

const canonicalPrismFaces = ['front', 'back', 'left', 'right', 'top', 'bottom'];

Map<String, NormalizedRect?> defaultFaceSelectionMap() {
  return {for (final face in canonicalPrismFaces) face: null};
}
