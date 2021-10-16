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

class Room {
  Room(this.name, this.events);

  String name;
  var events = <Event>[];

  static Room parseFromXml(XmlElement roomXml) {
    String name = roomXml.attributes.first.value;
    var events = <Event>[];
    roomXml.children.forEach((eventXml) {
      if (eventXml is XmlElement) {
        events.add(Event.parseFromXml(eventXml));
      }
    });

    return Room(name, events);
  }
}

class Event {
  Event(this.eventId, this.guid, this.date, this.title, this.abstract, this.url, this.duration, this.start,
      this.type, this.person);

  String eventId;
  String guid;
  DateTime date;
  String start;
  String duration;
  String url;
  String title;
  String type;
  String abstract;
  String person;

  static Event parseFromXml(XmlElement eventXml) {
    String eventId = "";
    String guid = "";
    DateTime date = DateTime.now();
    String start = "";
    String duration = "";
    String url = "";
    String title = "";
    String type = "";
    String abstract = "";
    String person = "";

    eventXml.attributes.forEach((attribute) {
      if (attribute.name.local == "id") {
        eventId = attribute.value;
      } else if (attribute.name.local == "guid") {
        guid = attribute.value;
      }
    });

    eventXml.children.forEach((element) {
      if (element is XmlElement) {
        if (element.name.local == "start") {
          start = element.children.first.text.toString();
        } else if (element.name.local == "duration") {
          duration = element.children.first.text.toString();
        } else if (element.name.local == "url") {
          url = element.children.first.text.toString();
        } else if (element.name.local == "title") {
          title = element.children.first.text.toString();
        } else if (element.name.local == "type") {
          type = element.children.first.text.toString();
        } else if (element.name.local == "abstract") {
          abstract = element.children.first.text.toString();
        } else if (element.name.local == "persons") {
          person = element.children.where((i) => !i.text.contains("\n") ).map((data) => data.text).toString();
        } else if (element.name.local == "date") {
          date = DateTime.parse(element.children.first.text);
        }
      }
    });
    return Event(eventId, guid, date, title, abstract, url, duration, start, type, person);
  }
}
