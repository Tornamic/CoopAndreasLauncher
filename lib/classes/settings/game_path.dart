import 'dart:io';
import 'package:coopandreas_launcher/classes/settings/game_constants.dart';
import 'package:flutter/cupertino.dart';
import '../storage_data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GamePath
{
    static String _path = '';
    static String _executableGamePath = '';
    static String _modPath = '';

    static get getPath => _path;
    static get isPathEmpty => _path.isEmpty;

    static bool isGameExecutableAbsentInPath() {
        File gameExecutableFile = File(_executableGamePath);

        return gameExecutableFile.existsSync();
    }

    static bool isGameModAbsentInPath() {
        File gameModeFile = File(_modPath);

        return gameModeFile.existsSync();
    }

    static bool isGameFilesValid() {

        if(GamePath.isPathEmpty || !isGameExecutableAbsentInPath() || !isGameModAbsentInPath()) {
            return false;
        }

        return true;
    }

    static String getPathEx(BuildContext context) {

        if(GamePath.isPathEmpty) {
            return AppLocalizations.of(context)!.game_path_not_set;
        }

        if(!isGameExecutableAbsentInPath()) {
            return AppLocalizations.of(context)!.game_not_found;
        }

        if(!isGameModAbsentInPath()) {
            return AppLocalizations.of(context)!.mod_not_found(gameModName);
        }

        return GamePath.getPath;
    }

    static void setPath(String path) {
      _path = path;
      _executableGamePath = '$path/gta_sa.exe';
      _modPath = '$path/$gameModName';
      StorageData.setStorageStringFieldData(gameFolderPathKey, path);
    }
}