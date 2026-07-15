import 'package:localstorage/localstorage.dart';

class SettingsStorage {
  Future<int> getThemeIndex() async {
    return int.tryParse(localStorage.getItem('theme_index') ?? '') ??
        0; // Default to dark theme
  }

  Future<void> setThemeIndex(int themeIndex) async {
    localStorage.setItem('theme_index', themeIndex.toString());
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
    // Presence of the key is the flag; the stored value is irrelevant.
    return localStorage.getItem('scheduleIsAList') != null;
  }

  void updateScheduleDisplaySetting(bool isList) {
    if (isList) {
      localStorage.removeItem('scheduleIsAList');
    } else {
      localStorage.setItem('scheduleIsAList', 'true');
    }
  }
}
