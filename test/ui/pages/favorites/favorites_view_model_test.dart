import 'package:bornhack/business_logic/schedule.repository.dart';
import 'package:bornhack/ui/pages/favorites/favorites.view_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../support/fakes.dart';

void main() {
  test('onBuild groups favorited events from the cache before refresh', () async {
    final api = FakeScheduleApi(favoritesXml);
    final storage = FakeScheduleStorage()..stored = favoritesXml;
    final vm = FavoritesViewModel(
      ScheduleRepository(api, storage),
      favoriteStorage: FakeFavoriteStorage({'e1'}),
    );

    await vm.onBuild();

    final all = vm.groupedFavoriteEvents.values.expand((e) => e).toList();
    expect(all.length, 1);
    expect(all.single.eventId, 'e1');
  });

  test('onBuild live-updates grouping after a refresh brings new data', () async {
    // Disk cache has no events; the refresh delivers the schedule containing e1.
    final api = FakeScheduleApi(favoritesXml);
    final storage = FakeScheduleStorage()..stored = twoDayXml; // no events
    final vm = FavoritesViewModel(
      ScheduleRepository(api, storage),
      favoriteStorage: FakeFavoriteStorage({'e1'}),
    );

    await vm.onBuild();

    final all = vm.groupedFavoriteEvents.values.expand((e) => e).toList();
    expect(all.length, 1);
    expect(all.single.eventId, 'e1');
  });
}
