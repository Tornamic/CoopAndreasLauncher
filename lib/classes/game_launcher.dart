import 'dart:io';
import 'launch_result.dart';
import 'settings/game_constants.dart';
import 'settings/game_path.dart';

class GameLauncher {

  static List<dynamic> parseIpPort(String value) {
    RegExp regex = RegExp(r'\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?):\d{1,4}\b');
    Match? match = regex.firstMatch(value);
    bool result = false;
    String? ip;
    int? port;

    if (match != null) {
      List<String> parts = match.group(0)!.split(':');
      ip = parts[0];
      port = int.parse(parts[1]);
      result = true;
    }

    return [result, ip, port];
  }

  static Future<LaunchResultType> tryStartGame(String nickName, String ipPort) async {

    final String gameFolderPath = GamePath.getPath;

    if(gameFolderPath.isEmpty) {
      return LaunchResultType.gameFolderPathNotSet;
    }

    final String gameExecutableFilePath = '$gameFolderPath\\gta_sa.exe';
    final String modPath = '$gameFolderPath\\$gameModName';

    File gameExecutableFile = File(gameExecutableFilePath);

    if(!gameExecutableFile.existsSync()) {
      return LaunchResultType.gameNotFound;
    }

    File modFile = File(modPath);

    if(!modFile.existsSync()) {
      return LaunchResultType.modNotFound;
    }

    List<dynamic> parseData = GameLauncher.parseIpPort(ipPort);

    if (!parseData[0]) {
      return LaunchResultType.parseError;
    }

    String? ip;
    int? port;

    ip = parseData[1];
    port = parseData[2];

    List<String> args = [
      '-name',
      nickName,
      '-ip',
      ip!,
      '-port',
      port.toString()
    ];

    await Process.start(
        gameExecutableFilePath,
        args,
        workingDirectory: gameFolderPath,
        mode: ProcessStartMode.normal
    );

    return LaunchResultType.success;
  }
}
