import 'package:injectable/injectable.dart';
import 'package:localstorage/localstorage.dart';

@singleton
class ScheduleStorage {
  final LocalStorage _storage = LocalStorage('schedule');

  Future<String?> getXml() async {
    await _storage.ready;
    return _storage.getItem('xml') as String?;
  }

  Future<void> saveXml(String xml) async {
    await _storage.ready;
    await _storage.setItem('xml', xml);
  }
}
