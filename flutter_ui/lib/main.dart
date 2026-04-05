import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'services/pos_client.dart';
import 'screens/register_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Allow override via env var; default to /opt/viewtouchf install path.
  final socketPath = Platform.environment['VT_SOCKET']
      ?? '/opt/viewtouchf/run/pos.sock';
  PosClient.init(socketPath: socketPath);

  runApp(const ViewTouchApp());
}

class ViewTouchApp extends StatelessWidget {
  const ViewTouchApp({super.key});

  // Design resolution — all widgets are authored for this size.
  // On larger screens everything scales up proportionally.
  static const double _baseWidth  = 1920.0;
  static const double _baseHeight = 1080.0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ViewTouchF',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
        visualDensity: VisualDensity.standard,
      ),
      // builder wraps the entire Navigator + Overlay, so dialogs,
      // snackbars, and bottom sheets all scale with the UI.
      builder: (context, child) {
        final mq = MediaQuery.of(context);
        final screenW = mq.size.width;
        final screenH = mq.size.height;

        // Uniform scale — pick the smaller axis so nothing overflows.
        final scale = math.max(1.0, math.min(
          screenW / _baseWidth,
          screenH / _baseHeight,
        ));

        // At 1920×1080 or below, render 1:1 — no scaling needed.
        if (scale <= 1.0) return child!;

        // Logical resolution the child tree lays out at.
        final logicalW = screenW / scale;
        final logicalH = screenH / scale;

        return MediaQuery(
          data: mq.copyWith(size: Size(logicalW, logicalH)),
          child: FittedBox(
            fit: BoxFit.fill,
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: logicalW,
              height: logicalH,
              child: child,
            ),
          ),
        );
      },
      home: const RegisterScreen(),
    );
  }
}
