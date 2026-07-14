import 'package:bornhack/business_logic/model/schedule.model.dart';
import 'package:bornhack/business_logic/model/event.model.dart';
import 'package:bornhack/business_logic/schedule.repository.dart';
import 'package:bornhack/utils/favorites_storage.dart';
import 'package:intl/intl.dart';
import 'package:pmvvm/pmvvm.dart';

class FavoritesViewModel extends ViewModel {
  FavoritesViewModel(this._scheduleRepository, {FavoriteStorage? favoriteStorage})
      : _favoriteStorage = favoriteStorage ?? FavoriteStorage();

  final ScheduleRepository _scheduleRepository;
  final FavoriteStorage _favoriteStorage;
  Schedule _schedule = Schedule(List.empty());

  Map<String, List<Event>> groupedFavoriteEvents = Map();

  @override
  Future<void> onBuild() async {
    _schedule = await _scheduleRepository.getSchedule(); // instant from cache
    await _rebuild();
    try {
      _schedule = await _scheduleRepository.refresh();   // network
      await _rebuild();                                  // live update
    } catch (_) {
      // offline: keep the cached grouping
    }
  }

  Future<void> _rebuild() async {
    final grouped = <String, List<Event>>{};
    for (final day in _schedule.days) {
      for (final room in day.rooms) {
        for (final event in room.events) {
          if (await _favoriteStorage.isFavorite(event.eventId)) {
            final weekday = DateFormat('EEEE, d. MMM').format(event.date);
            (grouped[weekday] ??= []).add(event);
          }
        }
      }
    }
    for (final events in grouped.values) {
      events.sort((a, b) => a.date.compareTo(b.date));
    }
    groupedFavoriteEvents = grouped;
    notifyListeners();
  }
}
