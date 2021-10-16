import 'package:localstorage/localstorage.dart';

class FavoriteStorage {
  final _storage = new LocalStorage('events');

  Future<bool> isFavorite(String eventId) async {
    bool isReady = await _storage.ready;
    if (isReady) {
      String id = _storage.getItem(eventId);
      return id == eventId;
    } else {
      return false;
    }
  }

  void addFavorite(String eventId) {
    _storage.setItem(eventId, eventId);
  }

  void removeFavorite(String eventId) {
    _storage.deleteItem(eventId);
  }
}