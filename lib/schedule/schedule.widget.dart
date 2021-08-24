import 'package:bornhack/event/event.page.dart';
import 'package:bornhack/schedule/schedule.view_model.dart';
import 'package:flutter/material.dart';
import 'package:pmvvm/pmvvm.dart';

import 'model/schedule.model.dart';

class ScheduleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MVVM<ScheduleViewModel>(
      view: (context, vmodel) => _ScheduleWidget(),
      viewModel: ScheduleViewModel(),
    );
  }
}

class _ScheduleWidget extends StatelessView<ScheduleViewModel> {
  @override
  Widget render(context, vmodel) {
    return DaySelectionWidget(vmodel.schedule.days);
  }
}

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
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                    TabBar(
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.grey,
                        controller: _tabController,
                        tabs: widget.days
                            .map((e) => Tab(
                                  text: e.date.day.toString(),
                                ))
                            .toList())
                  ] +
                  widget.days.map((day) {
                    return DayRowWidget(day);
                  }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class DayRowWidget extends StatelessWidget {
  DayRowWidget(this.day);

  final Day day;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          day.date.toLocal().toString(),
          style: TextStyle(fontSize: 18),
        ),
        RoomsWidget(day.rooms),
      ],
    );
  }
}

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

class EventsWidget extends StatelessWidget {
  EventsWidget(this.events);

  List<Event> events;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: events.map((e) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EventPage(e)),
                  );
                },
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Text(e.start),
                        title: Text(e.title),
                        subtitle: Text(e.person),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
