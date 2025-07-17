import 'package:bornhack/business_logic/model/day.model.dart';
import 'package:bornhack/ui/widgets/schedule/DaySelectionViewModel.dart';
import 'package:bornhack/utils/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:pmvvm/pmvvm.dart';

import 'day_row.widget.dart';

class DaySelectionWidget extends StatelessWidget {
  DaySelectionWidget(this.days, {required this.onThemeToggle});
  final VoidCallback onThemeToggle;

  final List<Day> days;

  @override
  Widget build(BuildContext context) {
    return MVVM(
        view: () => _DaySelectionState(onThemeToggle: onThemeToggle,), viewModel: DaySelectionViewModel(days));
  }
}

class _DaySelectionState extends StatelessView<DaySelectionViewModel> {
  final VoidCallback onThemeToggle;

  _DaySelectionState({required this.onThemeToggle});

  @override
  Widget render(BuildContext context, DaySelectionViewModel viewModel) {
    return DefaultTabController(
      length: viewModel.days.length,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).cardColor,
          elevation: 8,
          shadowColor: AppThemes.getAccentColor(context).withOpacity(0.3),
          bottom: TabBar(
            indicatorColor: AppThemes.getAccentColor(context),
            indicatorWeight: 3,
            labelColor: AppThemes.getAccentColor(context),
            unselectedLabelColor: AppThemes.getSecondaryTextColor(context),
            labelStyle: TextStyle(
              fontFamily: 'VT323',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: TextStyle(
              fontFamily: 'VT323',
              fontSize: 18,
            ),
            tabs: viewModel.days.map((e) {
              // Format the date to show day number and abbreviated month
              final dayStr = e.date.day.toString();
              final monthStr = _getMonthAbbreviation(e.date.month);
              
              return Tab(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(dayStr),
                    Text(
                      monthStr,
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          title: Row(
            children: [
              Icon(Icons.terminal, color: AppThemes.getAccentColor(context)),
              SizedBox(width: 8),
              Text(
                'Bornhack',
                style: TextStyle(
                  fontFamily: 'VT323',
                  color: AppThemes.getAccentColor(context),
                  fontSize: 24,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          actions: <Widget>[

            IconButton(
              icon: Icon(
                _getThemeIcon(context),
                color: AppThemes.getAccentColor(context),
              ),
              onPressed: onThemeToggle,
              tooltip: 'Toggle Theme',
            ),

            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppThemes.getTerminalBorder(context),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: AppThemes.getAccentColor(context).withOpacity(0.2),
                      blurRadius: 4,
                      spreadRadius: 0,
                    )
                  ],
                  color: AppThemes.getTerminalBackground(context),
                ),
                child: GestureDetector(
                  onTap: () {
                    // Create a brief "terminal command" effect
                    final scaffoldMessenger = ScaffoldMessenger.of(context);
                    scaffoldMessenger.clearSnackBars();
                    scaffoldMessenger.showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.terminal, color: AppThemes.getAccentColor(context), size: 16),
                            SizedBox(width: 8),
                            Text(
                              viewModel.displayAsList 
                                ? '> switching to venue view...'
                                : '> switching to list view...',
                              style: TextStyle(
                                fontFamily: 'Courier',
                                color: AppThemes.getAccentColor(context),
                              ),
                            ),
                          ],
                        ),
                        backgroundColor: Theme.of(context).cardColor,
                        duration: Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                          side: BorderSide(color: AppThemes.getTerminalBorder(context)),
                        ),
                      ),
                    );
                    
                    viewModel.changeLayoutClicked();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          viewModel.displayAsList ? Icons.meeting_room_outlined : Icons.list,
                          color: AppThemes.getAccentColor(context),
                          size: 20.0,
                        ),
                        SizedBox(width: 6),
                        Text(
                          viewModel.displayAsList ? 'VENUE' : 'LIST',
                          style: TextStyle(
                            fontFamily: 'VT323',
                            color: AppThemes.getAccentColor(context),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
          child: TabBarView(
            children: viewModel.days.map((day) {
              return DayRowWidget(day, viewModel.displayAsList);
            }).toList(),
          ),
        ),
      ),
    );
  }
  
  String _getMonthAbbreviation(int month) {
    switch (month) {
      case 1: return 'JAN';
      case 2: return 'FEB';
      case 3: return 'MAR';
      case 4: return 'APR';
      case 5: return 'MAY';
      case 6: return 'JUN';
      case 7: return 'JUL';
      case 8: return 'AUG';
      case 9: return 'SEP';
      case 10: return 'OCT';
      case 11: return 'NOV';
      case 12: return 'DEC';
      default: return '';
    }
  }

  IconData _getThemeIcon(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    
    if (primaryColor == Color(0xFFF3B2C7)) {
      return Icons.palette; // Pink theme
    } else if (Theme.of(context).brightness == Brightness.dark) {
      return Icons.light_mode; // Dark theme
    } else {
      return Icons.dark_mode; // Light theme
    }
  }
}