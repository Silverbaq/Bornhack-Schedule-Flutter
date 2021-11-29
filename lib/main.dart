import 'package:bornhack/app.dart';
import 'package:flutter/material.dart';

import 'ui/pages/favorites/favorites.page.dart';
import 'ui/pages/schedule/schedule.page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
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
          headline1: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          headline2: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bornhack')),
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