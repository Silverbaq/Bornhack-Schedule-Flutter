import 'package:xml/xml.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;


class Event {
  Event(this.eventId, this.guid, this.date, this.title, this.abstract, this.url, this.duration, this.start,
      this.type, this.person, this.recording, this.room);

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
  bool recording;
  String room;

  static Event parseFromXml(XmlElement eventXml, {String room = ""}) {
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
    bool recording = false;


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
          start = start.substring(0, start.length - 3);
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
          tz.initializeTimeZones();

          final DateTime orgDateTime = DateTime.parse(element.children.first.text);
          final pacificTimeZone = tz.getLocation('Europe/Copenhagen');

          date = tz.TZDateTime.from(orgDateTime, pacificTimeZone);
        } else if (element.name.local == "recording") {
          String recordingString = element.toString();
          if (recordingString.contains("true")) {
            recording = false;
          } else {
            recording = true;
          }
        }
      }
    }
    );
    return Event(eventId, guid, date, title, abstract, url, duration, start, type, person, recording, room);
  }
}