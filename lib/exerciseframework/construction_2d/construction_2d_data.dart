import 'package:flutter/material.dart';
import 'package:flutter_exercise/datamodel/exercise/construction_2d_entity.dart';
import 'package:flutter_exercise/exerciseframework/formulae/exercise_offset.dart';
import 'dart:math';

import 'package:flutter_exercise/exerciseframework/formulae/line.dart';
import 'package:flutter_exercise/exerciseframework/formulae/point.dart';
import 'package:flutter_exercise/utils/print_helper.dart';
import 'package:flutter_exercise/utils/resize_utils.dart';


//math_cell的数据池
class MathCellData {
  //基准网格
  List<Line> baseLineList;

  //边界线条
  List<Line> borderLineList;

  //线条
  List<Line> drawLineList;

  //合并线
  List<Line> combineLineList;

  //每次合并线存入数量的标记位
  List<int> combineLineSign;

  int combineTempNum = 0;

  //扩展延长线
  List<Line> extendLineList;

  //选中的焦点
  List<Offset> focusPoints;

  // 加载题目初始化数据
  List<Offset> originPoints;
  List<Line> originLineList;

  // 加载题目答案数据
  List<Offset> targetPoints;
  List<Line> targetLineList;

  //分块查找的点
  List<List<Offset>> cubePoints;

  //分块增加点操作记录
  List<List<int>> cubeOperations;

  //绘制操作记录- key:point,新增焦点    value: 新增焦点数量0，1，2
  //            key:line,新增线段，交点和焦点  value: 交点数量，为零则此次操作为新增焦点
  List<Map<String, int>> paintOperations;

  Line tipLine;

  //提示是否可点击
  bool tipLineDisable = false;

  //网格大小
  final Size cellSize;

  //查找半径
  double _searchRadiusX, _searchRadiusY, _searchRadius;

  //绘制半径
  double originPointRadius, tempPointRadius, focusPointRadius;
  //绘制颜色
  Paint baseCellPaint,
      extendLinePaint,
      originLinePaint,
      linePaint,
      tempLinePaint,
      originPointPaint,
      confirmPointOutsidePaint,
      confirmPointInsidePaint,
      tempPointOutsidePaint,
      tempPointInsidePaint;

  //是否回答正确
  bool isAnswerRight = false;

  //回答正确后的点绘制半径
  double answerRightPointRadius;

  //回答正确后的线绘制半径
  Paint answerRightPointPaint, answerRightLinePaint;

  MathCellData({@required this.cellSize}) : super() {
    borderLineList = List();
    baseLineList = List();
    drawLineList = List();
    combineLineList = List();
    combineLineSign = List();
    extendLineList = List();
    focusPoints = List();
    originPoints = List();
    originLineList = List();
    targetPoints = List();
    targetLineList = List();
    cubeOperations = [[], [], [], [], [], [], [], [], []];
    paintOperations = [];
    _initBackground();
    _initPaint();
  }

  //初始化网格
  void _initBackground() {
    _searchRadiusX = cellSize.width / 20;
    _searchRadiusY = cellSize.height / 20;
    _searchRadius =
        sqrt(_searchRadiusX * _searchRadiusX + _searchRadiusY * _searchRadiusY);

    double x = cellSize.width / 6;
    double y = cellSize.height / 6;

    _initCubePoints();

    for (int row = 0; row < 7; row++) {
      Offset _start = Offset(0, y * row);
      Offset _end = Offset(cellSize.width, y * row);
      Line _line = Line(_start, _end);
      _calCrossoverPoint(_line);
      baseLineList.add(_line);
    }

    for (int column = 0; column < 7; column++) {
      Offset _start = Offset(x * column, 0.0);
      Offset _end = Offset(x * column, cellSize.height);
      Line _line = Line(_start, _end);
      _calCrossoverPoint(_line);
      baseLineList.add(_line);
    }

    borderLineList.add(baseLineList.elementAt(0));
    borderLineList.add(baseLineList.elementAt(6));
    borderLineList.add(baseLineList.elementAt(7));
    borderLineList.add(baseLineList.elementAt(13));
  }

  // 初始化分块点
  _initCubePoints() {
    cubePoints = [[], [], [], [], [], [], [], [], []];
  }

