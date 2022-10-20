import 'package:bornhack/business_logic/schedule/model/day.model.dart';
import 'package:bornhack/ui/widgets/schedule/DaySelectionViewModel.dart';
import 'package:flutter/material.dart';
import 'package:pmvvm/pmvvm.dart';

import 'day_row.widget.dart';

class DaySelectionWidget extends StatelessWidget {
  DaySelectionWidget(this.days);

  final List<Day> days;

  @override
  Widget build(BuildContext context) {
    return MVVM(
        view: () => _DaySelectionState(), viewModel: DaySelectionViewModel(days));
  }
}

class _DaySelectionState extends StatelessView<DaySelectionViewModel> {
  @override
  Widget render(BuildContext context, DaySelectionViewModel viewModel) {
    return DefaultTabController(
      length: viewModel.days.length,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: viewModel.days
                .map((e) => Tab(
                      text: e.date.day.toString(),
                    ))
                .toList(),
          ),
          title: const Text('Bornhack'),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    viewModel.changeLayoutClicked();
                  },
                  child: Icon(
                    viewModel.displayAsList ? Icons.meeting_room_outlined : Icons.list,
                    size: 26.0,
                  ),
                )),
          ],
        ),
        body: TabBarView(
          children: viewModel.days.map((day) {
            return DayRowWidget(day, viewModel.displayAsList);
          }).toList(),
        ),
      ),
    );
  }
}
