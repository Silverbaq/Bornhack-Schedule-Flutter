import 'package:localstorage/localstorage.dart';

class FavoriteStorage {
  // localstorage v6 is a single global store, so namespace favorite keys to
  // avoid collisions with the (formerly separate) settings/schedule keys.
  String _key(String eventId) => 'fav_$eventId';

  Future<bool> isFavorite(String eventId) async {
    return localStorage.getItem(_key(eventId)) != null;
  }

  void addFavorite(String eventId) {
    localStorage.setItem(_key(eventId), eventId);
  }

  void removeFavorite(String eventId) {
    localStorage.removeItem(_key(eventId));
  }
}
