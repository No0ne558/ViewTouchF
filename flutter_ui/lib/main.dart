import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viewtouch_ui/l10n/app_localizations.dart';

import 'services/pos_client.dart';
import 'services/locale_provider.dart';
// touch_mode_provider was removed; keep imports minimal
import 'screens/register_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final localeProvider = LocaleProvider();
  await localeProvider.loadLocale();

  // Allow override via env var; default to /opt/viewtouchf install path.
  final socketPath =
      Platform.environment['VT_SOCKET'] ?? '/opt/viewtouchf/run/pos.sock';
  PosClient.init(socketPath: socketPath);

  runApp(
    ChangeNotifierProvider.value(
      value: localeProvider,
      child: const ViewTouchApp(),
    ),
  );
}

class ViewTouchApp extends StatelessWidget {
  const ViewTouchApp({super.key});

  // Design resolution — all widgets are authored for this size.
  // On larger screens everything scales up proportionally.
  static const double _baseWidth = 1920.0;
  static const double _baseHeight = 1080.0;

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      title: 'ViewTouchF',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
        visualDensity: VisualDensity.standard,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: localeProvider.locale,
      // builder wraps the entire Navigator + Overlay, so dialogs,
      // snackbars, and bottom sheets all scale with the UI.
      builder: (context, child) {
        final mq = MediaQuery.of(context);
        final screenW = mq.size.width;
        final screenH = mq.size.height;

        // Uniform scale — pick the smaller axis so nothing overflows.
        final baseScale = math.min(screenW / _baseWidth, screenH / _baseHeight);

        // Allow a global override multiplier via environment for small/resistive
        // touch panels. Set VT_UI_SCALE=1.2 to enlarge UI by 20%.
        final configuredScale = double.tryParse(
              Platform.environment['VT_UI_SCALE'] ?? '',
            ) ??
            1.0;
        // Clamp to a reasonable range to avoid extreme layouts.
        final clampedConfigured = configuredScale.clamp(0.8, 2.0);

        // Final scale must be at least 1.0 (we don't scale down below 1.0),
        // but the configured multiplier can push it above 1.0 on small screens.
        final scale = math.max(1.0, baseScale * clampedConfigured);

        // If no scaling required, just return child.
        if (scale <= 1.0) return child!;

        // Logical resolution the child tree lays out at.
        final logicalW = screenW / scale;
        final logicalH = screenH / scale;

        return MediaQuery(
          data: mq.copyWith(size: Size(logicalW, logicalH)),
          child: FittedBox(
            fit: BoxFit.fill,
            alignment: Alignment.topLeft,
            child: SizedBox(width: logicalW, height: logicalH, child: child),
          ),
        );
      },
      home: const RegisterScreen(),
    );
  }
}
