
import 'package:xml/xml.dart';

import 'event.model.dart';
import 'room.model.dart';

class Day {
  Day(this.index, this.date, this.start, this.end, this.rooms, this.events);

  int index;
  DateTime date;
  DateTime start;
  DateTime end;
  List<Room> rooms;
  List<Event> events;

  static Day parseFromXml(XmlElement dayXml) {
    var tmpIndex;
    var tmpDate;
    var start;
    var end;

    dayXml.attributes.forEach((element) {
      if (element.name.local == "index") {
        tmpIndex = int.parse(element.value);
      } else if (element.name.local == "date") {
        tmpDate = DateTime.parse(element.value);
      } else if (element.name.local == "start") {
        start = DateTime.parse(element.value);
      } else if (element.name.local == "end") {
        end = DateTime.parse(element.value);
      }
    });

    var rooms = <Room>[];
    dayXml.children.forEach((xmlNode) {
      if (xmlNode is XmlElement) {
        rooms.add(Room.parseFromXml(xmlNode));
      }
    });

    var events = rooms.expand((e) => e.events).toList();
    events.sort((a, b) => a.date.compareTo(b.date));

    return Day(tmpIndex, tmpDate, start, end, rooms, events);
  }
}