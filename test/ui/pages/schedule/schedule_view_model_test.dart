import 'package:bornhack/business_logic/schedule.repository.dart';
import 'package:bornhack/ui/pages/schedule/schedule.view_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../support/fakes.dart';

void main() {
  test('onBuild shows cache then live-swaps to the refreshed schedule', () async {
    final api = FakeScheduleApi(twoDayXml);
    final storage = FakeScheduleStorage()..stored = oneDayXml;
    final vm = ScheduleViewModel(ScheduleRepository(api, storage));

    await vm.onBuild();

    expect(vm.schedule.days.length, 2); // refreshed data won
    expect(vm.loading, isFalse);
    expect(api.fetchCount, 1);
  });

  test('onBuild keeps the cached schedule when the refresh fails offline', () async {
    final api = FakeScheduleApi('', throwError: true);
    final storage = FakeScheduleStorage()..stored = oneDayXml;
    final vm = ScheduleViewModel(ScheduleRepository(api, storage));

    await vm.onBuild();

    expect(vm.schedule.days.length, 1); // cache retained
    expect(vm.loading, isFalse);
  });
}
