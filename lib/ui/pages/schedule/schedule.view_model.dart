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
    loading = true;
    notifyListeners();
    schedule = await _scheduleRepository.getSchedule();
    loading = false;
    notifyListeners();
  }

  @override
  void onResume() {
    AwesomeNotifications().setGlobalBadgeCounter(0);

    super.onResume();
  }
}