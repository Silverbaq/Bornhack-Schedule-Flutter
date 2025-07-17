import 'package:bornhack/app.dart';
import 'package:bornhack/business_logic/model/event.model.dart';
import 'package:bornhack/ui/pages/favorites/favorites.view_model.dart';
import 'package:bornhack/ui/widgets/schedule/event.widget.dart';
import 'package:bornhack/utils/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:pmvvm/pmvvm.dart';

class FavoritesPage extends StatelessWidget {
  final VoidCallback onThemeToggle;

  FavoritesPage({required this.onThemeToggle});

  @override
  Widget build(BuildContext context) {
    return MVVM<FavoritesViewModel>(
      view: () => _FavoritesWidget(onThemeToggle: onThemeToggle),
      viewModel: FavoritesViewModel(getIt.get()),
    );
  }
}

class _FavoritesWidget extends StatelessView<FavoritesViewModel> {
  final VoidCallback onThemeToggle;

  _FavoritesWidget({required this.onThemeToggle});

  @override
  Widget render(context, vmodel) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        elevation: 8,
        shadowColor: AppThemes.getAccentColor(context).withOpacity(0.3),
        title: Row(
          children: [
            Icon(Icons.favorite, color: AppThemes.getAccentColor(context)),
            SizedBox(width: 10),
            Text(
              'FAVORITES',
              style: TextStyle(
                fontFamily: 'VT323',
                color: AppThemes.getAccentColor(context),
                fontSize: 24,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _getThemeIcon(context),
              color: AppThemes.getAccentColor(context),
            ),
            onPressed: onThemeToggle,
            tooltip: 'Toggle Theme',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          image: DecorationImage(
            image: AssetImage('assets/grid_background.png'),
            opacity: 0.1,
            fit: BoxFit.cover,
          ),
        ),
        child: vmodel.groupedFavoriteEvents.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.terminal,
                      color: AppThemes.getAccentColor(context),
                      size: 60,
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppThemes.getTerminalBorder(context)),
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context).cardColor,
                      ),
                      child: Column(
                        children: [
                          Text(
                            'NO FAVORITES FOUND',
                            style: TextStyle(
                              fontFamily: 'VT323',
                              color: AppThemes.getAccentColor(context),
                              fontSize: 24,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '> Add events to favorites by clicking the heart icon',
                            style: TextStyle(
                              fontFamily: 'Courier',
                              color: AppThemes.getAccentColor(context).withOpacity(0.7),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : ListView(
                children: _listViewElements(context, vmodel.groupedFavoriteEvents),
              ),
      ),
    );
  }

  List<Widget> _listViewElements(BuildContext context, Map<String, List<Event>> values) {
    List<Widget> result = [];
    values.forEach((title, events) => {
          result.add(
            Container(
              margin: const EdgeInsets.fromLTRB(8, 16, 8, 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppThemes.getTerminalBorder(context)),
                boxShadow: [
                  BoxShadow(
                    color: AppThemes.getAccentColor(context).withOpacity(0.2),
                    blurRadius: 4,
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, color: AppThemes.getAccentColor(context)),
                  SizedBox(width: 12),
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'VT323',
                      fontSize: 24,
                      color: AppThemes.getAccentColor(context),
                    ),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppThemes.getAccentColor(context).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppThemes.getTerminalBorder(context)),
                    ),
                    child: Text(
                      '${events.length}',
                      style: TextStyle(
                        fontFamily: 'VT323',
                        fontSize: 16,
                        color: AppThemes.getAccentColor(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          result.add(EventsWidget(events))
        });
    return result;
  }

  IconData _getThemeIcon(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    // Check if it's a year theme
    if (AppThemes.yearColors.containsValue(primaryColor)) {
      return Icons.palette; // Year theme
    } else if (Theme.of(context).brightness == Brightness.dark) {
      return Icons.light_mode; // Dark theme
    } else {
      return Icons.dark_mode; // Light theme
    }
  }
}