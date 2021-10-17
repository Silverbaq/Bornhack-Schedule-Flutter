import 'package:bornhack/business_logic/model/day.model.dart';
import 'package:flutter/material.dart';

import 'day_row.widget.dart';

class DaySelectionWidget extends StatefulWidget {
  DaySelectionWidget(this.days);

  final List<Day> days;

  @override
  State<StatefulWidget> createState() => _DaySelectionState();
}

class _DaySelectionState extends State<DaySelectionWidget>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  Widget build(BuildContext context) {
    _tabController = TabController(
      initialIndex: 0,
      length: widget.days.length, //widget.days.length,
      vsync: this,
    );
    return Column(
      children: [
        TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            controller: _tabController,
            tabs: widget.days
                .map((e) => Tab(
                      text: e.date.day.toString(),
                    ))
                .toList()),
         Expanded(
           flex: 5,
           child: Container(
              child: TabBarView(
                  controller: _tabController,
                  children: widget.days.map((day) {
                    return DayRowWidget(day);
                  }).toList(),
                ),
              ),
         ),
      ],
    );
  }
}
