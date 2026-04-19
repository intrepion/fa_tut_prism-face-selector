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
