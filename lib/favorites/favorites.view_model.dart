import 'package:bornhack/schedule/model/schedule.model.dart';
import 'package:bornhack/schedule/schedule.repository.dart';
import 'package:bornhack/utils/favorites_storage.dart';
import 'package:pmvvm/pmvvm.dart';

class FavoritesViewModel extends ViewModel {
  final _scheduleRepository = ScheduleRepository();
  Schedule _schedule = Schedule(List.empty());
  FavoriteStorage _favoriteStorage = FavoriteStorage();

  List<Event> favoriteEvents = <Event>[];

  @override
  Future<void> onBuild() async {
    favoriteEvents.clear();
    _schedule = await _scheduleRepository.fetchSchedule();
    _schedule.days.forEach((dayElement) {
      dayElement.rooms.forEach((room) {
        room.events.forEach((event) async {
          bool isFavorite = await _favoriteStorage.isFavorite(event.eventId);
          if (isFavorite) {
            favoriteEvents.add(event);
          }
        });
      });
    });
    notifyListeners();
  }
}