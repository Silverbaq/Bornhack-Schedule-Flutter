import 'package:bornhack/app.dart';
import 'package:bornhack/business_logic/model/event.model.dart';
import 'package:bornhack/ui/pages/favorites/favorites.view_model.dart';
import 'package:bornhack/ui/widgets/schedule/event.widget.dart';
import 'package:flutter/material.dart';
import 'package:pmvvm/pmvvm.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MVVM<FavoritesViewModel>(
      view: () => _FavoritesWidget(),
      viewModel: FavoritesViewModel(getIt.get()),
    );
  }
}

class _FavoritesWidget extends StatelessView<FavoritesViewModel> {
  @override
  Widget render(context, vmodel) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Color(0xFF0A1A12),
        elevation: 8,
        shadowColor: Colors.greenAccent.withOpacity(0.3),
        title: Row(
          children: [
            Icon(Icons.favorite, color: Colors.greenAccent),
            SizedBox(width: 10),
            Text(
              'FAVORITES',
              style: TextStyle(
                fontFamily: 'VT323',
                color: Colors.greenAccent,
                fontSize: 24,
                letterSpacing: 1.2,
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
        child: vmodel.groupedFavoriteEvents.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.terminal,
                      color: Colors.greenAccent,
                      size: 60,
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.greenAccent.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(8),
                        color: Color(0xFF0A1A12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'NO FAVORITES FOUND',
                            style: TextStyle(
                              fontFamily: 'VT323',
                              color: Colors.greenAccent,
                              fontSize: 24,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '> Add events to favorites by clicking the heart icon',
                            style: TextStyle(
                              fontFamily: 'Courier',
                              color: Colors.greenAccent.withOpacity(0.7),
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
                color: Color(0xFF0A1A12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.greenAccent.withOpacity(0.5)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.greenAccent.withOpacity(0.2),
                    blurRadius: 4,
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.greenAccent),
                  SizedBox(width: 12),
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'VT323',
                      fontSize: 24,
                      color: Colors.greenAccent,
                    ),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.greenAccent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.greenAccent.withOpacity(0.3)),
                    ),
                    child: Text(
                      '${events.length}',
                      style: TextStyle(
                        fontFamily: 'VT323',
                        fontSize: 16,
                        color: Colors.greenAccent,
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
}