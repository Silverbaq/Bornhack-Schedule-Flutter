import 'package:bornhack/business_logic/model/event.model.dart';
import 'package:bornhack/utils/favorites_storage.dart';
import 'package:intl/intl.dart';
import 'package:pmvvm/view_model.dart';

class EventViewModel extends ViewModel {
  EventViewModel(this.event);
  Event event;
  FavoriteStorage _favoriteStorage = FavoriteStorage();
  bool isEventAFavorite = false;

  @override
  void onBuild() {
    _checkIfEventIsFavorite();
  }

  void _checkIfEventIsFavorite() async {
    isEventAFavorite = await _favoriteStorage.isFavorite(event.eventId);
    notifyListeners();
  }

  void favoriteClicked() {
    if (isEventAFavorite) {
      _favoriteStorage.removeFavorite(event.eventId);
      isEventAFavorite = false;
    } else {
      _favoriteStorage.addFavorite(event.eventId);
      isEventAFavorite = true;
    }
    notifyListeners();
  }

  String dateTimeToStringFormat(DateTime date){
    String formattedDate = DateFormat('EEEE dd. MMM @ HH:mm').format(date);
    return formattedDate;
  }
}