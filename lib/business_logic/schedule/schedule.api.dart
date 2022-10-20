import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:xml/xml.dart';

import 'model/schedule.model.dart';

@singleton
class ScheduleApi {
  final _dio = Dio();
  final _url = "https://bornhackredirect.vps.w4.dk";

  Future<Schedule> fetchSchedule() async {
    final results = await _dio.get(_url);
    var data = results.data;
    final document = XmlDocument.parse(data);

    Schedule schedule = Schedule.parseFromXml(document.firstElementChild!);
    return schedule;
  }

  @disposeMethod
  void dispose(){
    // logic to dispose instance
  }
}