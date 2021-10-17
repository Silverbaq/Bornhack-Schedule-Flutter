import 'package:bornhack/business_logic/model/day.model.dart';
import 'package:xml/xml.dart';

class Schedule {
  Schedule(this.days);

  List<Day> days = <Day>[];

  static Schedule parseFromXml(XmlElement xml) {
    final tmpDays = <Day>[];
    xml.children.forEach((element) {
      if (element is XmlElement && element.name.local == "day") {
        Day day = Day.parseFromXml(element);
        tmpDays.add(day);
      }
    });
    return Schedule(tmpDays);
  }
}






