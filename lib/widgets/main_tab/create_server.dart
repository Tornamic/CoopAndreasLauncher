import 'package:coopandreas_launcher/classes/controllers_manipulate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:provider/provider.dart';
import '../../theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../theme/theme_provider.dart';

class CreateServerTab extends StatefulWidget {
  final int maxPlayers;
  final ValueChanged<int> onMaxPlayersChanged;
  final TextEditingController serverPortController;
  final TextEditingController serverMaxPlayersController;

  const CreateServerTab({super.key, required this.serverPortController, required this.serverMaxPlayersController, required this.maxPlayers, required this.onMaxPlayersChanged});

  @override
  State<CreateServerTab> createState() => _CreateServerState();
}

class _CreateServerState extends State<CreateServerTab> {

  late UndoHistoryController undoHistoryController = UndoHistoryController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    undoHistoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
            AppLocalizations.of(context)!.title_start_a_new_server,
            style: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w700
            ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 110.0),
          child: TextField(
              controller: widget.serverPortController,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.port,
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: !themeProvider.isDarkMode ? lightDarkColor : Colors.white
                  )
              ),
              keyboardType: TextInputType.number,
              undoController: undoHistoryController,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4)
              ],
              onTapOutside: (_) {
                ControllersManipulate.saveInputPlayerServerPort(widget.serverPortController.text);
              },
              onSubmitted: (value) {
                ControllersManipulate.saveInputPlayerServerPort(value);
              }
          ),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 110.0),
            child: TextField(
                controller: widget.serverMaxPlayersController,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.max_players,
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: !themeProvider.isDarkMode ? lightDarkColor : Colors.white
                    )
                ),
                keyboardType: TextInputType.number,
                undoController: undoHistoryController,
                textInputAction: TextInputAction.done,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(1)
                ],
                onTapOutside: (_) {
                  ControllersManipulate.saveInputPlayerServerMaxPlayers(widget.serverMaxPlayersController.text);
                },
                onSubmitted: (value) {
                  ControllersManipulate.saveInputPlayerServerMaxPlayers(value);
                },
            )
        ),
        AnimatedButton(
          height: 30,
          width: 140,
          isReverse: true,
          selectedTextColor: !themeProvider.isDarkMode ? Colors.white : Colors.black,
          selectedBackgroundColor: Colors.green,
          transitionType: TransitionType.LEFT_TO_RIGHT,
          backgroundColor: !themeProvider.isDarkMode ? lightButtonBackgroundColor : darkButtonBackgroundColor,
          text: AppLocalizations.of(context)!.start_server,
          borderRadius: 50,
          textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: !themeProvider.isDarkMode ? Colors.white : Colors.black
          ),
          animatedOn: AnimatedOn.onHover,
          onPress: () {

          },
        ),
      ].map((e) => Padding(
          padding: const EdgeInsets.all(5.0),
          child: e)
      ).toList()
    );
  }
}
