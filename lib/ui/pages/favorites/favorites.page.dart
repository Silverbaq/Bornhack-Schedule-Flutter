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
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            )
          : ListView(
              children:
                  _listViewElements(context, vmodel.groupedFavoriteEvents),
            ),
    );
  }

  List<Widget> _listViewElements(BuildContext context, Map<String, List<Event>> values) {
    List<Widget> result = [];
    values.forEach((title, events) => {
          result.add(
            Container(
              margin: const EdgeInsets.fromLTRB(8, 16, 8, 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Color(0xFF0A1A12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.greenAccent.withOpacity(0.5)),
              ),
              child: Row(
                children: [
                  Icon(Icons.code, color: Colors.greenAccent),
                  SizedBox(width: 12),
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'VT323',
                      fontSize: 24,
                      color: Colors.greenAccent,
                    ),
                  ),
                ],
              ),
            ),
          ),
          result.add(EventsWidget(events))
        });
    return result;
  }
}