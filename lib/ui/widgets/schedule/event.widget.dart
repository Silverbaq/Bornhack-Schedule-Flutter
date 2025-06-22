import 'package:bornhack/business_logic/model/event.model.dart';
import 'package:bornhack/ui/pages/event/event.page.dart';
import 'package:bornhack/utils/favorites_storage.dart';
import 'package:bornhack/utils/notifications.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

class EventsWidget extends StatefulWidget {
  EventsWidget(this.events);

  final List<Event> events;

  @override
  State<StatefulWidget> createState() => _EventsWidget(events);
}

class _EventsWidget extends State<EventsWidget> with TickerProviderStateMixin {
  _EventsWidget(this.events);

  final List<Event> events;
  final FavoriteStorage _favoriteStorage = FavoriteStorage();

  late AnimationController _controller;
  late Animation<double> _animation;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic);
    
    _pulseController = AnimationController(
      vsync: this, 
      duration: Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(_pulseController);
    
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();

    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final e = events[index];
          final delay = Duration(milliseconds: 100 * index);
          
          // Check if event is today
          final now = DateTime.now();
          final isToday = e.date.year == now.year && 
                          e.date.month == now.month && 
                          e.date.day == now.day;
          
          Future.delayed(delay, () {
            if (_controller.isCompleted) _controller.reset();
            _controller.forward();
          });
          
          return EventCard(
            event: e,
            animation: _animation,
            isToday: isToday,
            onTap: () {
              Navigator.push(context, createRouter(e));
            },
            onFavoriteToggle: () async {
              final isFavorite = await _favoriteStorage.isFavorite(e.eventId);
              if (isFavorite) {
                await removeScheduledNotification(int.parse(e.eventId));
                _favoriteStorage.removeFavorite(e.eventId);
              } else {
                NotificationData data = NotificationData(
                  int.parse(e.eventId), e.title, e.abstract, e.date);
                await createScheduledNotification(data);
                _favoriteStorage.addFavorite(e.eventId);
              }
              setState(() {});
            },
            favoriteStorage: _favoriteStorage,
            pulseAnimation: _pulseAnimation,
          );
        },
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
  final Event event;
  final bool isToday;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;
  final FavoriteStorage favoriteStorage;
  final Animation<double> pulseAnimation;
  
  EventCard({
    required this.event, 
    required Animation<double> animation,
    this.isToday = false,
    required this.onTap,
    required this.onFavoriteToggle,
    required this.favoriteStorage,
    required this.pulseAnimation,
  }) : super(listenable: animation);
  
  Animation<double> get animation => listenable as Animation<double>;
  
  @override
  Widget build(BuildContext context) {
    final e = event;
    
    return Transform.translate(
      offset: Offset(30 * (1 - animation.value), 0),
      child: Opacity(
        opacity: animation.value,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: GestureDetector(
            onTap: onTap,
            child: Card(
              elevation: 8,
              shadowColor: Colors.greenAccent.withOpacity(0.3),
              color: Color(0xFF0A1A12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: isToday 
                      ? Colors.greenAccent.withOpacity(0.6)
                      : Colors.greenAccent.withOpacity(0.3),
                  width: isToday ? 1.5 : 1,
                ),
              ),
              child: Stack(
                children: [
                  // Scanline effect overlay
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Opacity(
                        opacity: 0.05,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/scanlines.png'),
                              repeat: ImageRepeat.repeat,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Terminal-like header
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.greenAccent.withOpacity(0.15),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(7),
                            topRight: Radius.circular(7),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 8, height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.greenAccent,
                              ),
                            ),
                            SizedBox(width: 4),
                            Container(
                              width: 8, height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.greenAccent.withOpacity(0.5),
                              ),
                            ),
                            SizedBox(width: 4),
                            Container(
                              width: 8, height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.greenAccent.withOpacity(0.3),
                              ),
                            ),
                            Spacer(),
                            Text(
                              'event_${e.eventId}.sh',
                              style: TextStyle(
                                fontFamily: 'Courier',
                                fontSize: 10,
                                color: Colors.greenAccent.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Event content
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Increased vertical padding
                        leading: Container(
                          width: 65,
                          child: Column(
                            mainAxisSize: MainAxisSize.min, // Ensure column takes minimum space
                            mainAxisAlignment: MainAxisAlignment.start, // Align to top instead of center
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Time badge
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3), // Reduced padding
                                decoration: BoxDecoration(
                                  color: Colors.black38,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: Colors.greenAccent.withOpacity(0.5),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.greenAccent.withOpacity(0.15),
                                      blurRadius: 4,
                                      spreadRadius: 0,
                                    )
                                  ],
                                ),
                                child: Text(
                                  DateFormat('HH:mm').format(e.date),
                                  style: TextStyle(
                                    fontFamily: 'VT323',
                                    fontSize: 14, // Reduced from 16
                                    color: Colors.greenAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              /*
                              // Duration indicator
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: Text(
                                  '${e.duration} min',
                                  style: TextStyle(
                                    fontFamily: 'Courier',
                                    fontSize: 9,
                                    color: Colors.greenAccent.withOpacity(0.6),
                                  ),
                                ),
                              ),
                              */

                              // Favorite button
                              SizedBox(height: 6), // Reduced from 6
                              //_buildFavoriteButton(),
                            ],
                          ),
                        ),
                        title: Text(
                          e.title,
                          style: TextStyle(
                            fontFamily: 'VT323',
                            fontSize: 18,
                            color: Colors.greenAccent,
                            letterSpacing: 0.5,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min, // Ensure minimum height
                          children: [
                            SizedBox(height: 4),
                            // Speaker
                            Row(
                              children: [
                                Icon(
                                  Icons.person_outline,
                                  size: 14,
                                  color: Colors.greenAccent.withOpacity(0.7),
                                ),
                                SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    e.person.replaceAll("(", "").replaceAll(")", ""),
                                    style: TextStyle(
                                      fontFamily: 'Courier',
                                      fontSize: 11, // Reduced from 12
                                      color: Colors.greenAccent.withOpacity(0.7),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            
                            // Type badge
                            SizedBox(height: 4), // Reduced from 6
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1), // Reduced padding
                              decoration: BoxDecoration(
                                color: Colors.black26,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: Colors.greenAccent.withOpacity(0.3),
                                  width: 0.5,
                                ),
                              ),
                              child: Text(
                                e.type,
                                style: TextStyle(
                                  fontFamily: 'Courier',
                                  fontSize: 9, // Reduced from 10
                                  color: Colors.greenAccent.withOpacity(0.8),
                                ),
                              ),
                            ),
                          ],
                        ),
                        trailing: _buildFavoriteButton(),
                        /*
                        Container(
                          padding: EdgeInsets.all(3), // Reduced from 4
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.greenAccent.withOpacity(0.3)),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(
                            Icons.arrow_forward,
                            color: Colors.greenAccent,
                            size: 14, // Reduced from 16
                          ),
                        ),
                        */
                      ),
                      
                      // "Today" indicator
                      if (isToday)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.greenAccent.withOpacity(0.2),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                              ),
                              border: Border(
                                left: BorderSide(color: Colors.greenAccent.withOpacity(0.5)),
                                bottom: BorderSide(color: Colors.greenAccent.withOpacity(0.5)),
                              ),
                            ),
                            child: Text(
                              'TODAY',
                              style: TextStyle(
                                fontFamily: 'VT323',
                                fontSize: 12,
                                color: Colors.greenAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteButton() {
    return FutureBuilder(
      future: favoriteStorage.isFavorite(event.eventId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        bool isFavorite = snapshot.hasData && snapshot.data;

        return GestureDetector(
          onTap: onFavoriteToggle,
          child: AnimatedBuilder(
            animation: pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: isFavorite ? pulseAnimation.value : 1.0,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isFavorite ? Colors.greenAccent.withOpacity(0.2) : Colors.transparent,
                  ),
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_outline,
                    color: Colors.greenAccent,
                    size: 20,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}