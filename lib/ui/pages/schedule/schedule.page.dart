import 'package:bornhack/ui/pages/schedule/schedule.view_model.dart';
import 'package:bornhack/ui/widgets/day_selection.widget.dart';
import 'package:flutter/material.dart';
import 'package:pmvvm/pmvvm.dart';

class SchedulePage extends StatelessWidget {
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