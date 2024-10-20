import 'package:coopandreas_launcher/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';
import 'classes/entry_point.dart';
import 'classes/storage_data.dart';
import 'language_provider.dart';
import 'constants.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  WindowManager.instance.setMaximizable(false);

  WindowOptions windowOptions = const WindowOptions(
    title: "CoopAndreas Launcher",
    size: Size(screenSizeX, screenSizeY),
    minimumSize: Size(screenSizeX, screenSizeY),
    maximumSize: Size(screenSizeX, screenSizeY),
    titleBarStyle: TitleBarStyle.hidden,
    center: false
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
     await windowManager.show();
     await windowManager.focus();
  });

  await StorageData.init();
  SharedPreferences prefs = StorageData.getSharedPreferences;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => LanguageProvider(prefs)
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(WidgetsBinding.instance.platformDispatcher.platformBrightness),
        ),
      ],
      child: const EntryPoint(),
    )
  );
}