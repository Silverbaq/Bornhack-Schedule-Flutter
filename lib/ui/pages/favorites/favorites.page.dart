import 'package:bornhack/app.dart';
import 'package:bornhack/business_logic/model/event.model.dart';
import 'package:bornhack/ui/pages/favorites/favorites.view_model.dart';
import 'package:bornhack/ui/widgets/schedule/event.widget.dart';
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
      body: vmodel.groupedFavoriteEvents.isEmpty
          ? Center(
              child: Text(
                'You have no favorites events',
                style: Theme.of(context).textTheme.headline1,
              ),
            )
          : ListView(
              children:
                  _listViewElements(context, vmodel.groupedFavoriteEvents),
            ),
    );
  }

  List<Widget> _listViewElements(
      BuildContext context, Map<String, List<Event>> values) {
    List<Widget> result = [];
    values.forEach((title, events) => {
          result.add(Padding(
              padding: const EdgeInsets.fromLTRB(8, 16, 0, 0),
              child: Text(
                title,
                style: Theme.of(context).textTheme.headline1,
              ))),
          result.add(EventsWidget(events))
        });
    return result;
  }
}
