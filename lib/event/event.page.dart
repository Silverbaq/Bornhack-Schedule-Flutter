import 'package:bornhack/schedule/model/schedule.model.dart';
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
      appBar: AppBar(title: Text(viewModel.event.title),),
      body: Column(
        children: [Text(viewModel.event.title)],
      ),
    );
  }

}