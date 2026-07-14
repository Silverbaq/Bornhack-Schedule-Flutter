import 'package:bornhack/business_logic/schedule.api.dart';
import 'package:bornhack/utils/favorites_storage.dart';
import 'package:bornhack/utils/schedule_storage.dart';

class FakeScheduleApi extends ScheduleApi {
  FakeScheduleApi(this.xmlToReturn, {this.throwError = false});
  String xmlToReturn;
  bool throwError;
  int fetchCount = 0;

  @override
  Future<String> fetchXml() async {
    fetchCount++;
    if (throwError) throw Exception('offline');
    return xmlToReturn;
  }
}

class FakeScheduleStorage extends ScheduleStorage {
  String? stored;
  int saveCount = 0;

  @override
  Future<String?> getXml() async => stored;

  @override
  Future<void> saveXml(String xml) async {
    stored = xml;
    saveCount++;
  }
}

class FakeFavoriteStorage extends FavoriteStorage {
  FakeFavoriteStorage(this.favs);
  final Set<String> favs;

  @override
  Future<bool> isFavorite(String eventId) async => favs.contains(eventId);
}

// One-day schedule, no rooms/events — enough to assert days.isNotEmpty and round-trip.
const oneDayXml =
    '<schedule><day index="1" date="2026-08-01" '
    'start="2026-08-01T09:00:00" end="2026-08-01T18:00:00"></day></schedule>';

// Two-day schedule — distinguishable from the one-day cache after a refresh.
const twoDayXml =
    '<schedule>'
    '<day index="1" date="2026-08-01" start="2026-08-01T09:00:00" end="2026-08-01T18:00:00"></day>'
    '<day index="2" date="2026-08-02" start="2026-08-02T09:00:00" end="2026-08-02T18:00:00"></day>'
    '</schedule>';

// One day, one room, two events; e1 is the one we favorite in tests.
const favoritesXml =
    '<schedule>'
    '<day index="1" date="2026-08-01" start="2026-08-01T09:00:00" end="2026-08-01T18:00:00">'
    '<room name="Hall">'
    '<event id="e1"><date>2026-08-01T10:00:00</date><title>Keynote</title></event>'
    '<event id="e2"><date>2026-08-01T12:00:00</date><title>Workshop</title></event>'
    '</room></day></schedule>';
