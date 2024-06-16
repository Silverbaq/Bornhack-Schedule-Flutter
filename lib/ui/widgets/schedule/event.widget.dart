import 'package:bornhack/business_logic/model/event.model.dart';
import 'package:bornhack/ui/pages/event/event.page.dart';
import 'package:bornhack/utils/favorites_storage.dart';
import 'package:bornhack/utils/notifications.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventsWidget extends StatefulWidget {
  EventsWidget(this.events);

  List<Event> events;

  @override
  State<StatefulWidget> createState() => _EventsWidget(events);
}

class _EventsWidget extends State<EventsWidget> with TickerProviderStateMixin {
  _EventsWidget(this.events);

  List<Event> events;
  FavoriteStorage _favoriteStorage = FavoriteStorage();

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();

    return Container(
      child: Column(
        children: events.map((e) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 2.0),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, createRouter(e));
                },
                child: FadeTransition(
                  opacity: _animation,
                  child: Card(
                    elevation: 5,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                DateFormat('HH:mm').format(e.date),
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              FutureBuilder(
                                  future: _favoriteStorage.isFavorite(e.eventId),
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    if (snapshot.hasData) {
                                      if (snapshot.data) {
                                        return GestureDetector(
                                            onTap: () async {
                                              await removeScheduledNotification(
                                                  int.parse(e.eventId));
                                              _favoriteStorage
                                                  .removeFavorite(e.eventId);
                                              setState(() {});
                                            },
                                            child: Icon(Icons.favorite_outlined));
                                      } else {
                                        return GestureDetector(
                                            onTap: () async {
                                              NotificationData data =
                                                  NotificationData(
                                                      int.parse(e.eventId),
                                                      e.title,
                                                      e.abstract,
                                                      e.date);
                                              await createScheduledNotification(
                                                  data);
                                              _favoriteStorage
                                                  .addFavorite(e.eventId);
                                              setState(() {});
                                            },
                                            child: Icon(Icons.favorite_outline));
                                      }
                                    } else {
                                      return GestureDetector(
                                          onTap: () async {
                                            NotificationData data =
                                                NotificationData(
                                                    int.parse(e.eventId),
                                                    e.title,
                                                    e.abstract,
                                                    e.date);
                                            await createScheduledNotification(
                                                data);
                                            _favoriteStorage
                                                .addFavorite(e.eventId);
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
            ),
          );
        }).toList(),
      ),
    );
  }
}

PageRouteBuilder createRouter(Event event) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => EventPage(event),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}


class EventCard extends AnimatedWidget {
  EventCard({required Listenable listenable}) : super(listenable: listenable);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}