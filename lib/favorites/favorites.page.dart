import 'package:bornhack/favorites/favorites.view_model.dart';
import 'package:bornhack/ui/widgets/event.widget.dart';
import 'package:flutter/material.dart';
import 'package:pmvvm/pmvvm.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MVVM<FavoritesViewModel>(
      view: (context, vmodel) => _ScheduleWidget(),
      viewModel: FavoritesViewModel(),
    );
  }
}

class _ScheduleWidget extends StatelessView<FavoritesViewModel> {
  @override
  Widget render(context, vmodel) {
    return SingleChildScrollView(
      child: Expanded(
        child: Column(
          children: [EventsWidget(vmodel.favoriteEvents)],
        ),
      ),
    );
  }
}
