import 'package:injectable/injectable.dart';
import 'package:localstorage/localstorage.dart';

@singleton
class ScheduleStorage {
  Future<String?> getXml() async {
    return localStorage.getItem('xml');
  }

  Future<void> saveXml(String xml) async {
    localStorage.setItem('xml', xml);
  }
}
