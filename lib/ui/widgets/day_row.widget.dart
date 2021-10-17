import 'package:bornhack/business_logic/model/day.model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'rooms.widget.dart';

class DayRowWidget extends StatelessWidget {
  DayRowWidget(this.day);

  final Day day;

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('EEEE dd. MMM');

    return Column(
      children: [
        Text(
          formatter.format(day.date.toLocal()),
          style: TextStyle(fontSize: 18),
        ),
        RoomsWidget(day.rooms),
      ],
    );
  }
}