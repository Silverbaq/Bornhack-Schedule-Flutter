import 'package:bornhack/app.dart';
import 'package:bornhack/ui/pages/schedule/schedule.view_model.dart';
import 'package:bornhack/ui/widgets/schedule/day_selection.widget.dart';
import 'package:flutter/material.dart';
import 'package:pmvvm/pmvvm.dart';

class SchedulePage extends StatelessWidget {
  final VoidCallback onThemeToggle;

  SchedulePage({required this.onThemeToggle});

  @override
  Widget build(BuildContext context) {
    return MVVM<ScheduleViewModel>(
      view: () => _ScheduleWidget(onThemeToggle: onThemeToggle,),
      viewModel: ScheduleViewModel(getIt.get()),
    );
  }
}

class _ScheduleWidget extends StatelessView<ScheduleViewModel> {
  final VoidCallback onThemeToggle;

  _ScheduleWidget({required this.onThemeToggle});

  @override
  Widget render(context, vmodel) {
    if (vmodel.loading) {
      return Center(child: CircularProgressIndicator(color: Colors.white,));
    } else {
      return DaySelectionWidget(vmodel.schedule.days, onThemeToggle: onThemeToggle,);
    }
  }
}