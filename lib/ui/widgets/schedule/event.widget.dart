import 'package:bornhack/business_logic/model/event.model.dart';
import 'package:bornhack/ui/pages/event/event.page.dart';
import 'package:bornhack/utils/favorites_storage.dart';
import 'package:bornhack/utils/notifications.dart';
import 'package:bornhack/utils/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import 'dart:async';

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
          
          // Create a key for this specific card
          final cardKey = GlobalKey();
          
          return EventCard(
            key: cardKey,
            event: e,
            animation: _animation,
            isToday: isToday,
            onTap: () {
              // Get the RenderBox of just this card
              final RenderBox? box = cardKey.currentContext?.findRenderObject() as RenderBox?;
              Navigator.push(context, createRouter(e));
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
  final FavoriteStorage favoriteStorage;
  final Animation<double> pulseAnimation;
  late final ValueNotifier<bool?> _favoriteNotifier;
  
  EventCard({
    required Key key,
    required this.event, 
    required Animation<double> animation,
    this.isToday = false,
    required this.onTap,
    required this.favoriteStorage,
    required this.pulseAnimation,
  }) : super(key: key, listenable: animation) {
    _favoriteNotifier = ValueNotifier<bool?>(null);
    _loadFavoriteStatus();
  }
  
  void _loadFavoriteStatus() async {
    final isFavorite = await favoriteStorage.isFavorite(event.eventId);
    // Only update if the value has changed
    if (_favoriteNotifier.value != isFavorite) {
      _favoriteNotifier.value = isFavorite;
    }
  }
  
  Animation<double> get animation => listenable as Animation<double>;
  
  @override
  Widget build(BuildContext context) {
    final e = event;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: GestureDetector(
        onTap: () {
          // Create a blinking effect before navigation
          final blinkCount = 2;
          final blinkDuration = Duration(milliseconds: 100);

          // Find the card's RenderBox
          final RenderBox? box = context.findRenderObject() as RenderBox?;
          if (box != null) {
            final cardPosition = box.localToGlobal(Offset.zero);
            final cardSize = box.size;

            // Account for the padding around the GestureDetector
            final paddingHorizontal = 8.0;
            final paddingVertical = 4.0;

            // Calculate the actual card position and size (inside the padding)
            final overlayPosition = Offset(
              cardPosition.dx + paddingHorizontal,
              cardPosition.dy + paddingVertical
            );
            final overlaySize = Size(
              cardSize.width - (paddingHorizontal * 2),
              cardSize.height - (paddingVertical * 2)
            );

            Widget currentOverlay = Container();
            OverlayEntry? entry;

            entry = OverlayEntry(
              builder: (context) => Positioned(
                left: overlayPosition.dx,
                top: overlayPosition.dy,
                width: overlaySize.width,
                height: overlaySize.height,
                child: IgnorePointer(
                  child: AnimatedSwitcher(
                    duration: blinkDuration,
                    child: currentOverlay,
                  ),
                ),
              ),
            );

            Overlay.of(context).insert(entry);

            // Blink effect
            int currentBlink = 0;
            Timer.periodic(blinkDuration, (timer) {
              if (currentBlink >= blinkCount * 2) {
                timer.cancel();
                entry?.remove();
                // Navigate and refresh favorite status when returning
                Navigator.push(context, createRouter(event)).then((_) {
                  _loadFavoriteStatus(); // Refresh the favorite status
                });
                return;
              }

              if (currentBlink % 2 == 0) {
                // Show accent color overlay
                currentOverlay = Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppThemes.getAccentColor(context).withOpacity(0.3),
                  ),
                );
              } else {
                // Hide overlay
                currentOverlay = Container();
              }

              entry?.markNeedsBuild();
              currentBlink++;
            });
          } else {
            // Fallback if we can't get the card position
            Navigator.push(context, createRouter(event)).then((_) {
              _loadFavoriteStatus(); // Refresh the favorite status
            });
          }
        },
        child: Card(
          elevation: 8,
          shadowColor: AppThemes.getAccentColor(context).withOpacity(0.3),
          color: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: isToday
                  ? AppThemes.getAccentColor(context).withOpacity(0.6)
                  : AppThemes.getTerminalBorder(context),
              width: isToday ? 1.5 : 1,
            ),
          ),
          child: Stack(
            children: [
              // Terminal-like header
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppThemes.getAccentColor(context).withOpacity(0.15),
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
                            color: AppThemes.getAccentColor(context),
                          ),
                        ),
                        SizedBox(width: 4),
                        Container(
                          width: 8, height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppThemes.getAccentColor(context).withOpacity(0.5),
                          ),
                        ),
                        SizedBox(width: 4),
                        Container(
                          width: 8, height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppThemes.getAccentColor(context).withOpacity(0.3),
                          ),
                        ),
                        Spacer(),
                        Text(
                          'event_${e.eventId}.sh',
                          style: TextStyle(
                            fontFamily: 'Courier',
                            fontSize: 10,
                            color: AppThemes.getSecondaryTextColor(context),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Event content
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      width: 65,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Time badge
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(
                              color: isDark 
                                  ? Colors.black38 
                                  : AppThemes.getAccentColor(context).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: AppThemes.getTerminalBorder(context),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppThemes.getAccentColor(context).withOpacity(0.15),
                                  blurRadius: 4,
                                  spreadRadius: 0,
                                )
                              ],
                            ),
                            child: Text(
                              DateFormat('HH:mm').format(e.date),
                              style: TextStyle(
                                fontFamily: 'VT323',
                                fontSize: 14,
                                color: AppThemes.getAccentColor(context),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 6),
                        ],
                      ),
                    ),
                    title: Text(
                      e.title,
                      style: TextStyle(
                        fontFamily: 'VT323',
                        fontSize: 18,
                        color: AppThemes.getAccentColor(context),
                        letterSpacing: 0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 4),
                        // Speaker
                        Row(
                          children: [
                            Icon(
                              Icons.person_outline,
                              size: 14,
                              color: AppThemes.getSecondaryTextColor(context),
                            ),
                            SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                e.person.replaceAll("(", "").replaceAll(")", ""),
                                style: TextStyle(
                                  fontFamily: 'Courier',
                                  fontSize: 11,
                                  color: AppThemes.getSecondaryTextColor(context),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),

                        // Type badge
                        SizedBox(height: 4),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                          decoration: BoxDecoration(
                            color: isDark 
                                ? Colors.black26 
                                : AppThemes.getAccentColor(context).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: AppThemes.getTerminalBorder(context),
                              width: 0.5,
                            ),
                          ),
                          child: Text(
                            e.type,
                            style: TextStyle(
                              fontFamily: 'Courier',
                              fontSize: 9,
                              color: AppThemes.getAccentColor(context).withOpacity(0.8),
                            ),
                          ),
                        ),
                      ],
                    ),
                    trailing: _buildFavoriteButton(),
                  ),

                  // "Today" indicator
                  if (isToday)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppThemes.getAccentColor(context).withOpacity(0.2),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      child: Text(
                        'TODAY',
                        style: TextStyle(
                          fontFamily: 'VT323',
                          fontSize: 12,
                          color: AppThemes.getAccentColor(context),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteButton() {
    return ValueListenableBuilder<bool?>(
      valueListenable: _favoriteNotifier,
      builder: (BuildContext context, bool? isFavorite, Widget? child) {
        // Show loading state if isFavorite is null
        if (isFavorite == null) {
          return Container(
            padding: EdgeInsets.all(4),
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppThemes.getAccentColor(context).withOpacity(0.5)
                ),
              ),
            ),
          );
        }

        return GestureDetector(
          onTap: () async {
            // Optimistically update the UI immediately
            final newValue = !isFavorite;
            _favoriteNotifier.value = newValue;

            // Perform the actual storage operation
            if (newValue) {
              NotificationData data = NotificationData(
                int.parse(event.eventId), event.title, event.abstract, event.date);
              await createScheduledNotification(data);
              favoriteStorage.addFavorite(event.eventId);
            } else {
              await removeScheduledNotification(int.parse(event.eventId));
              favoriteStorage.removeFavorite(event.eventId);
            }

            // Verify the operation succeeded by checking storage
            final actualValue = await favoriteStorage.isFavorite(event.eventId);
            if (_favoriteNotifier.value != actualValue) {
              // If there was an error, revert to the actual value
              _favoriteNotifier.value = actualValue;
            }
          },
          child: AnimatedBuilder(
            animation: pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: isFavorite ? pulseAnimation.value : 1.0,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isFavorite ? AppThemes.getAccentColor(context).withOpacity(0.2) : Colors.transparent,
                  ),
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_outline,
                    color: AppThemes.getAccentColor(context),
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