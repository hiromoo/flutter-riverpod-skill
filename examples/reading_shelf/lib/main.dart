import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/composition_root.dart';
import 'app/reading_shelf_app.dart';

void main() {
  runApp(ProviderScope(overrides: createAppOverrides(), child: const ReadingShelfApp()));
}
