import 'package:bornhack/business_logic/model/schedule.model.dart';
import 'package:bornhack/business_logic/schedule.api.dart';
import 'package:bornhack/utils/schedule_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:xml/xml.dart';

@singleton
class ScheduleRepository {
  ScheduleRepository(this._scheduleApi, this._scheduleStorage);

  final ScheduleApi _scheduleApi;
  final ScheduleStorage _scheduleStorage;
  Schedule _schedule = Schedule(List.empty());
  Future<Schedule>? _inFlight;

  /// Cache-only. Never hits the network. Returns an empty Schedule on first
  /// launch (nothing in memory or on disk) — refresh() fills it.
  Future<Schedule> getSchedule() async {
    if (_schedule.days.isNotEmpty) return _schedule;

    final cachedXml = await _scheduleStorage.getXml();
    if (cachedXml != null) {
      _schedule = _parse(cachedXml);
    }
    return _schedule;
  }

  /// Always network. Fetches, persists raw XML, updates the in-memory cache.
  /// Concurrent calls share one in-flight fetch; the future is cleared on
  /// completion (success or failure) so a later launch can retry.
  Future<Schedule> refresh() => _inFlight ??= _doRefresh();

  Future<Schedule> _doRefresh() async {
    try {
      final xml = await _scheduleApi.fetchXml();
      await _scheduleStorage.saveXml(xml);
      _schedule = _parse(xml);
      return _schedule;
    } finally {
      _inFlight = null;
    }
  }

  Schedule _parse(String xml) =>
      Schedule.parseFromXml(XmlDocument.parse(xml).firstElementChild!);

  @disposeMethod
  void dispose() {
    // logic to dispose instance
  }
}
