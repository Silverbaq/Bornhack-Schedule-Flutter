import 'package:bornhack/business_logic/model/event.model.dart';
import 'package:bornhack/ui/widgets/event/info_card.widget.dart';
import 'package:flutter/material.dart';
import 'package:pmvvm/pmvvm.dart';
import 'dart:math' as math;

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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Color(0xFF0A1A12),
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 9,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  viewModel.event.title,
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'VT323',
                    color: Colors.greenAccent,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () async {
                  await viewModel.favoriteClicked();
                },
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: Icon(
                    viewModel.isEventAFavorite
                        ? Icons.favorite_outlined
                        : Icons.favorite_outline,
                    key: ValueKey<bool>(viewModel.isEventAFavorite),
                    color: Colors.greenAccent,
                    size: 28,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
            image: AssetImage('assets/grid_background.png'),
            opacity: 0.1,
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                // Date/Time Card with terminal-like header
                Card(
                  elevation: 8,
                  color: Color(0xFF0A1A12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.greenAccent.withOpacity(0.5), width: 1),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.greenAccent.withOpacity(0.2),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.circle, color: Colors.greenAccent, size: 12),
                            SizedBox(width: 8),
                            Text(
                              "event_datetime.sh",
                              style: TextStyle(
                                fontFamily: 'VT323',
                                color: Colors.greenAccent,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.calendar_today, color: Colors.greenAccent),
                            SizedBox(width: 12),
                            Text(
                              viewModel.dateTimeToStringFormat(viewModel.event.date),
                              style: TextStyle(
                                fontSize: 22,
                                fontFamily: 'VT323',
                                color: Colors.greenAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                
                // Room Card
                Card(
                  elevation: 8,
                  color: Color(0xFF0A1A12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.greenAccent.withOpacity(0.5), width: 1),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.greenAccent.withOpacity(0.2),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.circle, color: Colors.greenAccent, size: 12),
                            SizedBox(width: 8),
                            Text(
                              "location.sh",
                              style: TextStyle(
                                fontFamily: 'VT323',
                                color: Colors.greenAccent,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.meeting_room, color: Colors.greenAccent),
                            SizedBox(width: 12),
                            Text(
                              viewModel.event.room,
                              style: TextStyle(
                                fontSize: 22,
                                fontFamily: 'VT323',
                                color: Colors.greenAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                
                // Info Cards Row 1
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 5,
                      child: _buildInfoCard(
                        "Type",
                        "${viewModel.event.type}",
                        Icons.category,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      flex: 5,
                      child: _buildInfoCard(
                        "Speaker",
                        "${viewModel.event.person.replaceAll("(", "").replaceAll(")", "")}",
                        Icons.person,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                
                // Info Cards Row 2
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 5,
                      child: _buildInfoCard(
                        "Duration",
                        formatDuration(viewModel.event.duration),
                        Icons.timer,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      flex: 5,
                      child: _buildInfoCard(
                        "Recording",
                        "${viewModel.event.recording ? "Yes" : "No"}",
                        Icons.videocam,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                
                // Abstract Card
                Card(
                  elevation: 8,
                  color: Color(0xFF0A1A12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.greenAccent.withOpacity(0.5), width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.greenAccent.withOpacity(0.2),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.circle, color: Colors.greenAccent, size: 12),
                            SizedBox(width: 8),
                            Text(
                              "README.md",
                              style: TextStyle(
                                fontFamily: 'VT323',
                                color: Colors.greenAccent,
                                fontSize: 16,
                              ),
                            ),
                            Spacer(),
                            _buildBlinkingCursor(),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Abstract:",
                              style: TextStyle(
                                fontFamily: 'VT323',
                                color: Colors.greenAccent,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.greenAccent.withOpacity(0.3), width: 1),
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.black.withOpacity(0.3),
                              ),
                              child: Text(
                                viewModel.event.abstract,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Courier',
                                  color: Colors.greenAccent,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Card(
      elevation: 8,
      color: Color(0xFF0A1A12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.greenAccent.withOpacity(0.5), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.greenAccent, size: 16),
                SizedBox(width: 6),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'VT323',
                    color: Colors.greenAccent.withOpacity(0.7),
                  ),
                ),
              ],
            ),
            SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Courier',
                color: Colors.greenAccent,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildBlinkingCursor() {
    return BlinkingCursor();
  }
}

class BlinkingCursor extends StatefulWidget {
  @override
  _BlinkingCursorState createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<BlinkingCursor> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..repeat(reverse: true);
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Container(
        width: 8,
        height: 16,
        color: Colors.greenAccent,
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