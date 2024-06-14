import 'package:bornhack/business_logic/model/event.model.dart';
import 'package:bornhack/ui/widgets/event/info_card.widget.dart';
import 'package:flutter/material.dart';
import 'package:pmvvm/pmvvm.dart';

import 'event.view_model.dart';

class EventPage extends StatelessWidget {
  EventPage(this.event);

  Event event;

  @override
  Widget build(BuildContext context) {
    return MVVM<EventViewModel>(
      view: () => _EventPage(),
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
                  onTap: () async {
                    await viewModel.favoriteClicked();
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
              elevation: 5,
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
                  child: InfoCardWidget("Type", "${viewModel.event.type}"),
                ),
                Expanded(
                  flex: 5,
                  child: InfoCardWidget("Speaker",
                      "${viewModel.event.person.replaceAll("(", "").replaceAll(")", "")}"),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 5,
                  child:
                      InfoCardWidget("Duration", formatDuration(viewModel.event.duration)),
                ),
                Expanded(
                  flex: 5,
                  child: InfoCardWidget(
                    "Recording",
                    "${viewModel.event.recording ? "No" : "Yes"}",
                  ),
                ),
              ],
            ),
            Expanded(
              child: Card(
                elevation: 5,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 5, child: Text("Abstract")),
                        Expanded(
                          flex: 95,
                          child: SingleChildScrollView(
                            child: Text(
                              viewModel.event.abstract,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
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

String formatDuration(String duration) {
  var split = duration.split(":");
  int hours = int.parse(split[0]);
  int minutes = int.parse(split[1]);

  String time = "";

  if (hours == 1) {
    time = "1 hour";
  } else if (hours > 1) {
    time = "$hours hours";
  }

  if (minutes == 1) {
    time += " 1 minute";
  } else if (minutes > 1) {
    time += " $minutes minutes";
  }

  return time;
}