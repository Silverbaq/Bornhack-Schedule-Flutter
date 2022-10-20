import 'package:bornhack/business_logic/schedule/model/day.model.dart';
import 'package:bornhack/utils/settings_storage.dart';
import 'package:pmvvm/view_model.dart';

class DaySelectionViewModel extends ViewModel {
  DaySelectionViewModel(this.days) {
    _settingsStorage.isScheduleAList().then((value) => displayAsList = value);
  }

  SettingsStorage _settingsStorage = SettingsStorage();
  bool displayAsList = false;

  final List<Day> days;

  void changeLayoutClicked() {
    displayAsList = !displayAsList;
    _settingsStorage.updateScheduleDisplaySetting(!displayAsList);
    notifyListeners();
  }
}
