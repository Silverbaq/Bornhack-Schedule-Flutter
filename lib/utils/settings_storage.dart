import 'package:localstorage/localstorage.dart';

class SettingsStorage {
  final LocalStorage _storage = LocalStorage('settings');

  Future<int> getThemeIndex() async {
    await _storage.ready;
    return _storage.getItem('theme_index') ?? 0; // Default to dark theme
  }

  Future<void> setThemeIndex(int themeIndex) async {
    await _storage.ready;
    _storage.setItem('theme_index', themeIndex);
  }

  // Keep existing methods for backward compatibility
  Future<bool> isDarkMode() async {
    final themeIndex = await getThemeIndex();
    return themeIndex == 0; // Dark theme
  }

  Future<void> setDarkMode(bool isDarkMode) async {
    final themeIndex = isDarkMode ? 0 : 1;
    await setThemeIndex(themeIndex);
  }

  // ... existing code for other settings

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