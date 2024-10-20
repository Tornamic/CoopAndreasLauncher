import 'package:coopandreas_launcher/theme/theme_provider.dart';

import 'classes/storage_data.dart';
import 'widgets/mod_info.dart';
import '../classes/mouse_hover_state.dart';
import 'theme/theme.dart';
import '../widgets/main_tab/authors.dart';
import '../widgets/main_tab/settings.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'language_provider.dart';
import 'widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'widgets/custom_tab.dart';
import 'widgets/main_tab/connect_to_server.dart';
import 'widgets/main_tab/create_server.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CoopAndreasLauncher extends StatefulWidget {
  const CoopAndreasLauncher({super.key});

  @override
  State<CoopAndreasLauncher> createState() => _CoopAndreasLauncherState();
}

class _CoopAndreasLauncherState extends State<CoopAndreasLauncher> with TickerProviderStateMixin {
  final TextEditingController nickNameController = TextEditingController(text: StorageData.getStorageStringFieldData('nickName'));
  final TextEditingController ipPortController = TextEditingController(text: StorageData.getStorageStringFieldData('connectIpPort'));
  final TextEditingController serverPortController = TextEditingController(text: StorageData.getStorageStringFieldData('serverPort'));
  final TextEditingController serverMaxPlayersController = TextEditingController(text: StorageData.getStorageStringFieldData('serverMaxPlayers'));

  int maxPlayers = 2;
  int _currentPage = 0;

  late PageController _pageController;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    nickNameController.dispose();
    ipPortController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
        appBar: CustomAppBar(
          actions: [
            MouseRegion(
              onEnter: (_) => setState(() => MouseHoverState.enableMouseHovered()),
              onExit: (_) => setState(() => MouseHoverState.disableMouseHovered()),
              child: Row(
                children: [
                  IconButton(
                      icon: Icon(
                        color: !themeProvider.isDarkMode ? tabLabelTextColorLightTheme : greyColor,
                        FontAwesomeIcons.info,
                      ),
                      iconSize: 20.0,
                      onPressed: () => getAuthorsDialog(context, themeProvider)
                  ),
                  IconButton(
                    icon: Icon(
                        FontAwesomeIcons.gear,
                        color: _currentPage == 1 ?
                        (!themeProvider.isDarkMode ? lightDarkColor : Colors.white) :
                        (!themeProvider.isDarkMode ? tabLabelTextColorLightTheme : greyColor)
                    ),
                    iconSize: 20.0,
                    onPressed: () {
                      _pageController.animateToPage(1, duration: kTabScrollDuration, curve: Curves.ease);
                      setState(() {});
                    },
                  ),
                  IconButton(
                    icon: Icon(
                        Icons.minimize,
                        color: !themeProvider.isDarkMode ? tabLabelTextColorLightTheme : greyColor
                    ),
                    iconSize: 20.0,
                    onPressed: () {
                      windowManager.minimize();
                    },
                  ),
                  IconButton(
                    icon: Icon(
                        Icons.close,
                        color: !themeProvider.isDarkMode ? tabLabelTextColorLightTheme : greyColor
                    ),
                    iconSize: 20.0,
                    onPressed: () {
                      windowManager.close();
                    },
                  )
                ],
              ),
            )
          ],
          leadingWidth: 180,
          leading: TabBar(
              labelColor: _currentPage == 0 ? (!themeProvider.isDarkMode ? lightDarkColor : Colors.white) : (!themeProvider.isDarkMode ? tabLabelTextColorLightTheme : greyColor),
              controller: _tabController,
              indicatorColor: Colors.transparent,
              padding: EdgeInsets.zero,
              indicatorPadding: EdgeInsets.zero,
              dividerColor: Colors.transparent,
              tabAlignment: TabAlignment.center,
              indicatorSize: TabBarIndicatorSize.label,
              onTap: (index) {
                if(_currentPage == 1) {
                  _pageController.animateToPage(0, duration: kTabScrollDuration, curve: Curves.ease);
                }
                setState(() {});
              },
              tabs: [
                CustomTab(
                    iconData: FontAwesomeIcons.plug,
                    data: AppLocalizations.of(context)!.connect,
                    tabController: _tabController,
                    currentPage: _currentPage,
                    tabIndex: 0
                ),
                CustomTab(
                    iconData: FontAwesomeIcons.server,
                    data: AppLocalizations.of(context)!.server,
                    tabController: _tabController,
                    currentPage: _currentPage,
                    tabIndex: 1
                )
              ]
          ),
          title: const Text(
            'CoopAndreas',
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        body: Stack(
          children: [
            PageView(
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  TabBarView(
                      controller: _tabController,
                      children: [
                        ConnectToServerTab(nickNameController: nickNameController, ipPortController: ipPortController),
                        CreateServerTab(serverPortController: serverPortController, serverMaxPlayersController: serverMaxPlayersController, maxPlayers: maxPlayers, onMaxPlayersChanged: (value) {
                          setState(() {
                            maxPlayers = value;
                          });
                        })
                      ]
                  ),
                  LauncherSettings(onSelectedLanguageChanged: (String? value) {
                    setState(() {
                      languageProvider.setLocale(Locale(launcherLanguages.entries.firstWhere((item) => item.value == value!).key));
                    });
                  })
                ]
            ),
            const ModInfo()
          ],
        )
    );
  }
}