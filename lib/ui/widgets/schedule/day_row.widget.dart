import 'package:bornhack/business_logic/model/day.model.dart';
import 'package:bornhack/ui/widgets/schedule/event.widget.dart';
import 'package:bornhack/ui/widgets/schedule/rooms.widget.dart';
import 'package:bornhack/utils/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
          Container(
            margin: const EdgeInsets.fromLTRB(0, 16, 0, 24),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppThemes.getTerminalBorder(context)),
              boxShadow: [
                BoxShadow(
                  color: AppThemes.getAccentColor(context).withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 1,
                )
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.terminal, color: AppThemes.getAccentColor(context)),
                SizedBox(width: 12),
                Text(
                  formatter.format(day.date.toLocal()),
                  style: TextStyle(
                    fontFamily: 'VT323',
                    fontSize: 28,
                    color: AppThemes.getAccentColor(context),
                    letterSpacing: 1.2,
                  ),
                ),
              ],
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