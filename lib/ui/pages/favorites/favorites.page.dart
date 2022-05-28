import 'package:bornhack/app.dart';
import 'package:bornhack/ui/pages/favorites/favorites.view_model.dart';
import 'package:bornhack/ui/widgets/schedule/event.widget.dart';
import 'package:bornhack/utils/notifications.dart';
import 'package:flutter/material.dart';
import 'package:pmvvm/pmvvm.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MVVM<FavoritesViewModel>(
      view: () => _ScheduleWidget(),
      viewModel: FavoritesViewModel(getIt.get()),
    );
  }
}

class _ScheduleWidget extends StatelessView<FavoritesViewModel> {
  @override
  Widget render(context, vmodel) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: SingleChildScrollView(
        child: Expanded(
          child: Column(
            children: [
              EventsWidget(vmodel.favoriteEvents)
            ],
          ),
        ),
      ),
    );
  }
}
