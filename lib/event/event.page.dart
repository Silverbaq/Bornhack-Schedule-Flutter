import 'package:bornhack/schedule/model/schedule.model.dart';
import 'package:bornhack/utils/favorites_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pmvvm/pmvvm.dart';

import 'event.view_model.dart';

class EventPage extends StatelessWidget {
  EventPage(this.event);

  Event event;

  @override
  Widget build(BuildContext context) {
    return MVVM<EventViewModel>(
      view: (context, vmodel) => _EventPage(),
      viewModel: EventViewModel(event),
    );
  }
}

class _EventPage extends StatelessView<EventViewModel> {
  FavoriteStorage _favoriteStorage = FavoriteStorage();

  @override
  Widget render(BuildContext context, EventViewModel viewModel) {
    return Scaffold(
      appBar: AppBar(
        title: Text(viewModel.event.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  viewModel.event.title,
                  style: TextStyle(fontSize: 24),
                ),
                GestureDetector(
                    onTap: () {
                      viewModel.favoriteClicked();
                    },
                    child: Icon( viewModel.isEventAFavorite ? Icons.favorite_outlined : Icons.favorite_outline)
                ),


              ],
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              child: Text(
                viewModel.event.abstract,
                style: TextStyle(fontSize: 16),
              ),
            ),
            Text(viewModel.event.person),
            Text(viewModel.event.start),
            Text(viewModel.event.duration),
            Text(viewModel.event.type),
            Text(viewModel.event.date.toIso8601String()),
            Text(viewModel.event.recording.toString()),
          ],
        ),
      ),
    );
  }
}
