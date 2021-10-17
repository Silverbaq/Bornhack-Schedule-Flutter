import 'package:bornhack/business_logic/model/schedule.model.dart';
import 'package:bornhack/business_logic/schedule.repository.dart';
import 'package:pmvvm/pmvvm.dart';

class ScheduleViewModel extends ViewModel {
  final _scheduleRepository = ScheduleRepository();
  Schedule schedule = Schedule(List.empty());

  @override
  Future<void> onBuild() async {
    schedule = await _scheduleRepository.fetchSchedule();
    notifyListeners();
  }
}