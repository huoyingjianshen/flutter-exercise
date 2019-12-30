import 'dart:ui';
import 'package:flutter_exercise/exerciseframework/formulae/vector_2d.dart';
import 'package:flutter_exercise/utils/print_helper.dart';

import 'package:flutter_exercise/exerciseframework/formulae/line.dart';
import 'package:flutter_exercise/exerciseframework/formulae/point.dart';
import 'dart:math';

enum TriangleType {
  areaTop1,
  areaLeft1,
  areaBottom1,
  areaRight1,
  areaTop2,
  areaLeft2,
  areaBottom2,
  areaRight2,
  areaTop3,
  areaLeft3,
  areaBottom3,
  areaRight3,
  areaTop4,
  areaLeft4,
  areaBottom4,
  areaRight4,
  areaMirrorTop2,
  areaMirrorLeft2,
  areaMirrorBottom2,
  areaMirrorRight2,
  areaMirrorTop3,
  areaMirrorLeft3,
  areaMirrorBottom3,
  areaMirrorRight3,
  areaMirrorTop4,
  areaMirrorLeft4,
  areaMirrorBottom4,
  areaMirrorRight4,
  defaultType,
}

class Triangle {
  Offset pointA;
  Offset pointB;
  Offset pointC;
  TriangleType type;
  double area;

  ///外心
  Offset center;

  ///转换计算使用
  double baseLength = 1;
  double calArea;

  Triangle({this.pointA, this.pointB, this.pointC, this.type, this.baseLength}) {
    this.area = (pointA.dx * pointB.dy -
        pointA.dx * pointC.dy +
        pointB.dx * pointC.dy -
        pointB.dx * pointA.dy +
        pointC.dx * pointA.dy -
        pointB.dx * pointB.dy);
  }

  ///传输转换
  Triangle.fromJSON(Map<String, dynamic> json) {
    printHelper(json);
    pointA = Offset(TrianglePoint.fromJSON(json['pointA']).dx,
        TrianglePoint.fromJSON(json['pointA']).dy);
    pointB = Offset(TrianglePoint.fromJSON(json['pointB']).dx,
        TrianglePoint.fromJSON(json['pointB']).dy);
    pointC = Offset(TrianglePoint.fromJSON(json['pointC']).dx,
        TrianglePoint.fromJSON(json['pointC']).dy);
    area = json['area'];
  }

  Map<String, dynamic> toJSON() {
    return {
      'pointA':
          TrianglePoint(Offset(pointA.dx / baseLength, pointA.dy / baseLength))
              .toJSON(),
      'pointB':
          TrianglePoint(Offset(pointB.dx / baseLength, pointB.dy / baseLength))
              .toJSON(),
      'pointC':
          TrianglePoint(Offset(pointC.dx / baseLength, pointC.dy / baseLength))
              .toJSON(),
      'area': area
    };
  }

  void setBaseLength(double length) {
    this.baseLength = length;
    pointA = Offset(pointA.dx * length, pointA.dy * length);
    pointB = Offset(pointB.dx * length, pointB.dy * length);
    pointC = Offset(pointC.dx * length, pointC.dy * length);
  }

  ///判断点是否在三角形内部
  bool isPointIn(Offset point) {
    bool isInTriangle = false;
    Vector2d pa = Vector2d(pointA.dx - point.dx, pointA.dy - point.dy);
    Vector2d pb = Vector2d(pointB.dx - point.dx, pointB.dy - point.dy);
    Vector2d pc = Vector2d(pointC.dx - point.dx, pointC.dy - point.dy);
    final result1 = pa.cross(pb);
    final result2 = pb.cross(pc);
    final result3 = pc.cross(pa);
    if (result1 > 0) {
      isInTriangle = result2 >= 0 && result3 >= 0;
    } else if (result1 < 0) {
      isInTriangle = result2 <= 0 && result3 <= 0;
    } else {
      if (result2 > 0) {
        isInTriangle = result3 >= 0;
      } else if (result2 < 0) {
        isInTriangle = result3 <= 0;
      } else {
        isInTriangle = true;
      }
    }
    return isInTriangle;
  }

