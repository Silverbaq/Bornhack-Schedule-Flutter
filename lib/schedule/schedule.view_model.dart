import 'package:pmvvm/pmvvm.dart';

import 'model/schedule.model.dart';
import 'schedule.repository.dart';

class ScheduleViewModel extends ViewModel {
  final _scheduleRepository = ScheduleRepository();
  Schedule schedule = Schedule(List.empty());

  @override
  Future<void> onBuild() async {
    schedule = await _scheduleRepository.fetchSchedule();
    notifyListeners();
  }
}