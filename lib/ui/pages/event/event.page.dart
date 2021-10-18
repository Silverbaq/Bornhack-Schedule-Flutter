import 'package:bornhack/business_logic/model/event.model.dart';
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 9,
              child: Text(
                viewModel.event.title,
                style: TextStyle(fontSize: 24),
              ),
            ),

            Expanded(
              flex: 1,
              child: GestureDetector(
                  onTap: () {
                    viewModel.favoriteClicked();
                  },
                  child: Icon(viewModel.isEventAFavorite
                      ? Icons.favorite_outlined
                      : Icons.favorite_outline)),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      viewModel.dateTimeToStringFormat(viewModel.event.date),
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 5,
                  child: Card(
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      child: Text(
                        "Type: ${viewModel.event.type}",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Card(
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      child: Text(
                        "Speaker: ${viewModel.event.person.replaceAll("(", "").replaceAll(")", "")}",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 5,
                  child: Card(
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      child: Text(
                        "Duration: ${viewModel.event.duration}",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Card(
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      child: Text(
                        "Recording: ${viewModel.event.recording ? "Yes" : "No"}",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Card(
                child: Container(
                  child:  SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          viewModel.event.abstract,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
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
