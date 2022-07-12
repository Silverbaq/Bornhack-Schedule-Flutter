import 'package:bornhack/business_logic/model/schedule.model.dart';
import 'package:bornhack/business_logic/model/event.model.dart';
import 'package:bornhack/business_logic/schedule.repository.dart';
import 'package:bornhack/utils/favorites_storage.dart';
import 'package:intl/intl.dart';
import 'package:pmvvm/pmvvm.dart';

class FavoritesViewModel extends ViewModel {
  FavoritesViewModel(this._scheduleRepository);

  final ScheduleRepository _scheduleRepository;
  Schedule _schedule = Schedule(List.empty());
  FavoriteStorage _favoriteStorage = FavoriteStorage();

  Map<String, List<Event>> groupedFavoriteEvents = Map();

  @override
  Future<void> onBuild() async {
    groupedFavoriteEvents.clear();
    _schedule = await _scheduleRepository.getSchedule();
    _schedule.days.forEach((dayElement) {
      dayElement.rooms.forEach((room) {
        room.events.forEach((event) async {
          bool isFavorite = await _favoriteStorage.isFavorite(event.eventId);
          if (isFavorite) {
            String weekday = DateFormat('EEEE, d. MMM').format(event.date);
            if (groupedFavoriteEvents.containsKey(weekday)) {
              groupedFavoriteEvents[weekday]?.add(event);
            } else {
              groupedFavoriteEvents[weekday] = [event];
            }
          }
        });
      });
    });

    notifyListeners();
  }
}