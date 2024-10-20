import 'storage_data.dart';

class ControllersManipulate {
  static void saveInputPlayerNickName(String value) {
    StorageData.setStorageStringFieldData('nickName', value);
  }

  static void saveInputPlayerConnectIpPort(String value) {
    StorageData.setStorageStringFieldData('connectIpPort', value);
  }

  static void saveInputPlayerServerPort(String value) {
    StorageData.setStorageStringFieldData('serverPort', value);
  }

  static void saveInputPlayerServerMaxPlayers(String value) {
    StorageData.setStorageStringFieldData('serverMaxPlayers', value);
  }
}