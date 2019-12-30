import 'package:flutter/material.dart';
import 'package:flutter_exercise/utils/resize_utils.dart';
import 'package:flutter_exercise/utils/ui_utils.dart';

///自定义公共练习的AppBar
class CommonExerciseAppBar extends AppBar implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(resizeUtil(globalAppbarHeight));

  final String name;

  @override
  CommonExerciseAppBar({this.name})
      : super(
          title: Text(
            name,
            style: TextStyle(
              color: Color.fromARGB(255, 69, 79, 110),
              fontSize: resizePadTextSize(19),
            ),
          ),
          backgroundColor: Color.fromARGB(255, 241, 245, 250),
          brightness: Brightness.light,
          iconTheme: IconThemeData(
            color: Color.fromARGB(255, 166, 176, 213),
          ),
          textTheme: TextTheme(
              display1: TextStyle(color: Color.fromARGB(255, 69, 79, 110))),
        );
}
