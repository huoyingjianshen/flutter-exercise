import 'package:flutter/material.dart';
import 'package:flutter_exercise/utils/ui_utils.dart';

class PageHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    calContentSize(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("flutter-exercise"),
      ),
      body: Center(
        child: RaisedButton(
          child: Text("exercise"),
          onPressed: () {
            Navigator.of(context).pushNamed('/formWorkPage');
          },
        ),
      ),
    );
  }
}

