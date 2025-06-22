import 'package:bornhack/business_logic/model/event.model.dart';
import 'package:xml/xml.dart';

class Room {
  Room(this.name, this.events);

  String name;
  var events = <Event>[];

  static Room parseFromXml(XmlElement roomXml) {
    String name = roomXml.attributes.first.value;
    var events = <Event>[];
    roomXml.children.forEach((eventXml) {
      if (eventXml is XmlElement) {
        events.add(Event.parseFromXml(eventXml, room: name));
      }
    });

    return Room(name, events);
  }
}