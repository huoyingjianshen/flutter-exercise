import 'package:flutter/material.dart';
import 'package:flutter_exercise/exercisepage/page_formwork.dart';
import 'package:flutter_exercise/exercisepage/page_math_cell.dart';

Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  //学生做题系统相关页面
  '/formWorkPage': (ctx) => FormWorkPage(),
  //构造正方形
  '/mathCellPage': (ctx) => MathCellPage(),
};