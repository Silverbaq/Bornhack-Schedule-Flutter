import 'package:bornhack/business_logic/model/schedule.model.dart';
import 'package:bornhack/business_logic/schedule.api.dart';
import 'package:injectable/injectable.dart';

@singleton
class ScheduleRepository {
  ScheduleRepository(this._scheduleApi);

  final ScheduleApi _scheduleApi;
  Schedule _schedule = Schedule(List.empty());

  Future<Schedule> getSchedule() async {
    if (_schedule.days.isEmpty) {
      _schedule = await _scheduleApi.fetchSchedule();
    }
    return _schedule;
  }

  @disposeMethod
  void dispose() {
    // logic to dispose instance
  }
}