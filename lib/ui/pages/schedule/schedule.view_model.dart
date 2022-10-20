import 'package:bornhack/business_logic/schedule/model/schedule.model.dart';
import 'package:bornhack/business_logic/schedule/schedule.repository.dart';
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
}