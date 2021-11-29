
import 'package:flutter/material.dart';

class InfoCardWidget extends StatelessWidget {
  InfoCardWidget(this._header, this._body);

  final String _header;
  final String _body;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 50,
        alignment: Alignment.center,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 2.0),
              child: Row(
                children: [Text(_header, style: TextStyle(fontSize: 10), ), ],
              ),
            ),
            Text(_body, style: TextStyle(fontSize: 18), ),
          ],
        ),
      ),
    );
  }

}