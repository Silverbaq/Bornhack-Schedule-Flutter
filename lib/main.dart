import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bornhack/app.dart';
import 'package:flutter/material.dart';

import 'ui/pages/favorites/favorites.page.dart';
import 'ui/pages/schedule/schedule.page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  configureDependencies();

  AwesomeNotifications()
      .initialize('resource://drawable/res_notification_app_icon', [
    NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic Notifications',
        defaultColor: Colors.teal,
        channelDescription: '',
        channelShowBadge: true,
        importance: NotificationImportance.High,
      soundSource: 'resource://raw/res_custom_notification'
    ),
  ]);
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
          headline1: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          headline2: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          bodyText1: TextStyle(fontSize: 14.0),
          bodyText2: TextStyle(fontSize: 12.0),
        ),
      ),
      home: Main(),
    );
  }
}

class Main extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Main();
}

class _Main extends State<Main> {
  int _currentIndex = 0;
  final List<Widget> _children = [SchedulePage(), FavoritesPage()];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                    title: Text('Allow Notifications'),
                    content:
                        Text('Out app would like to send you notifications'),
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
  }

  @override
  void dispose() {
    AwesomeNotifications().actionSink.close();
    AwesomeNotifications().dismissedSink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text('Bornhack')),
      body: _children[_currentIndex],
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
