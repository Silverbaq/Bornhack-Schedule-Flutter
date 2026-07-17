import 'package:bornhack/app.dart';
import 'package:bornhack/business_logic/schedule.repository.dart';
import 'package:bornhack/ui/pages/schedule/schedule.page.dart';
import 'package:bornhack/utils/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../support/fakes.dart';
import '../../../support/test_storage.dart';

void main() {
  setUp(initTestLocalStorage); // DaySelectionViewModel reads SettingsStorage
  tearDown(getIt.reset);

  // Regression: the first frame must not build DaySelectionWidget with an empty
  // schedule. Its nested MVVM captures the ViewModel once, so an empty first
  // build would leave the day tabs permanently empty even after data arrives.
  testWidgets('SchedulePage renders day tabs once the schedule loads',
      (tester) async {
    getIt.registerSingleton<ScheduleRepository>(
      ScheduleRepository(
        FakeScheduleApi(favoritesXml),
        FakeScheduleStorage()..stored = favoritesXml, // instant cache
      ),
    );

    await tester.pumpWidget(MaterialApp(
      theme: AppThemes.darkTheme,
      home: SchedulePage(onThemeToggle: () {}),
    ));
    // Let the async getSchedule resolve and the view rebuild. Not pumpAndSettle:
    // the event cards run a repeating pulse animation that never settles.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    // The day tab (date 2026-08-01) reached the tab bar.
    expect(find.text('AUG'), findsWidgets);
  });
}
