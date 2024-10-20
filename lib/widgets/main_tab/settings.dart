import 'package:coopandreas_launcher/widgets/setting_background.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../classes/settings/game_path.dart';
import '../../constants.dart';
import '../../language_provider.dart';
import '../../theme/theme_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LauncherSettings extends StatefulWidget {
  final ValueChanged<String> onSelectedLanguageChanged;

  const LauncherSettings({super.key, required this.onSelectedLanguageChanged});

  @override
  State<LauncherSettings> createState() => _LauncherSettingsState();
}

class _LauncherSettingsState extends State<LauncherSettings> {

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Column(
      children: [
        SettingBackground(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            themeProvider: themeProvider,
            children: [
              IconButton(
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) => RotationTransition(
                    turns: child.key == const ValueKey('moon')
                        ? Tween(begin: 0.75, end: 1.0).animate(animation)
                        : Tween(begin: 0.25, end: 1.0).animate(animation),
                    child: ScaleTransition(scale: animation, child: child),
                  ),
                  child: themeProvider.isDarkMode
                      ? const Icon(Icons.dark_mode_rounded , key: ValueKey('moon')) // FAI.moon
                      : const Icon(Icons.light_mode, key: ValueKey('sun')), // FAI.solidSun
                ),
                onPressed: () async {
                  themeProvider.toggleTheme();
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.5),
                child: Text(
                  AppLocalizations.of(context)!.switch_theme,
                  style: TextStyle(
                      color: !themeProvider.isDarkMode ? Colors.black : Colors.white,
                      fontWeight: FontWeight.w600
                  ),
                ),
              ),
        ]),
        SettingBackground(
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          themeProvider: themeProvider,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 7.0, top: 5.0),
              child: Icon(Icons.translate, size: 23.0),
            ),
            DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                iconStyleData: IconStyleData(
                  iconEnabledColor: !themeProvider.isDarkMode ? Colors.black : Colors.white,
                  iconSize: 30
                ),
                value: launcherLanguages.entries.firstWhere((item) => item.key == languageProvider.locale.languageCode).value,
                onChanged: (String? value) {
                  widget.onSelectedLanguageChanged(value!);
                },
                buttonStyleData: const ButtonStyleData(
                    decoration: BoxDecoration(
                        color: Colors.transparent
                    ),
                    overlayColor: WidgetStatePropertyAll(Colors.transparent)
                ),
                items: launcherLanguages.entries.map((item) => DropdownMenuItem(
                  value: item.value,
                  child: Text(
                    item.value,
                    style: TextStyle(
                      fontSize: 14,
                      color: !themeProvider.isDarkMode ? Colors.black : Colors.white
                    ),
                  ),
                )).toList()
              ),
            ),
          ]
        ),
        SettingBackground(
          themeProvider: themeProvider,
          padding: EdgeInsets.symmetric(horizontal: 5),
          children: [
            IconButton(
                icon: Icon(Icons.more_horiz),
                onPressed: () async {
                  String? selectedDirectory = await FilePicker.platform.getDirectoryPath(lockParentWindow: true);

                  if (selectedDirectory != null) {
                    setState(() {
                      GamePath.setPath(selectedDirectory);
                    });
                  }
                }
            ),
            SizedBox(width: 4),
            Container(
              width: 413, // In the future make width auto along the length of SettingBackground
              padding: EdgeInsets.only(left: 5, top: 4.5, bottom: 4.5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                color: Color(0x2F000000)
              ),
              child: Text(
                GamePath.getPathEx(context),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: !GamePath.isGameFilesValid() ? Colors.red : !themeProvider.isDarkMode ? Colors.black : Colors.white,
                  fontWeight: FontWeight.w500
                ),
              ),
            )
          ]
        )
      ],
    );
  }
}
