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
        children: rooms.map((e) {
          if (e.events.isNotEmpty) {
            return Column(
              children: [
                Row(
                  children: [
                    Text(
                      e.name,
                      style:
                      TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                EventsWidget(e.events),
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