import 'dart:ui';
import 'dart:math';

import 'package:flutter_exercise/exerciseframework/formulae/exercise_offset.dart';
import 'package:flutter_exercise/exerciseframework/formulae/point.dart';
import 'package:flutter_exercise/utils/print_helper.dart';


//直线公式(斜截式)，k为斜率，b为常量
class Line {
  ExerciseOffset start;
  ExerciseOffset end;
  double k;
  double b;

  Offset get getStart => start;
  Offset get getEnd => end;

  Line(Offset start, Offset end) {
    this.start = ExerciseOffset(start.dx, start.dy);
    this.end = ExerciseOffset(end.dx, end.dy);
    double x1 = start.dx, y1 = start.dy, x2 = end.dx, y2 = end.dy;
    k = (y2 - y1) / (x2 - x1);
    b = (x2 * y1 - x1 * y2) / (x2 - x1);
    //  printHelper('斜率k:$k');
  }

  Line.fromJson(Map<String, dynamic> json) {
    start = json['start'] != null ? new ExerciseOffset.fromJson(json['start']) : null;
    end = json['end'] != null ? new ExerciseOffset.fromJson(json['end']) : null;
    double x1 = start.dx, y1 = start.dy, x2 = end.dx, y2 = end.dy;
    k = (y2 - y1) / (x2 - x1);
    b = (x2 * y1 - x1 * y2) / (x2 - x1);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.start != null) {
      data['start'] = this.start.toJson();
    }
    if (this.end != null) {
      data['end'] = this.end.toJson();
    }
    return data;
  }
}

//是否同一条线段
bool isSameLine(Line line1, Line line2) {
  Offset line1Start = line1.start;
  Offset line1End = line1.end;
  Offset line2Start = line2.start;
  Offset line2End = line2.end;
  bool sameDirection = ((line1Start.dx - line2Start.dx).abs() < 0.001 && (line1Start.dy - line2Start.dy).abs() < 0.001)
      && ((line1End.dx - line2End.dx).abs() < 0.001 && (line1End.dy - line2End.dy).abs() < 0.001);
  bool oppositeDirection = ((line1Start.dx - line2End.dx).abs() < 0.001 && (line1Start.dy - line2End.dy).abs() < 0.001)
      && ((line1End.dx - line2Start.dx).abs() < 0.001 && (line1End.dy - line2Start.dy).abs() < 0.001);
  return sameDirection || oppositeDirection;
}

//TODO 暂时不需要判断线段的子集，该方法暂时暂停开发
/////线段[line1] 是否为 线段[line2] 的子集
//bool isIncludeLine(Line line1, Line line2) {
//  if (line1.k != double.infinity && line1.k != double.negativeInfinity
//      && line2.k != double.infinity && line2.k != double.negativeInfinity) {
//    //判断非竖直线段是否共线
//
//  } else {
//
//  }
//}

///判断一条线段是否在集合中
bool isLineInList(Line targetLine, List<Line> list) {
  for (Line line in list) {
    if (isSameLine(line, targetLine)) {
      return true;
    }
  }

  return false;
}

///判断两条线是否平行
bool isParallelLine(Line line1, Line line2) {
  return (line1.k - line2.k).abs() < 0.001;
}

/// 计算line1 到 line2 的 转向角为θ
num includedAngle(Line line1, Line line2) {
  double k1 = line1.k;
  double k2 = line2.k;
  // 通过反正切函数计算夹角弧度
  double radians = atan((k2 - k1) / (1 + k1 * k2));
  // 将弧度转换为角度
  num angle = pi * radians / 90;
  return angle;
}

///平面方向向量AB→
Offset vector2D(Offset A, Offset B) {
  return Offset(B.dx - A.dx, B.dy - A.dy);
}

///绘制虚线
///[p1] 起始点
///[p2] 结束点
///[dashLength] 每个虚线的长度
///[space] 每个虚线的间隔
void drawDashLine(Offset p1, Offset p2, double dashLength, double space, Paint paint,Canvas canvas) {
  Offset vector = vector2D(p1, p2);
  double lineLength = distance(p1, p2);
  //计算总的要绘制多少段
  int piece = (lineLength / (dashLength + space)).ceil();
  //计算dash的移动比率
  double dashRatio = dashLength / lineLength;
  double spaceRatio = space / lineLength;

  List<Offset> dashList = List();
  dashList.add(p1);
  for (int i = 0; i < piece; i++) {
    double transformStart = dashRatio * i + spaceRatio * i;
    Offset dashStart = Offset(p1.dx + vector.dx * transformStart, p1.dy + vector.dy * transformStart);
    dashList.add(dashStart);

    if (i == piece - 1) {
      //解决虚线可能超出范围的问题，直接将最后一个点设置为结束点
      dashList.add(p2);
    } else {
      double transformEnd = dashRatio * (i + 1) + spaceRatio * i;
      Offset dashEnd = Offset(p1.dx + vector.dx * transformEnd, p1.dy + vector.dy * transformEnd);
      dashList.add(dashEnd);
    }
  }

  //开始绘制
  for (int index = 1; index < dashList.length; index+=2) {
    Offset start = dashList.elementAt(index);
    Offset end = dashList.elementAt(index + 1);
    canvas.drawLine(start, end, paint);
  }
}

///合并线段
///因为在插入线段的时候规定了屏幕坐标的x轴正方向为线段方向，所以合并线段的时候
///只需要判断线段的端点是否有交差即可
///[newLine] 新绘制出的线段
///[oldLine] 就的线段
Line combineLine(Line newLine, Line oldLine) {

  if (newLine.k != double.infinity && newLine.k != double.negativeInfinity
      && oldLine.k != double.infinity && oldLine.k != double.negativeInfinity) {

    //判断非竖直线段是否共线
    if (((newLine.k - oldLine.k).abs() < 0.001) && ((newLine.b - oldLine.b).abs() < 0.001)) {
      //是否交集可以合并
      if ((oldLine.start.dx <= newLine.start.dx && newLine.start.dx <= oldLine.end.dx)
          || (oldLine.start.dx <= newLine.end.dx && newLine.end.dx <= oldLine.end.dx)) {
        //共线且线段有交集可以合并
        printHelper("非竖直线段共线合并");
        //合并
        ExerciseOffset combineStart = newLine.start.dx <= oldLine.start.dx ? newLine.start : oldLine.start;
        ExerciseOffset combineEnd = newLine.end.dx <= oldLine.end.dx ? oldLine.end : newLine.end;
        return Line(combineStart, combineEnd);
      }

    }

  } else {
    //判断竖直线段是否共线
    if ((newLine.start.dx - oldLine.start.dx).abs() < 0.001) {
      //是否交集可以合并
      if ((oldLine.start.dy <= newLine.start.dy && newLine.start.dy <= oldLine.end.dy)
          || (oldLine.start.dy <= newLine.end.dy && newLine.end.dy <= oldLine.end.dy)) {
        //共线且线段有交集可以合并
        printHelper("竖直线段共线合并");
        //合并
        ExerciseOffset combineStart = newLine.start.dy <= oldLine.start.dy ? newLine.start : oldLine.start;
        ExerciseOffset combineEnd = newLine.end.dy <= oldLine.end.dy ? oldLine.end : newLine.end;
        return Line(combineStart, combineEnd);
      }

    }
  }

  return null;
}