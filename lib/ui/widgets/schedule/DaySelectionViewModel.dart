import 'package:bornhack/business_logic/model/day.model.dart';
import 'package:bornhack/utils/settings_storage.dart';
import 'package:pmvvm/view_model.dart';

class DaySelectionViewModel extends ViewModel {
  DaySelectionViewModel(this.days) {
    _settingsStorage.isScheduleAList().then((value) => displayAsList = value);
  }

  SettingsStorage _settingsStorage = SettingsStorage();
  bool displayAsList = true;

  final List<Day> days;

  void changeLayoutClicked() {
    displayAsList = !displayAsList;
    _settingsStorage.updateScheduleDisplaySetting(!displayAsList);
    notifyListeners();
  }
}
