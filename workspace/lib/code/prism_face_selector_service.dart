import '../contracts/normalized_rect.dart';

const canonicalPrismFaces = ['front', 'back', 'left', 'right', 'top', 'bottom'];

Map<String, NormalizedRect?> defaultFaceSelectionMap() {
  return {for (final face in canonicalPrismFaces) face: null};
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
