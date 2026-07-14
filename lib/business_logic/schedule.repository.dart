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
      try {
        _schedule = _parse(cachedXml);
      } catch (_) {
        // corrupt cache: leave empty; refresh() will overwrite it
      }
    }
    return _schedule;
  }

  /// Always network. Fetches, persists raw XML, updates the in-memory cache.
  /// Concurrent calls share one in-flight fetch; the future is cleared on
  /// completion (success or failure) so a later launch can retry.
  Future<Schedule> refresh() => _inFlight ??= _doRefresh();

  Future<Schedule> _doRefresh() async {
    try {
      final xml = await _fetchWithRetry();
      _schedule = _parse(xml); // validate by parsing first
      await _scheduleStorage.saveXml(xml); // persist only valid XML
      return _schedule;
    } finally {
      _inFlight = null;
    }
  }

  /// The feed's server returns intermittent 5xx errors; retry a few times with
  /// a short backoff so a transient failure doesn't leave a fresh install (no
  /// cache yet) blank. Rethrows after the last attempt so refresh() still falls
  /// back to the cache. ponytail: fixed 3 attempts, bump if the feed gets flakier.
  Future<String> _fetchWithRetry({int attempts = 3}) async {
    for (var i = 0; ; i++) {
      try {
        return await _scheduleApi.fetchXml();
      } catch (_) {
        if (i >= attempts - 1) rethrow;
        await Future.delayed(Duration(milliseconds: 400 * (i + 1)));
      }
    }
  }

  Schedule _parse(String xml) =>
      Schedule.parseFromXml(XmlDocument.parse(xml).firstElementChild!);

  @disposeMethod
  void dispose() {
    // logic to dispose instance
  }
}
