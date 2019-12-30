import 'package:flutter/material.dart';
import 'package:flutter_exercise/exerciseframework/core/formwork.dart';

class FormWorkPage extends StatelessWidget {
  final formWorkList = [
    {'title': 'construction2d', 'page': '/mathCellPage', 'type': FormWork.CONSTRUCTION_2D},
  ];

  @override
  Widget build(BuildContext context) {
    final tiles = formWorkList.map(
      (page) {
        return new ListTile(
          title: new Text(
            page['title'],
          ),
          onTap: () {
            Navigator.of(context).pushNamed(page['page'], arguments: page['type']);
          },
        );
      },
    );
    final divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('flutter-exercise'),
      ),
      body: ListView(children: divided),
    );
  }
}
