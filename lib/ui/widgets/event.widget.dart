import 'package:bornhack/business_logic/model/event.model.dart';
import 'package:bornhack/ui/pages/event/event.page.dart';
import 'package:bornhack/utils/favorites_storage.dart';
import 'package:flutter/material.dart';

class EventsWidget extends StatefulWidget {
  EventsWidget(this.events);
  List<Event> events;

  @override
  State<StatefulWidget> createState() => _EventsWidget(events);

}

class _EventsWidget extends State<EventsWidget> {
  _EventsWidget(this.events);

  List<Event> events;
  FavoriteStorage _favoriteStorage = FavoriteStorage();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: events.map((e) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EventPage(e)),
                  );
                },
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(e.start),
                            FutureBuilder(
                                future: _favoriteStorage.isFavorite(e.eventId),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot.data) {
                                      return GestureDetector(onTap: () {
                                        _favoriteStorage.removeFavorite(e.eventId);
                                        setState(() {});
                                      },
                                          child: Icon(Icons.favorite_outlined));
                                    } else {
                                      return GestureDetector(onTap: () { _favoriteStorage.addFavorite(e.eventId);
                                      setState(() {});
                                      },
                                          child: Icon(Icons.favorite_outline));
                                    }
                                  } else {
                                    return GestureDetector(onTap: () { _favoriteStorage.addFavorite(e.eventId);
                                    setState(() {});
                                    },
                                        child: Icon(Icons.favorite_outline));
                                  }
                                }),
                          ],
                        ),
                        title: Text(e.title),
                        subtitle: Text(e.person),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
