import 'package:bornhack/business_logic/model/day.model.dart';
import 'package:flutter/material.dart';

import 'day_row.widget.dart';

class DaySelectionWidget extends StatefulWidget {
  DaySelectionWidget(this.days);

  final List<Day> days;

  @override
  State<StatefulWidget> createState() => _DaySelectionState();
}

class _DaySelectionState extends State<DaySelectionWidget> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.days.length,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: widget.days.map((e) => Tab(text: e.date.day.toString(),)).toList(),
          ),
          title: const Text('Bornhack'),
        ),
        body: TabBarView(
          children: widget.days.map((day) {
            return DayRowWidget(day);
          }).toList(),
        ),
      ),
    );
  }
}
