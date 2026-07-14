import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bornhack/business_logic/model/schedule.model.dart';
import 'package:bornhack/business_logic/schedule.repository.dart';
import 'package:pmvvm/pmvvm.dart';

class ScheduleViewModel extends ViewModel {
  ScheduleViewModel(this._scheduleRepository);

  final ScheduleRepository _scheduleRepository;
  Schedule schedule = Schedule(List.empty());
  bool loading = false;

  @override
  Future<void> onBuild() async {
    schedule = await _scheduleRepository.getSchedule(); // instant (empty on first launch)
    loading = schedule.days.isEmpty;                    // spinner only while empty
    notifyListeners();
    try {
      schedule = await _scheduleRepository.refresh();   // network
    } catch (_) {
      // offline: keep showing the cached schedule (or stay empty on first launch)
    }
    loading = false;
    notifyListeners();                                  // silent live swap / drop spinner
  }

  @override
  void onResume() {
    AwesomeNotifications().setGlobalBadgeCounter(0);
    super.onResume();
  }
}