  ///判断三角形重叠
  bool isCover(Triangle triangle) {
    bool isCover = false;
    if (triangle.isPointIn(pointA) &&
            triangle.isPointIn(pointB) &&
            triangle.isPointIn(pointC) ||
        isPointIn(triangle.pointA) &&
            isPointIn(triangle.pointB) &&
            isPointIn(triangle.pointC)) {
      printHelper('三角形包含了另一个三角形');
      return true;
    }
    List<Line> lineList1 = [
      Line(pointA, pointB),
      Line(pointB, pointC),
      Line(pointC, pointA)
    ];
    List<Line> lineList2 = [
      Line(triangle.pointA, triangle.pointB),
      Line(triangle.pointB, triangle.pointC),
      Line(triangle.pointC, triangle.pointA)
    ];
    for (Line line1 in lineList1) {
      outer:
      for (Line line2 in lineList2) {
        Offset crossPoint = calCrossoverPoint(line1, line2, Size.infinite);
        if (crossPoint != null && ((isCrossPointInLine(crossPoint, line1, true) &&
            isCrossPointInLine(crossPoint, line2, false)) ||
            (isCrossPointInLine(crossPoint, line1, false) &&
                isCrossPointInLine(crossPoint, line2, true)))
                ) {
          isCover = true;
          break outer;
        } else {
          continue;
        }
      }
    }
    return isCover;
  }

  ///判断交点是否在线段内
  bool isCrossPointInLine(Offset point, Line line, bool containEdge) {
    printHelper(point.toString());
    if (containEdge) {
      return (point.dx <= max(line.start.dx, line.end.dx) &&
          point.dx >= min(line.start.dx, line.end.dx) &&
          point.dy <= max(line.start.dy, line.end.dy) &&
          point.dy >= min(line.start.dy, line.end.dy));
    } else {
      return (point.dx <= max(line.start.dx, line.end.dx) - 0.0001 &&
          point.dx >= min(line.start.dx, line.end.dx) + 0.0001 &&
          point.dy <= max(line.start.dy, line.end.dy) - 0.0001 &&
          point.dy >= min(line.start.dy, line.end.dy) + 0.0001);
    }
  }

