import 'dart:async';

import 'package:coopandreas_launcher/classes/controllers_manipulate.dart';
import 'package:coopandreas_launcher/theme/theme.dart';
import 'package:provider/provider.dart';
import '../../classes/connect_to_server/nickname_field.dart';
import '../../classes/connect_to_server/ip_port_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../classes/game_launcher.dart';
import '../../classes/launch_result.dart';
import '../../constants.dart';
import '../../theme/theme_provider.dart';

class ConnectToServerTab extends StatefulWidget {
  final TextEditingController nickNameController;
  final TextEditingController ipPortController;

  const ConnectToServerTab({super.key, required this.nickNameController, required this.ipPortController});

  @override
  State<ConnectToServerTab> createState() => _ConnectToServerTabState();
}

class _ConnectToServerTabState extends State<ConnectToServerTab> {

  late NickNameField nickNameField = NickNameField(onNickNameFieldFocusChange);
  late IpPortField ipPortField = IpPortField(onIpPortFieldFocusChange);
  late UndoHistoryController undoHistoryController = UndoHistoryController();

  bool _isConnectButtonHovered = false;
  bool _isPressedConnect = false;
  LaunchResultType _lastLaunchResult = LaunchResultType.success;
  Timer? _hideFailedLaunchResultTimer;

  @override
  void initState() {
    nickNameField.toggleNickNameValid(nickNameField.getNickNameRegExp.hasMatch(widget.nickNameController.text));
    ipPortField.toggleIpPortValid(ipPortField.getIpPortRegExp.hasMatch(widget.ipPortController.text));
    super.initState();
  }

  @override
  void dispose() {
    nickNameField.getNickNameFocusNode.dispose();
    ipPortField.getIpPortFocusNode.dispose();
    undoHistoryController.dispose();
    _hideFailedLaunchResultTimer?.cancel();
    LaunchResult.toggleVisibilityFailedLaunch(false);
    super.dispose();
  }

  void onNickNameFieldFocusChange() {

    bool hasFocus = nickNameField.getNickNameFocusNode.hasFocus;

    setState(() {

      if(_isPressedConnect && hasFocus) {
        _isPressedConnect = false;
      }

      nickNameField.toggleNickNameFocusing(hasFocus);
    });
  }

  void onIpPortFieldFocusChange() async {

    bool hasFocus = ipPortField.getIpPortFocusNode.hasFocus;

    setState(() {
        if(_isPressedConnect && hasFocus) {
          _isPressedConnect = false;
        }

        ipPortField.toggleIpPortFocusing(hasFocus);
      });
  }

  void onPressedConnectButton() async {

      FocusScope.of(context).unfocus();

      bool isNickNameValid = nickNameField.isNickNameValid;
      bool isIpPortValid = ipPortField.isIpPortValid;

      if(!isNickNameValid) {
        setState(() {
          if(!nickNameField.isNickNameFieldFocusing) {
            _isPressedConnect = true;
          }
        });
      }

      if(!isIpPortValid) {
        setState(() {
          if(!ipPortField.isIpPortFieldFocusing) {
            _isPressedConnect = true;
          }
        });
      }

      if(!(isNickNameValid & isIpPortValid)) {
        return;
      }

      _lastLaunchResult = await GameLauncher.tryStartGame(widget.nickNameController.text, widget.ipPortController.text);

      if(_lastLaunchResult != LaunchResultType.success) {
        LaunchResult.toggleVisibilityFailedLaunch(true);

        _hideFailedLaunchResultTimer?.cancel();
        _hideFailedLaunchResultTimer = Timer(const Duration(seconds: 2, milliseconds: 500), () {
          setState(() {
            LaunchResult.toggleVisibilityFailedLaunch(false);
          });
        });
      }
  }

  @override
  Widget build(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
            AppLocalizations.of(context)!.title_connect_to_server,
            style: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w700
            )
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 75.0),
          child: TextField(
            controller: widget.nickNameController,
            focusNode: nickNameField.getNickNameFocusNode,
            undoController: undoHistoryController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.nickname,
                labelStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: !nickNameField.isNickNameValidEx(_isPressedConnect) ? Colors.red : (!themeProvider.isDarkMode ? lightDarkColor : Colors.white)
                ),
                errorText: !nickNameField.isNickNameValidEx(_isPressedConnect) ? AppLocalizations.of(context)!.invalid_nickname(minPlayerNicknameCharacters, maxPlayerNicknameCharacters) : null
            ),
            inputFormatters: [
              FilteringTextInputFormatter.singleLineFormatter,
              LengthLimitingTextInputFormatter(32)
            ],
            onTapOutside: (_) {
              ControllersManipulate.saveInputPlayerNickName(widget.nickNameController.text);
              if(!_isConnectButtonHovered) {
                FocusScope.of(context).unfocus();
              }
            },
            onSubmitted: (value) {
              ControllersManipulate.saveInputPlayerNickName(value);
            },
            onChanged: (value) {
              setState(() {
                nickNameField.toggleNickNameValid(nickNameField.getNickNameRegExp.hasMatch(value));
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 75.0),
          child: TextField(
            controller: widget.ipPortController,
            focusNode: ipPortField.getIpPortFocusNode,
            undoController: undoHistoryController,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.ip_port(AppLocalizations.of(context)!.port),
                labelStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: !ipPortField.isIpPortValidEx(_isPressedConnect) ? Colors.red : (!themeProvider.isDarkMode ? lightDarkColor : Colors.white)
                ),
                errorText: !ipPortField.isIpPortValidEx(_isPressedConnect) ? AppLocalizations.of(context)!.invalid_ip_port(defaultServerAddress) : null
            ),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.singleLineFormatter,
              LengthLimitingTextInputFormatter(19)
            ],
            onTapOutside: (_) {
              ControllersManipulate.saveInputPlayerConnectIpPort(widget.ipPortController.text);
              if(!_isConnectButtonHovered) {
                FocusScope.of(context).unfocus();
              }
            },
            onSubmitted: (String value) {
              ControllersManipulate.saveInputPlayerConnectIpPort(value);
              onPressedConnectButton();
            },
            onChanged: (value) {
              setState(() {
                ipPortField.toggleIpPortValid(ipPortField.getIpPortRegExp.hasMatch(value));
              });
            },
          ),
        ),
        Visibility(
          visible: LaunchResult.isVisibilityFailedLaunch,
          child: Text(
            LaunchResult.getFailedLaunchResult(context, _lastLaunchResult),
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w600
          ),
        )),
        MouseRegion(
          onEnter: (_) => setState(() => _isConnectButtonHovered = true),
          onExit: (_) => setState(() => _isConnectButtonHovered = false),
          child: TextButton(
              style: const ButtonStyle(
                fixedSize: WidgetStatePropertyAll(Size(128.0, 0.0))
              ),
              onPressed: onPressedConnectButton,
              child: AnimatedSwitcher(
                  switchInCurve: Curves.ease,
                  switchOutCurve: Curves.ease,
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: _isConnectButtonHovered ?
                  Icon(
                      FontAwesomeIcons.play,
                      color: !themeProvider.isDarkMode ? Colors.white : Colors.black
                  ) :
                  Text(
                      AppLocalizations.of(context)!.connect,
                      style: TextStyle(
                          color: !themeProvider.isDarkMode ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold
                      )
                  )
              )
          ),
        )
      ].map((e) => Padding(
          padding: const EdgeInsets.all(5.0),
          child: e)
      ).toList()
          );
  }
}