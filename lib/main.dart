import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bornhack/app.dart';
import 'package:bornhack/utils/settings_storage.dart';
import 'package:flutter/material.dart';

import 'business_logic/controllers/notification_controller.dart';
import 'ui/pages/favorites/favorites.page.dart';
import 'ui/pages/schedule/schedule.page.dart';
import 'utils/theme_data.dart';
import 'utils/theme_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  configureDependencies();

  await NotificationController.initializeLocalNotifications();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _themeIndex = 0; // 0: dark, 1: light, 2: pink

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  void _loadTheme() async {
    final settingsStorage = SettingsStorage();
    final themeIndex = await settingsStorage.getThemeIndex();
    setState(() {
      _themeIndex = themeIndex;
    });
  }

  void toggleTheme() async {
    final settingsStorage = SettingsStorage();
    setState(() {
      _themeIndex = (_themeIndex + 1) % 3; // Cycle through 0, 1, 2
    });
    await settingsStorage.setThemeIndex(_themeIndex);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme;
    ThemeMode themeMode;
    
    switch (_themeIndex) {
      case 0:
        currentTheme = AppThemes.darkTheme;
        themeMode = ThemeMode.dark;
        break;
      case 1:
        currentTheme = AppThemes.lightTheme;
        themeMode = ThemeMode.light;
        break;
      case 2:
        currentTheme = AppThemes.pinkTheme;
        themeMode = ThemeMode.light;
        break;
      default:
        currentTheme = AppThemes.darkTheme;
        themeMode = ThemeMode.dark;
    }

    return MaterialApp(
      title: 'BornHack App',
      theme: currentTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: themeMode,
      home: Main(onThemeToggle: toggleTheme),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Main extends StatefulWidget {
  final VoidCallback onThemeToggle;
  
  const Main({Key? key, required this.onThemeToggle}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Main();
}

class _Main extends State<Main> {
  int _currentIndex = 0;
  late PageController _pageController;
  late List<Widget> _children;

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
    _children = [
      SchedulePage(onThemeToggle: widget.onThemeToggle),
      FavoritesPage(onThemeToggle: widget.onThemeToggle)
    ];
    
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
          context: context,
          builder: (context) => _buildPermissionDialog(context),
        );
      }
    });
  }

  Widget _buildPermissionDialog(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: AppThemes.getTerminalBorder(context), 
          width: 1
        ),
      ),
      title: Row(
        children: [
          Icon(Icons.notifications, color: AppThemes.getAccentColor(context)),
          SizedBox(width: 10),
          Text(
            'SYSTEM REQUEST',
            style: TextStyle(
              fontFamily: 'VT323',
              color: AppThemes.getAccentColor(context),
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
              color: AppThemes.getTerminalBackground(context),
              border: Border.all(color: AppThemes.getTerminalBorder(context)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '> Requesting permission to send notifications 15 minutes before your favorite events start.',
              style: TextStyle(
                fontFamily: 'Courier',
                color: AppThemes.getAccentColor(context),
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Grant access? [Y/N]',
            style: TextStyle(
              fontFamily: 'VT323',
              color: AppThemes.getAccentColor(context),
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
            backgroundColor: AppThemes.getTerminalBackground(context),
            side: BorderSide(color: AppThemes.getTerminalBorder(context)),
          ),
          child: Text(
            'DENY [N]',
            style: TextStyle(
              fontFamily: 'VT323',
              color: AppThemes.getSecondaryTextColor(context),
              fontSize: 16,
            )
          )
        ),
        TextButton(
          onPressed: () => AwesomeNotifications()
            .requestPermissionToSendNotifications()
            .then((_) => Navigator.pop(context)),
          style: TextButton.styleFrom(
            backgroundColor: AppThemes.getAccentColor(context).withOpacity(0.2),
            side: BorderSide(color: AppThemes.getAccentColor(context)),
          ),
          child: Text(
            'ALLOW [Y]',
            style: TextStyle(
              fontFamily: 'VT323',
              color: AppThemes.getAccentColor(context),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            )
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
            top: BorderSide(
              color: AppThemes.getTerminalBorder(context), 
              width: 1
            ),
          ),
          color: Theme.of(context).cardColor,
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: AppThemes.getAccentColor(context),
          unselectedItemColor: AppThemes.getAccentColor(context).withOpacity(0.5),
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