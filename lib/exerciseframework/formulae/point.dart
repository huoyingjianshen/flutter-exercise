import 'dart:math';
import 'dart:ui';

import 'package:flutter_exercise/exerciseframework/formulae/line.dart';
import 'package:flutter_exercise/utils/print_helper.dart';


/// 求两条直线段在size范围内的交点
/// [line1] 直线1
/// [line2] 直线2
/// [size)] 给定的范围
Offset calCrossoverPoint(Line line1, Line line2, Size size) {
  //parallel line
  if (isParallelLine(line1, line2)) {
    printHelper('平行线');
    return null;
  }

  double
  x1 = line1.start.dx,
      y1 = line1.start.dy,
      x2 = line1.end.dx,
      y2 = line1.end.dy,
      x3 = line2.start.dx,
      y3 = line2.start.dy,
      x4 = line2.end.dx,
      y4 = line2.end.dy;

  double x = ((x1 - x2) * (x3 * y4 - x4 * y3) - (x3 - x4) * (x1 * y2 - x2 * y1))
      / ((x3 - x4) * (y1 - y2) - (x1 - x2) * (y3 - y4));

  double y = ((y1 - y2) * (x3 * y4 - x4 * y3) - (x1 * y2 - x2 * y1) * (y3 - y4))
      / ((y1 - y2) * (x3 - x4) - (x1 - x2) * (y3 - y4));

  if (double.nan.compareTo(x) == 0 || double.infinity.compareTo(x) == 0 ||
      double.negativeInfinity.compareTo(x) == 0 || x > size.width + 0.001 || x < -0.001 ||
      double.nan.compareTo(y) == 0 || double.infinity.compareTo(y) == 0 ||
      double.negativeInfinity.compareTo(y) == 0 || y > size.height + 0.001 || y < -0.001) {
    return null;
  }

  Offset offset = Offset(x.abs(), y.abs());
//  printHelper('交点坐标x：${offset.dx}' + ',y：${offset.dy}');

  return offset;
}

/// 点[origin] 绕 点[center] 旋转 [radians] 弧度后的坐标
Offset rotateOffset(Offset origin, Offset center, num radians) {
  double x1 = origin.dx;
  double y1 = origin.dy;
  double x2 = center.dx;
  double y2 = center.dy;

  double dx = (x1 - x2) * cos(radians) - (y1 - y2) * sin(radians) + x2;
  double dy = (y1 - y2) * cos(radians) + (x1 - x2) * sin(radians) + y2;
  return Offset(dx, dy);
}

/// 两点间距
double distance(Offset point1,Offset point2) {
  return sqrt((point1.dx - point2.dx) * (point1.dx - point2.dx) +
      (point1.dy - point2.dy) * (point1.dy - point2.dy));
}

//是否同一个点（误差计算）
bool isSamePoint(Offset point1, Offset point2) {
  return ((point1.dx - point2.dx).abs() < 0.001) &&
      ((point1.dy - point2.dy).abs() < 0.001);
}

//判断一个点是否在集合中
bool pointInList(Offset targetPoint, List<Offset> list) {
  for (Offset point in list) {
    if (isSamePoint(point, targetPoint)) {
      return true;
    }
  }

  return false;
}