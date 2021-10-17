import 'package:bornhack/business_logic/model/schedule.model.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:xml/xml.dart';

@singleton
class ScheduleRepository {
  final _dio = Dio();
  final _url = "https://bornhack.dk/bornhack-2021/program/frab.xml";

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