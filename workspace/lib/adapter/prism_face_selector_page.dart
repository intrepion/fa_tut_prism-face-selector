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

    final left = math
        .min(start.dx, currentPosition.dx)
        .clamp(0.0, _canvasWidth);
    final top = math
        .min(start.dy, currentPosition.dy)
        .clamp(0.0, _canvasHeight);
    final right = math
        .max(start.dx, currentPosition.dx)
        .clamp(0.0, _canvasWidth);
    final bottom = math
        .max(start.dy, currentPosition.dy)
        .clamp(0.0, _canvasHeight);

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
