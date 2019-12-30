import 'dart:ui';

import 'package:flutter_exercise/utils/print_helper.dart';

import 'exercise_offset.dart';

class Rectangle {
  Offset start;
  double w;
  double h;
  double area;

  ///数据转换使用
  double baseLength = 1;

  Rectangle(Offset start, double width, double height) {
    this.start = start;
    this.w = width;
    this.h = height;
    this.area = width * height;
  }

  Rectangle.fromJSON(Map<String, dynamic> json) {
    printHelper(json);
    start = Offset(ExerciseOffset.fromJson(json['start']).dx, ExerciseOffset.fromJson(json['start']).dy);
    w = json['w'];
    h = json['h'];
    area = json['area'];
  }

  Map<String, dynamic> toJSON() {
    return {
      'start': ExerciseOffset(start.dx / baseLength, start.dy / baseLength).toJson(),
      'w': w / baseLength,
      'h': h / baseLength,
      'area': area
    };
  }

  void setBaseLength(double length) {
    this.baseLength = length;
    start = Offset(start.dx * length, start.dy * length);
    w = w * length;
    h = h * length;
  }

  //判断点是否在矩形内部
  bool isPointIn(Offset point) {
    return point.dx - this.start.dx >= 0 && point.dx - this.start.dx <= w && point.dy - this.start.dy >= 0 && point.dy - this.start.dy <= h;
  }

  //复制矩形数据
  void copyOtherRectangle(Rectangle rectangle) {
    start = rectangle.start;
    w = rectangle.w;
    h = rectangle.h;
  }

  //深拷贝新的矩形
  Rectangle copyRectangle() {
    return Rectangle(start, w, h);
  }
}
