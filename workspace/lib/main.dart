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
