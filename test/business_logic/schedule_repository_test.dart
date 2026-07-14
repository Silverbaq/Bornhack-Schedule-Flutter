import 'package:bornhack/business_logic/schedule.repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fakes.dart';

// Deliberately malformed: XmlDocument.parse throws on this, so it stands in
// for a captive-portal/corrupt-cache body that must never be persisted or
// silently accepted as a valid schedule.
const corruptXml = 'not valid xml <<<';

void main() {
  test('getSchedule returns disk cache without hitting network', () async {
    final api = FakeScheduleApi(twoDayXml);
    final storage = FakeScheduleStorage()..stored = oneDayXml;
    final repo = ScheduleRepository(api, storage);

    final schedule = await repo.getSchedule();

    expect(schedule.days.length, 1);
    expect(api.fetchCount, 0);
  });

  test('getSchedule returns empty when nothing is cached', () async {
    final api = FakeScheduleApi(oneDayXml);
    final repo = ScheduleRepository(api, FakeScheduleStorage());

    final schedule = await repo.getSchedule();

    expect(schedule.days, isEmpty);
    expect(api.fetchCount, 0);
  });

  test('refresh fetches, saves raw XML, and updates the cache', () async {
    final api = FakeScheduleApi(oneDayXml);
    final storage = FakeScheduleStorage();
    final repo = ScheduleRepository(api, storage);

    final schedule = await repo.refresh();

    expect(schedule.days.length, 1);
    expect(storage.stored, oneDayXml);
    expect(api.fetchCount, 1);
  });

  test('concurrent refresh calls dedupe to a single fetch', () async {
    final api = FakeScheduleApi(twoDayXml);
    final repo = ScheduleRepository(api, FakeScheduleStorage());

    final results = await Future.wait([repo.refresh(), repo.refresh()]);

    expect(api.fetchCount, 1);
    expect(results[0].days.length, 2);
    expect(results[1].days.length, 2);
  });

  test('refresh failure keeps the cache and allows a later retry', () async {
    final api = FakeScheduleApi(twoDayXml, throwError: true);
    final storage = FakeScheduleStorage()..stored = oneDayXml;
    final repo = ScheduleRepository(api, storage);

    await repo.getSchedule(); // load one-day cache into memory

    await expectLater(repo.refresh(), throwsException);
    expect((await repo.getSchedule()).days.length, 1); // cache intact

    api.throwError = false; // network recovers
    final refreshed = await repo.refresh();
    expect(refreshed.days.length, 2);
    // First refresh: 3 attempts (retry limit) all failed. Second refresh: 1
    // successful attempt. The 4th call proves the in-flight future was cleared
    // after the failure (a poisoned future would have returned without fetching).
    expect(api.fetchCount, 4);
  });

  test('refresh with a non-XML body leaves the previous good cache intact',
      () async {
    final api = FakeScheduleApi(corruptXml);
    final storage = FakeScheduleStorage()..stored = oneDayXml;
    final repo = ScheduleRepository(api, storage);

    await repo.getSchedule(); // load one-day cache into memory

    await expectLater(repo.refresh(), throwsA(anything));

    expect((await repo.getSchedule()).days.length, 1); // cache intact
    expect(storage.stored, oneDayXml); // disk untouched by the bad refresh
  });

  test('getSchedule with corrupt stored XML returns an empty Schedule',
      () async {
    final api = FakeScheduleApi(oneDayXml);
    final storage = FakeScheduleStorage()..stored = corruptXml;
    final repo = ScheduleRepository(api, storage);

    final schedule = await repo.getSchedule();

    expect(schedule.days, isEmpty);
    expect(api.fetchCount, 0);
  });

  test('refresh retries transient server errors then succeeds', () async {
    final api = FakeScheduleApi(oneDayXml, failuresBeforeSuccess: 2);
    final repo = ScheduleRepository(api, FakeScheduleStorage());

    final schedule = await repo.refresh();

    expect(schedule.days.length, 1);
    expect(api.fetchCount, 3); // failed twice, succeeded on the third attempt
  });

  test('refresh gives up after the retry limit and rethrows', () async {
    final api = FakeScheduleApi(oneDayXml, failuresBeforeSuccess: 99);
    final storage = FakeScheduleStorage()..stored = oneDayXml;
    final repo = ScheduleRepository(api, storage);
    await repo.getSchedule(); // one-day cache in memory

    await expectLater(repo.refresh(), throwsA(anything));

    expect(api.fetchCount, 3); // 3 attempts, then gives up
    expect((await repo.getSchedule()).days.length, 1); // cache preserved
  });
}
