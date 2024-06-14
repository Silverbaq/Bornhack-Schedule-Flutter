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
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.blueGrey,
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          headlineMedium: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          bodyLarge: TextStyle(fontSize: 14.0),
          bodyMedium: TextStyle(fontSize: 12.0),
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
                    title: Text('Allow Notifications'),
                    content:
                        Text('We would like to send you notifications 15 minutes before you favorite events starts.'),
                    actions: [
                      TextButton(
                          onPressed: () {},
                          child: Text('Dont\'t Allow',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                              ))),
                      TextButton(
                          onPressed: () => AwesomeNotifications()
                              .requestPermissionToSendNotifications()
                              .then((_) => Navigator.pop(context)),
                          child: Text('Allow',
                              style: TextStyle(
                                  color: Colors.teal,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)))
                    ]));
      }
    });

/*
    AwesomeNotifications().actionStream.listen((notification) {
      if (notification.channelKey == 'basic_channel' && Platform.isIOS) {
        AwesomeNotifications().getGlobalBadgeCounter().then(
            (value) => AwesomeNotifications().setGlobalBadgeCounter(value - 1));
      }
    });

    AwesomeNotifications().dismissedStream.listen((notification) {
      if (notification.channelKey == 'basic_channel' && Platform.isIOS) {
        AwesomeNotifications().getGlobalBadgeCounter().then(
                (value) => AwesomeNotifications().setGlobalBadgeCounter(value - 1));
      }
    });
*/
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
      //appBar: AppBar(title: Text('Bornhack')),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _currentIndex = index);
        },
        children: _children,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
