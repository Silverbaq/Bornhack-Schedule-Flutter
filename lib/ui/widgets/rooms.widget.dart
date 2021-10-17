import 'package:bornhack/business_logic/model/room.model.dart';
import 'package:flutter/material.dart';

import 'event.widget.dart';

class RoomsWidget extends StatelessWidget {
  RoomsWidget(this.rooms);

  List<Room> rooms;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: rooms.map((room) {
          if (room.events.isNotEmpty) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                  child: Row(
                    children: [
                      Text(
                        room.name,
                        style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                EventsWidget(room.events),
              ],
            );
          } else {
            return SizedBox(
              height: 0,
            );
          }
        }).toList(),
      ),
    );
  }
}