  _initPaint() {
    originPointRadius = resizeUtil(6.5);
    tempPointRadius = resizeUtil(4.5);
    focusPointRadius = resizeUtil(4.5);
    answerRightPointRadius = resizeUtil(4.5);

    baseCellPaint = new Paint()
      ..color = Color.fromARGB(255, 7, 57, 165)
      ..isAntiAlias = true
      ..strokeWidth = resizeUtil(2)
      ..style = PaintingStyle.stroke;

    extendLinePaint = new Paint()
      ..color = Color.fromARGB(255, 255, 255, 255)
      ..isAntiAlias = true
      ..strokeWidth = resizeUtil(3)
      ..style = PaintingStyle.stroke;

    originLinePaint = new Paint()
      ..color = Color.fromARGB(255, 27, 185, 255)
      ..isAntiAlias = true
      ..strokeWidth = resizeUtil(6)
      ..style = PaintingStyle.stroke;

    tempLinePaint = new Paint()
      ..color = Color.fromARGB(255, 171, 228, 77)
      ..isAntiAlias = true
      ..strokeWidth = resizeUtil(3)
      ..style = PaintingStyle.stroke;

    linePaint = new Paint()
      ..color = Color.fromARGB(255, 144, 115, 247)
      ..isAntiAlias = true
      ..strokeWidth = resizeUtil(3)
      ..style = PaintingStyle.stroke;

    originPointPaint = new Paint()
      ..color = Color.fromARGB(255, 27, 185, 255)
      ..isAntiAlias = true;

    confirmPointOutsidePaint = new Paint()
      ..color = Color.fromARGB(255, 65, 54, 213)
      ..isAntiAlias = true
      ..strokeWidth = resizeUtil(2)
      ..style = PaintingStyle.stroke;

    confirmPointInsidePaint = new Paint()
      ..color = Color.fromARGB(255, 144, 115, 247)
      ..isAntiAlias = true;

    tempPointOutsidePaint = new Paint()
      ..color = Color.fromARGB(255, 171, 228, 77)
      ..isAntiAlias = true
      ..strokeWidth = resizeUtil(2)
      ..style = PaintingStyle.stroke;

    tempPointInsidePaint = new Paint()
      ..color = Color.fromARGB(255, 75, 188, 4)
      ..isAntiAlias = true;

    answerRightPointPaint = new Paint()
      ..color = Color.fromARGB(255, 255, 228, 71)
      ..isAntiAlias = true;

    answerRightLinePaint = new Paint()
      ..color = Color.fromARGB(255, 255, 228, 71)
      ..isAntiAlias = true
      ..strokeWidth = resizeUtil(3)
      ..style = PaintingStyle.stroke;
  }

  // 把初始化的数据传给mathCellData
  initOriginData(Input input, Output output) {
    //初始化题目
    if (input.focusPoints != null) {
      for (ExerciseOffset point in input.focusPoints) {
        Offset offset = Offset(resizeUtil(point.dx), resizeUtil(point.dy));
        originPoints.add(offset);
      }
    }
    if (input.drawLineList != null) {
      for (Line line in input.drawLineList) {
        Line tempLine = Line(
            Offset(resizeUtil(line.start.dx), resizeUtil(line.start.dy)),
            Offset(resizeUtil(line.end.dx), resizeUtil(line.end.dy)));
        originLineList.add(tempLine);
      }
    }

    //初始化答案
    if (output.focusPoints != null) {
      for (ExerciseOffset point in output.focusPoints) {
        Offset offset = Offset(resizeUtil(point.dx), resizeUtil(point.dy));
        targetPoints.add(offset);
      }
    }
    if (output.drawLineList != null) {
      for (Line line in output.drawLineList) {
        Line tempLine = Line(
            Offset(resizeUtil(line.start.dx), resizeUtil(line.start.dy)),
            Offset(resizeUtil(line.end.dx), resizeUtil(line.end.dy)));
        targetLineList.add(tempLine);
      }
    }
  }

  _calCrossoverPoint(Line newLine) {
    int pointCount = 0;
    for (Line line in baseLineList) {
      Offset _crossOffset = calCrossoverPoint(line, newLine, cellSize);
      if (_crossOffset != null) {
        printHelper("pointcount++");
        pointCount++;
        _insertCubePoint(_crossOffset);
      }
    }

    for (Line line in originLineList) {
      Offset _crossOffset = calCrossoverPoint(line, newLine, cellSize);
      if (_crossOffset != null) {
        pointCount++;
        _insertCubePoint(_crossOffset);
      }
    }

    for (Line line in drawLineList) {
      Offset _crossOffset = calCrossoverPoint(line, newLine, cellSize);
      if (_crossOffset != null) {
        pointCount++;
        _insertCubePoint(_crossOffset);
      }
    }
    if (baseLineList.length == 14) {
      addPaintOperation(true, 0, pointCount);
    }
  }

  // 分块添加新点
  _insertCubePoint(Offset point) {
    double gap = cellSize.width / 3;
    int row = (point.dx / gap).floor().abs();
    int column = (point.dy / gap).floor().abs();
    if (row >= 3) {
      row = 2;
    }
    if (column >= 3) {
      column = 2;
    }
    int index = row + column * 3;
    List<Offset> cube = cubePoints[index];
    cube.add(point);
    List<int> cubeOperation = cubeOperations[index];
    if (cubeOperation.length > 0) {
      cubeOperation.last++;
    }
  }

