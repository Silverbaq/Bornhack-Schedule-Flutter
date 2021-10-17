import 'package:bornhack/business_logic/model/room.model.dart';
import 'package:xml/xml.dart';

class Day {
  Day(this.index, this.date, this.start, this.end, this.rooms);

  int index;
  DateTime date;
  DateTime start;
  DateTime end;
  List<Room> rooms;

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

    return Day(tmpIndex, tmpDate, start, end, rooms);
  }
}