import 'package:xml/xml.dart';

class Event {
  Event(this.eventId, this.guid, this.date, this.title, this.abstract, this.url, this.duration, this.start,
      this.type, this.person, this.recording);

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
        } else if (element.name.local == "recording") {
          String recordingString = element.toString();
          if (recordingString.contains("true")) {
            recording = true;
          } else {
            recording = false;
          }
        }
      }
    }
    );
    return Event(eventId, guid, date, title, abstract, url, duration, start, type, person, recording);
  }
}