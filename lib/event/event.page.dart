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
  @override
  Widget render(BuildContext context, EventViewModel viewModel) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
                onTap: () {
                  viewModel.favoriteClicked();
                },
                child: Icon(viewModel.isEventAFavorite
                    ? Icons.favorite_outlined
                    : Icons.favorite_outline)),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              viewModel.event.title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              child: Column(
                children: [
                  Text(
                    viewModel.dateTimeToStringFormat(viewModel.event.date),
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Type: ${viewModel.event.type}",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        "Speaker: ${viewModel.event.person.replaceAll("(", "").replaceAll(")", "")}",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Duration: ${viewModel.event.duration}",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        "Recording: ${viewModel.event.recording ? "Yes" : "No"}",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: [],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              child: Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  child: Text(
                    viewModel.event.abstract,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}
