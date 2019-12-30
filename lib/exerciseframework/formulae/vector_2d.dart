import 'dart:ui';

//二维向量
class Vector2d {
  double x;
  double y;

  Vector2d(double x, double y) {
    this.x = x;
    this.y = y;
  }

  //点乘
  double dot(Vector2d vec) {
    return x * vec.x + y * vec.y;
  }

  //叉乘
  double cross(Vector2d vec) {
    return x * vec.y - y * vec.x;
  }

  //减法
  Vector2d minus(Vector2d vec) {
    return Vector2d(x - vec.x, y - vec.y);
  }

  //判断点M,N是否在直线AB的同一侧
  static bool isPointAtSameSideOfLine(
      Offset pointM, Offset pointN, Offset pointA, Offset pointB) {
    Vector2d ab = Vector2d(pointB.dx - pointA.dx, pointB.dy - pointA.dy);
    Vector2d am = Vector2d(pointM.dx - pointA.dx, pointM.dy - pointA.dy);
    Vector2d an = Vector2d(pointN.dx - pointA.dx, pointN.dy - pointA.dy);
    return ab.cross(am) * ab.cross(an) >= 0;
  }
}

//
//    //判断点M,N是否在直线AB的同一侧
//    static bool IsPointAtSameSideOfLine(const Vector2d &pointM, const Vector2d &pointN,
//                                        const Vector2d &pointA, const Vector2d &pointB)
//    {
//        Vector2d AB = pointB.Minus(pointA);
//        Vector2d AM = pointM.Minus(pointA);
//        Vector2d AN = pointN.Minus(pointA);
//
//        //等于0时表示某个点在直线上
//        return AB.CrossProduct(AM) * AB.CrossProduct(AN) >= 0;
//    }
//};