  // 分块查找最近点
  Offset searchCubeNearestPoint(Offset refer) {
    if (refer != null) {
      double distance = double.maxFinite;
      int cubeIndex = -1;
      int cubePointIndex = -1;
      //分块遍历，取出可能点
      double gap = cellSize.width / 3;
      int row = (refer.dx / gap).floor().abs();
      int column = (refer.dy / gap).floor().abs();
      if (row >= 3) {
        row = 2;
      }
      if (column >= 3) {
        column = 2;
      }
      cubeIndex = row + column * 3;
      List<Offset> cube = [];
      List<Offset> mainCube = cubePoints[cubeIndex];
      cube.addAll(mainCube);
      bool isLeft = (refer.dx - row * gap) < (gap / 4);
      bool isTop = (refer.dy - column * gap) < (gap / 4);
      int topColumn = isTop ? column - 1 : column + 1;
      int leftRow = isLeft ? row - 1 : row + 1;
      if (topColumn >= 0 && topColumn < 3) {
        cube.addAll(cubePoints[topColumn * 3 + row]);
      }
      if (leftRow >= 0 && leftRow < 3) {
        cube.addAll(cubePoints[leftRow + column * 3]);
      }
      if (topColumn >= 0 && topColumn < 3 && leftRow >= 0 && leftRow < 3) {
        List<Offset> moreCube = cubePoints[leftRow + topColumn * 3];
        cube.addAll(moreCube);
      }

      for (int i = 0; i < cube.length; i++) {
        Offset cubePoint = cube[i];
        if ((refer.dx - cubePoint.dx).abs() < _searchRadiusX &&
            (refer.dy - cubePoint.dy).abs() < _searchRadiusY) {
          double nowDistance = sqrt(
              (cubePoint.dx - refer.dx) * (cubePoint.dx - refer.dx) +
                  (cubePoint.dy - refer.dy) * (cubePoint.dy - refer.dy));
          if (nowDistance < _searchRadius && distance > nowDistance) {
            cubePointIndex = i;
            distance = nowDistance;
          }
        }
      }
      return cubePointIndex >= 0 ? cube[cubePointIndex] : null;
    }
    return null;
  }

  //查询是否在原有的绘制队列中，如果不存在，则绘制圆点
  bool insertFocusPoint(Offset refer) {
    if (originPoints != null) {
      if (pointInList(refer, originPoints)) {
//        printHelper('有重复点');
        return false;
      }
    }

    if (focusPoints != null) {
      if (!pointInList(refer, focusPoints)) {
        focusPoints.add(refer);
        return true;
      } else {
//        printHelper('有重复点');
        return false;
      }
    } else {
      return false;
    }
  }

  // 删除焦点
  void removeFocusPoint() {
    if (focusPoints != null) {
      focusPoints.removeLast();
    }
  }

  bool insertLine(Line line) {
    if (line.k != double.infinity && line.k != double.negativeInfinity) {
      //非竖直线段，规定屏幕坐标系的X轴正向为线段的方向，便于之后的线段合并计算
      if (line.end.dx <= line.start.dx) {
        line = Line(line.end, line.start);
      }
    } else {
      //竖直线段，规定屏幕坐标系的Y轴正向为线段的方向，便于之后的线段合并计算
      if (line.end.dy <= line.start.dy) {
        line = Line(line.end, line.start);
      }
    }

    for (Line originLine in originLineList) {
      if (isSameLine(line, originLine)) {
//        printHelper('有重复线段');
        return false;
      }
    }

    //排除同一条线段
    for (Line drawLine in drawLineList) {
      if (isSameLine(line, drawLine)) {
//        printHelper('有重复线段');
        return false;
      }
    }

    for (List<int> cubeOperation in cubeOperations) {
      cubeOperation.add(0);
    }
    _calCrossoverPoint(line);
    _calExtendLine(line);
    _calCombineLine(line);
    drawLineList.add(line);
    _calTipDisable();
    return true;
  }

  //计算和边界的交点，并添加延长线
  void _calExtendLine(Line line) {
    List<Offset> extendOffsets = List();
    for (int i = 0; i < borderLineList.length; i++) {
      Line borderLine = borderLineList.elementAt(i);
      Offset offset = calCrossoverPoint(line, borderLine, cellSize);
      if (offset != null && !pointInList(offset, extendOffsets)) {
        extendOffsets.add(offset);
      }
    }
    //添加延长线
    if (extendOffsets.length == 2) {
      extendLineList.add(Line(extendOffsets.elementAt(0), extendOffsets.elementAt(1)));
    }
  }

  //计算合并线
  void _calCombineLine(Line line) {
    combineTempNum = 0;
    _combine(line);
    if (combineTempNum > 0) {
      combineLineSign.add(combineTempNum);
    }
  }