  ///由直角三角形斜边中点生成三角形
  Triangle.center(
      Offset center, double sideLength, TriangleType type, double baseLength) {
    this.center = center;
    this.type = type;
    this.baseLength = baseLength;
    switch (type) {
      case TriangleType.areaTop1:
        this.pointA =
            Offset(center.dx - sideLength * 0.5, center.dy - sideLength * 0.5);

        this.pointB =
            Offset(center.dx - sideLength * 0.5, center.dy + sideLength * 0.5);
        this.pointC =
            Offset(center.dx + sideLength * 0.5, center.dy + sideLength * 0.5);
        this.calArea = 0.5;
        break;
      case TriangleType.areaLeft1:
        this.pointA =
            Offset(center.dx + sideLength * 0.5, center.dy - sideLength * 0.5);
        this.pointB =
            Offset(center.dx - sideLength * 0.5, center.dy + sideLength * 0.5);
        this.pointC =
            Offset(center.dx + sideLength * 0.5, center.dy + sideLength * 0.5);
        this.calArea = 0.5;
        break;
      case TriangleType.areaBottom1:
        this.pointA =
            Offset(center.dx - sideLength * 0.5, center.dy - sideLength * 0.5);
        this.pointB =
            Offset(center.dx + sideLength * 0.5, center.dy - sideLength * 0.5);
        this.pointC =
            Offset(center.dx + sideLength * 0.5, center.dy + sideLength * 0.5);
        this.calArea = 0.5;
        break;
      case TriangleType.areaRight1:
        this.pointA =
            Offset(center.dx - sideLength * 0.5, center.dy - sideLength * 0.5);
        this.pointB =
            Offset(center.dx - sideLength * 0.5, center.dy + sideLength * 0.5);
        this.pointC =
            Offset(center.dx + sideLength * 0.5, center.dy - sideLength * 0.5);
        this.calArea = 0.5;
        break;
      case TriangleType.areaTop2:
        this.pointA =
            Offset(center.dx - sideLength, center.dy - sideLength * 0.5);
        this.pointB =
            Offset(center.dx - sideLength, center.dy + sideLength * 0.5);
        this.pointC =
            Offset(center.dx + sideLength, center.dy + sideLength * 0.5);
        this.calArea = 1;
        break;
      case TriangleType.areaLeft2:
        this.pointA =
            Offset(center.dx + sideLength * 0.5, center.dy - sideLength);
        this.pointB =
            Offset(center.dx - sideLength * 0.5, center.dy + sideLength);
        this.pointC =
            Offset(center.dx + sideLength * 0.5, center.dy + sideLength);
        this.calArea = 1;
        break;
      case TriangleType.areaBottom2:
        this.pointA =
            Offset(center.dx - sideLength, center.dy - sideLength * 0.5);
        this.pointB =
            Offset(center.dx + sideLength, center.dy - sideLength * 0.5);
        this.pointC =
            Offset(center.dx + sideLength, center.dy + sideLength * 0.5);
        this.calArea = 1;
        break;
      case TriangleType.areaRight2:
        this.pointA =
            Offset(center.dx - sideLength * 0.5, center.dy - sideLength);
        this.pointB =
            Offset(center.dx - sideLength * 0.5, center.dy + sideLength);
        this.pointC =
            Offset(center.dx + sideLength * 0.5, center.dy - sideLength);
        this.calArea = 1;
        break;
      case TriangleType.areaTop3:
        this.pointA =
            Offset(center.dx - sideLength * 1.5, center.dy - sideLength * 0.5);
        this.pointB =
            Offset(center.dx - sideLength * 1.5, center.dy + sideLength * 0.5);
        this.pointC =
            Offset(center.dx + sideLength * 1.5, center.dy + sideLength * 0.5);
        this.calArea = 1.5;
        break;
      case TriangleType.areaLeft3:
        this.pointA =
            Offset(center.dx + sideLength * 0.5, center.dy - sideLength * 1.5);
        this.pointB =
            Offset(center.dx - sideLength * 0.5, center.dy + sideLength * 1.5);
        this.pointC =
            Offset(center.dx + sideLength * 0.5, center.dy + sideLength * 1.5);
        this.calArea = 1.5;
        break;
      case TriangleType.areaBottom3:
        this.pointA =
            Offset(center.dx - sideLength * 1.5, center.dy - sideLength * 0.5);
        this.pointB =
            Offset(center.dx + sideLength * 1.5, center.dy - sideLength * 0.5);
        this.pointC =
            Offset(center.dx + sideLength * 1.5, center.dy + sideLength * 0.5);
        this.calArea = 1.5;
        break;
      case TriangleType.areaRight3:
        this.pointA =
            Offset(center.dx - sideLength * 0.5, center.dy - sideLength * 1.5);
        this.pointB =
            Offset(center.dx - sideLength * 0.5, center.dy + sideLength * 1.5);
        this.pointC =
            Offset(center.dx + sideLength * 0.5, center.dy - sideLength * 1.5);
        this.calArea = 1.5;
        break;
      case TriangleType.areaTop4:
        this.pointA =
            Offset(center.dx - sideLength * 1.5, center.dy - sideLength);
        this.pointB =
            Offset(center.dx - sideLength * 1.5, center.dy + sideLength);
        this.pointC =
            Offset(center.dx + sideLength * 1.5, center.dy + sideLength);
        this.calArea = 3;
        break;
      case TriangleType.areaLeft4:
        this.pointA =
            Offset(center.dx + sideLength, center.dy - sideLength * 1.5);
        this.pointB =
            Offset(center.dx - sideLength, center.dy + sideLength * 1.5);
        this.pointC =
            Offset(center.dx + sideLength, center.dy + sideLength * 1.5);
        this.calArea = 3;
        break;
      case TriangleType.areaBottom4:
        this.pointA =
            Offset(center.dx - sideLength * 1.5, center.dy - sideLength);
        this.pointB =
            Offset(center.dx + sideLength * 1.5, center.dy - sideLength);
        this.pointC =
            Offset(center.dx + sideLength * 1.5, center.dy + sideLength);
        this.calArea = 3;
        break;
      case TriangleType.areaRight4:
        this.pointA =
            Offset(center.dx - sideLength, center.dy - sideLength * 1.5);
        this.pointB =
            Offset(center.dx - sideLength, center.dy + sideLength * 1.5);
        this.pointC =
            Offset(center.dx + sideLength, center.dy - sideLength * 1.5);
        this.calArea = 3;
        break;
      case TriangleType.areaMirrorTop2:
        this.pointA =
            Offset(center.dx + sideLength, center.dy - sideLength * 0.5);
        this.pointB =
            Offset(center.dx - sideLength, center.dy + sideLength * 0.5);
        this.pointC =
            Offset(center.dx + sideLength, center.dy + sideLength * 0.5);
        this.calArea = 1;
        break;
      case TriangleType.areaMirrorLeft2:
        this.pointA =
            Offset(center.dx + sideLength * 0.5, center.dy - sideLength);
        this.pointB =
            Offset(center.dx - sideLength * 0.5, center.dy - sideLength);
        this.pointC =
            Offset(center.dx + sideLength * 0.5, center.dy + sideLength);
        this.calArea = 1;
        break;
      case TriangleType.areaMirrorBottom2:
        this.pointA =
            Offset(center.dx - sideLength, center.dy - sideLength * 0.5);
        this.pointB =
            Offset(center.dx + sideLength, center.dy - sideLength * 0.5);
        this.pointC =
            Offset(center.dx - sideLength, center.dy + sideLength * 0.5);
        this.calArea = 1;
        break;
      case TriangleType.areaMirrorRight2:
        this.pointA =
            Offset(center.dx - sideLength * 0.5, center.dy - sideLength);
        this.pointB =
            Offset(center.dx - sideLength * 0.5, center.dy + sideLength);
        this.pointC =
            Offset(center.dx + sideLength * 0.5, center.dy + sideLength);
        this.calArea = 1;
        break;
      case TriangleType.areaMirrorTop3:
        this.pointA =
            Offset(center.dx + sideLength * 1.5, center.dy - sideLength * 0.5);
        this.pointB =
            Offset(center.dx - sideLength * 1.5, center.dy + sideLength * 0.5);
        this.pointC =
            Offset(center.dx + sideLength * 1.5, center.dy + sideLength * 0.5);
        this.calArea = 1.5;
        break;
      case TriangleType.areaMirrorLeft3:
        this.pointA =
            Offset(center.dx + sideLength * 0.5, center.dy - sideLength * 1.5);
        this.pointB =
            Offset(center.dx - sideLength * 0.5, center.dy - sideLength * 1.5);
        this.pointC =
            Offset(center.dx + sideLength * 0.5, center.dy + sideLength * 1.5);
        this.calArea = 1.5;
        break;
      case TriangleType.areaMirrorBottom3:
        this.pointA =
            Offset(center.dx - sideLength * 1.5, center.dy - sideLength * 0.5);
        this.pointB =
            Offset(center.dx + sideLength * 1.5, center.dy - sideLength * 0.5);
        this.pointC =
            Offset(center.dx - sideLength * 1.5, center.dy + sideLength * 0.5);
        this.calArea = 1.5;
        break;
      case TriangleType.areaMirrorRight3:
        this.pointA =
            Offset(center.dx - sideLength * 0.5, center.dy - sideLength * 1.5);
        this.pointB =
            Offset(center.dx - sideLength * 0.5, center.dy + sideLength * 1.5);
        this.pointC =
            Offset(center.dx + sideLength * 0.5, center.dy + sideLength * 1.5);
        this.calArea = 1.5;
        break;
      case TriangleType.areaMirrorTop4:
        this.pointA =
            Offset(center.dx + sideLength * 1.5, center.dy - sideLength);
        this.pointB =
            Offset(center.dx - sideLength * 1.5, center.dy + sideLength);
        this.pointC =
            Offset(center.dx + sideLength * 1.5, center.dy + sideLength);
        this.calArea = 3;
        break;
      case TriangleType.areaMirrorLeft4:
        this.pointA =
            Offset(center.dx + sideLength, center.dy - sideLength * 1.5);
        this.pointB =
            Offset(center.dx - sideLength, center.dy - sideLength * 1.5);
        this.pointC =
            Offset(center.dx + sideLength, center.dy + sideLength * 1.5);
        this.calArea = 3;
        break;
      case TriangleType.areaMirrorBottom4:
        this.pointA =
            Offset(center.dx - sideLength * 1.5, center.dy - sideLength);
        this.pointB =
            Offset(center.dx + sideLength * 1.5, center.dy - sideLength);
        this.pointC =
            Offset(center.dx - sideLength * 1.5, center.dy + sideLength);
        this.calArea = 3;
        break;
      case TriangleType.areaMirrorRight4:
        this.pointA =
            Offset(center.dx - sideLength, center.dy - sideLength * 1.5);
        this.pointB =
            Offset(center.dx - sideLength, center.dy + sideLength * 1.5);
        this.pointC =
            Offset(center.dx + sideLength, center.dy + sideLength * 1.5);
        this.calArea = 3;
        break;
      default:
        break;
    }
  }
}

///构造[TrianglePoint] 点函数来代替Offset进行通信时候的json解析交互，
///等待json解析完之后再转换为对应的Offset
class TrianglePoint {
  double dx;
  double dy;

  TrianglePoint(Offset offset) {
    this.dx = offset.dx;
    this.dy = offset.dy;
  }

  TrianglePoint.fromJSON(Map<String, dynamic> json) {
    dx = json['dx'];
    dy = json['dy'];
  }

  Map<String, dynamic> toJSON() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dx'] = this.dx;
    data['dy'] = this.dy;
    return data;
  }
}
