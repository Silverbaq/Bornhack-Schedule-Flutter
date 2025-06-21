import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bornhack/app.dart';
import 'package:flutter/material.dart';

import 'business_logic/controllers/notification_controller.dart';
import 'ui/pages/favorites/favorites.page.dart';
import 'ui/pages/schedule/schedule.page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  configureDependencies();

  await NotificationController.initializeLocalNotifications();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BornHack App',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.green,
        scaffoldBackgroundColor: Colors.black,
        cardColor: Color(0xFF0A1A12),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF0A1A12),
          elevation: 0,
        ),
        textTheme: TextTheme(
          headlineLarge: TextStyle(
            fontSize: 24, 
            fontWeight: FontWeight.bold, 
            color: Colors.greenAccent,
            fontFamily: 'VT323',
          ),
          headlineMedium: TextStyle(
            fontSize: 24, 
            fontWeight: FontWeight.bold, 
            color: Colors.greenAccent,
            fontFamily: 'VT323',
          ),
          bodyLarge: TextStyle(
            fontSize: 14.0, 
            color: Colors.greenAccent,
            fontFamily: 'Courier',
          ),
          bodyMedium: TextStyle(
            fontSize: 12.0, 
            color: Colors.greenAccent,
            fontFamily: 'Courier',
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.greenAccent,
        ),
      ),
      home: Main(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Main extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Main();
}

class _Main extends State<Main> {
  int _currentIndex = 0;
  late PageController _pageController;
  final List<Widget> _children = [SchedulePage(), FavoritesPage()];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.easeOut);
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Color(0xFF0A1A12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.greenAccent.withOpacity(0.5), width: 1),
            ),
            title: Row(
              children: [
                Icon(Icons.notifications, color: Colors.greenAccent),
                SizedBox(width: 10),
                Text(
                  'SYSTEM REQUEST',
                  style: TextStyle(
                    fontFamily: 'VT323',
                    color: Colors.greenAccent,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    border: Border.all(color: Colors.greenAccent.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '> Requesting permission to send notifications 15 minutes before your favorite events start.',
                    style: TextStyle(
                      fontFamily: 'Courier',
                      color: Colors.greenAccent,
                      fontSize: 14,
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Grant access? [Y/N]',
                  style: TextStyle(
                    fontFamily: 'VT323',
                    color: Colors.greenAccent,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.black26,
                  side: BorderSide(color: Colors.greenAccent.withOpacity(0.3)),
                ),
                child: Text(
                  'DENY [N]',
                  style: TextStyle(
                    fontFamily: 'VT323',
                    color: Colors.grey,
                    fontSize: 16,
                  )
                )
              ),
              TextButton(
                onPressed: () => AwesomeNotifications()
                  .requestPermissionToSendNotifications()
                  .then((_) => Navigator.pop(context)),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.greenAccent.withOpacity(0.2),
                  side: BorderSide(color: Colors.greenAccent),
                ),
                child: Text(
                  'ALLOW [Y]',
                  style: TextStyle(
                    fontFamily: 'VT323',
                    color: Colors.greenAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )
                )
              ),
            ],
          )
        );
      }
    });
  }

  @override
  void dispose() {
    //AwesomeNotifications().actionSink.close();
    //AwesomeNotifications().dismissedSink.close();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/grid_background.png'),
            opacity: 0.1,
            fit: BoxFit.cover,
          ),
        ),
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: _children,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.greenAccent.withOpacity(0.3), width: 1),
          ),
          color: Color(0xFF0A1A12),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Colors.greenAccent,
          unselectedItemColor: Colors.greenAccent.withOpacity(0.5),
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.terminal),
              label: 'Schedule',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
          ],
        ),
      ),
    );
  }
}