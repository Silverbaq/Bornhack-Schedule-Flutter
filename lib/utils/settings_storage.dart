import 'package:localstorage/localstorage.dart';

class SettingsStorage {
  final _storage = new LocalStorage('settings');

  Future<bool> isScheduleAList() async {
    bool isReady = await _storage.ready;
    if (isReady) {
      String? id = _storage.getItem('scheduleIsAList');
      return id != null;
    } else {
      return false;
    }
  }

  void updateScheduleDisplaySetting(bool isList) {
    if (isList) {
      _storage.deleteItem('scheduleIsAList');
    } else {
      _storage.setItem('scheduleIsAList', isList);
    }
  }

}