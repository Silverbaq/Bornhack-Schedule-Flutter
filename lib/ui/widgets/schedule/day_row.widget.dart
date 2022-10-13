import 'package:bornhack/business_logic/model/day.model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'event.widget.dart';
import 'rooms.widget.dart';

class DayRowWidget extends StatelessWidget {
  DayRowWidget(this.day, this.displayAsList);

  final Day day;
  final bool displayAsList;

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('EEEE dd. MMM');

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 16, 0, 32),
            child: Text(
              formatter.format(day.date.toLocal()),
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
          if (!displayAsList)
            RoomsWidget(day.rooms),
          if (displayAsList)
            EventsWidget(day.events),

        ],
      ),
    );
  }
}