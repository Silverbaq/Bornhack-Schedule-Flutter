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
                  padding: const EdgeInsets.fromLTRB(8, 16, 0, 8),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Color(0xFF0A1A12),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.greenAccent.withOpacity(0.4)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.computer, color: Colors.greenAccent, size: 18),
                        SizedBox(width: 8),
                        Text(
                          room.name,
                          style: TextStyle(
                            fontFamily: 'VT323',
                            fontSize: 22,
                            color: Colors.greenAccent,
                          ),
                        ),
                      ],
                    ),
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