  void _combine(Line line) {
    for (Line drawLine in drawLineList) {
      Line combine = combineLine(line, drawLine);
      if (combine != null) {
        combineTempNum ++;
        combineLineList.add(combine);
      }
    }

    //TODO 跨线段连接，计算两次能够将断开的线段都连接上，不过有待改进计算过程
    List<Line> tempComb1 = List();

    combineLineList.forEach((comb) {
      Line combine = combineLine(line, comb);
      if (combine != null) {
        combineTempNum ++;
        tempComb1.add(combine);
      }
    });

    combineLineList.addAll(tempComb1);

    List<Line> tempComb2 = List();

    combineLineList.forEach((comb) {
      Line combine = combineLine(line, comb);
      if (combine != null) {
        combineTempNum ++;
        tempComb2.add(combine);
      }
    });

    combineLineList.addAll(tempComb2);
  }

  //查看提示的线段是否在已经绘制的集合中
  void _calTipDisable() {
    Line tipLine = targetLineList.last;
    if (isLineInList(tipLine, drawLineList) ||
        isLineInList(tipLine, combineLineList)) {
      tipLineDisable = true;
    } else {
      tipLineDisable = false;
    }
  }

  // 清空绘制
  void clearData() {
    drawLineList.clear();
    extendLineList.clear();
    paintOperations.clear();
    focusPoints.clear();
    combineLineList.clear();
    tipLineDisable = false;
    if (cubePoints != null && cubePoints.length > 0) {
      final countList = [4, 4, 6, 4, 4, 6, 6, 6, 9];
      for (int i = 0; i < countList.length; i++) {
        if (cubePoints[i].length > countList[i]) {
          cubePoints[i].removeRange(countList[i], cubePoints[i].length);
        }
      }
    }
    if (cubeOperations != null && cubeOperations.length > 0) {
      cubeOperations.forEach((cubeOperation) {
        cubeOperation.clear();
      });
    }
  }

  // 撤销绘制
  void revokeData() {
    if (paintOperations.length > 0) {
      var operation = paintOperations.last;
      if (operation['line'] != 0) {
        //删除线
        for (int i = 0; i < 9; i++) {
          final cubeOperation = cubeOperations[i];
          final cubePointList = cubePoints[i];
          if (cubePointList.length > 0 && cubeOperation.length > 0) {
            if (cubeOperation.last > 0) {
              cubePointList.removeRange(
                  cubePointList.length - cubeOperation.last,
                  cubePointList.length);
            }
            cubeOperation.removeLast();
          }
        }
        if (drawLineList.length > 0) {
          drawLineList.removeLast();
        }
        if (extendLineList.length > 0) {
          extendLineList.removeLast();
        }
        if (combineLineSign.length > 0) {
          int num = combineLineSign.last;
          if (combineLineList.length >= num) {
            combineLineList.removeRange(combineLineList.length - num, combineLineList.length);
          }
          combineLineSign.removeLast();
        }
      }
      //删除焦点
      int count = operation['point'];
      if (count > 0) {
        focusPoints.removeRange(focusPoints.length - count, focusPoints.length);
      }
      paintOperations.removeLast();
    }
    //重新计算是否要提示线
    _calTipDisable();
  }

  void addPaintOperation(bool newOperation, int focusCount, int crossCount) {
    Map<String, int> operation = {};
    if (newOperation) {
      operation['point'] = focusCount;
      operation['line'] = crossCount;
      paintOperations.add(operation);
    } else {
      operation = paintOperations.last;
      operation['point'] += focusCount;
      operation['line'] += crossCount;
    }
  }

  void showTipLine(bool show) {
    if (show) {
      tipLine = targetLineList.last;
    } else {
      tipLine = null;
    }
  }

  ///验证做题结果
  bool verifyResult() {
    num originPointsNum = originPoints.length;
    num originLineListNum = originLineList.length;
    num targetPointsNum = targetPoints.length;
    num targetLineListNum = targetLineList.length;
    num focusPointsNum = focusPoints.length;
    num drawLineListNum = drawLineList.length;

    // 集合数量满足了再进行判断
    if (targetPointsNum <= originPointsNum + focusPointsNum &&
        targetLineListNum <= originLineListNum + drawLineListNum) {
      for (Offset offset in targetPoints) {
        if (!pointInList(offset, originPoints) &&
            !pointInList(offset, focusPoints)) {
          return false;
        }
      }

      for (Line targetLine in targetLineList) {
        if (!isLineInList(targetLine, originLineList) &&
            !isLineInList(targetLine, drawLineList) &&
            !isLineInList(targetLine, combineLineList)) {
          return false;
        }
      }

      isAnswerRight = true;
      return isAnswerRight;
    } else {
      return false;
    }
  }

  void test() {}
}
