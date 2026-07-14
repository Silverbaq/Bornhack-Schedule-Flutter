import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bornhack/business_logic/model/schedule.model.dart';
import 'package:bornhack/business_logic/schedule.repository.dart';
import 'package:pmvvm/pmvvm.dart';

class ScheduleViewModel extends ViewModel {
  ScheduleViewModel(this._scheduleRepository);

  final ScheduleRepository _scheduleRepository;
  Schedule schedule = Schedule(List.empty());
  // Must start true: the schedule view (DaySelectionWidget) wraps its days in a
  // nested MVVM whose ViewModel is captured once at first build. If the first
  // frame renders it with an empty schedule, it stays empty forever. Showing a
  // spinner until data is present means it is only ever built with real days.
  bool loading = true;

  @override
  Future<void> onBuild() async {
    schedule = await _scheduleRepository.getSchedule(); // instant (empty on first launch)
    loading = schedule.days.isEmpty;                    // spinner only while empty
    notifyListeners();
    try {
      schedule = await _scheduleRepository.refresh();   // network
    } catch (_) {
      // offline / transient server error: keep the cached schedule (or stay empty on first launch)
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