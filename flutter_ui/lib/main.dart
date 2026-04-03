import 'dart:io';

import 'package:flutter/material.dart';
import 'services/pos_client.dart';
import 'screens/register_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Allow override via env var for dev; default to systemd RuntimeDirectory.
  final socketPath = Platform.environment['VT_SOCKET']
      ?? '/tmp/viewtouch/pos.sock';
  PosClient.init(socketPath: socketPath);

  runApp(const ViewTouchApp());
}

class ViewTouchApp extends StatelessWidget {
  const ViewTouchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ViewTouch POS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
        // Large touch targets for greasy restaurant fingers.
        visualDensity: VisualDensity.standard,
      ),
      home: const RegisterScreen(),
    );
  }
}
