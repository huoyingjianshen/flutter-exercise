import 'package:flutter/material.dart';
import 'package:flutter_exercise/datamodel/exercise/construction_2d_entity.dart';
import 'package:flutter_exercise/exerciseframework/common/common_image_button.dart';
import 'package:flutter_exercise/exerciseframework/construction_2d/construction_2d_data.dart';
import 'package:flutter_exercise/exerciseframework/core/formwork.dart';
import 'package:flutter_exercise/exerciseframework/formulae/line.dart';
import 'package:flutter_exercise/exerciseframework/formulae/point.dart';
import 'package:flutter_exercise/utils/print_helper.dart';
import 'package:flutter_exercise/utils/resize_utils.dart';
import 'package:flutter_exercise/utils/ui_utils.dart';

class Construction2DState extends BaseExerciseFormWorkState {
  Construction2DEntity construction2dEntity;

  MathCellData mathCellData;
  Offset _lineStart, _lineEnd;
  Line _tempLine;
  Offset _tempPoint;
  Size _cellSize;
  bool _startOperation;

  //如果不是教师出题模式，则在绘制的同时开启题目验证，否则不验证
  bool teacherMode = false;

  @override
  void initState() {
    super.initState();
    _startOperation = false;
    _cellSize = Size(resizeUtil(324), resizeUtil(324));
    mathCellData = new MathCellData(cellSize: _cellSize);
    // 把传入的题目数据解析出来
    construction2dEntity = formWorkFactory.exerciseEntity;
    if (construction2dEntity != null &&
        construction2dEntity.input != null &&
        construction2dEntity.output != null) {
      mathCellData.initOriginData(
          construction2dEntity.input, construction2dEntity.output);
    }
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey anchorKey = GlobalKey();
    double mainHeight = screenContentHeight + safeAreaBottom;

    return Container(
      width: screenContentWidth,
      height: mainHeight,
//      decoration: BoxDecoration(
//          image: DecorationImage(
//              image: AssetImage(
//                  "assets/res/drawable/bg_exercise_construction_2d.png"),
//              fit: BoxFit.fill)),
      child: Column(
        children: <Widget>[
          Container(
            width: resizeUtil(314),
            height: resizeUtil(64),
            margin: EdgeInsets.only(top: resizeUtil(39.5)),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 231, 246, 255),
              borderRadius: BorderRadius.circular(resizeUtil(32)),
            ),
            child: Container(
              width: resizeUtil(225),
              alignment: Alignment.center,
              child: Text(
//                '${construction2dEntity?.input?.questionDesc ?? ''}',
                'construction2d_test',
                textAlign: TextAlign.left,
                maxLines: 2,
                style: TextStyle(
                  color: Color.fromARGB(255, 101, 120, 178),
                  fontSize: resizeUtil(16),
                ),
              ),
            ),
          ),
          Container(
            width: resizeUtil(346),
            height: resizeUtil(346),
            margin: EdgeInsets.only(top: resizeUtil(29)),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color.fromARGB(204, 5, 30, 136),
              borderRadius: BorderRadius.circular(resizeUtil(10)),
            ),
            child: Center(
              child: Container(
                  width: _cellSize.width,
                  height: _cellSize.height,
                  child: GestureDetector(
                    child: CustomPaint(
                      key: anchorKey,
                      isComplex: true,
                      painter: MathCell(
                        mathCellData: mathCellData,
                        tempLine: _tempLine,
                        tempPoint: _tempPoint,
                      ),
                    ),
                    onPanDown: (details) {
                      setState(() {
                        RenderBox renderBox =
                        anchorKey.currentContext.findRenderObject();
                        var offset = renderBox.localToGlobal(Offset.zero);
                        _onPanDown(details.globalPosition - offset);
                      });
                    },
                    onPanUpdate: (details) {
                      setState(() {
                        RenderBox renderBox =
                        anchorKey.currentContext.findRenderObject();
                        var offset = renderBox.localToGlobal(Offset.zero);
                        _onPanUpdate(details.globalPosition - offset);
                      });
                    },
                    onPanEnd: (details) {
                      setState(() {
                        _onPanEnd();
                        if (!teacherMode) {
                          _verifyResult();
                        }
                      });
                    },
                  )),
            ),
          ),
          Container(
            width: resizeUtil(273),
            height: mainHeight - resizeUtil(478.5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CommonImageButton(
                  buttonType: ButtonType.DELETE,
                  disable: mathCellData.paintOperations.length == 0,
                  onTapDown: () {
                    setState(() {
                      _cleanCellMath();
                    });
                  },
                ),
                CommonImageButton(
                  buttonType: ButtonType.REVOKE,
                  disable: mathCellData.paintOperations.length == 0,
                  pressColor: const Color(0x66C088F5),
                  onTapDown: () {
                    setState(() {
                      _revokeCellMath();
                    });
                  },
                ),
                CommonImageButton(
                  buttonType: ButtonType.TIP,
                  disable: mathCellData.tipLineDisable,
                  onTapDown: () {
                    setState(() {
                      mathCellData.showTipLine(true);
                    });
                  },
                  onTapUp: () {
                    setState(() {
                      mathCellData.showTipLine(false);
                    });
                  },
                  onTapCancel: () {
                    setState(() {
                      mathCellData.showTipLine(false);
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _cleanCellMath() {
    mathCellData.clearData();
  }

  void _revokeCellMath() {
    mathCellData.revokeData();
  }

  void _onPanDown(Offset offset) {
    Offset refer = mathCellData.searchCubeNearestPoint(offset);
    if (refer != null) {
      _lineStart = refer;
      _startOperation = mathCellData.insertFocusPoint(refer);
    }
  }

  void _onPanUpdate(Offset offset) {
    //先找到一个起始点
    if (_lineStart == null) {
      //先查找线段起始点
      Offset start = mathCellData.searchCubeNearestPoint(offset);
      if (start != null) {
        _lineStart = start;
        _startOperation = mathCellData.insertFocusPoint(start);
      }
    } else {
      //临时绘制
      _lineEnd = offset;
      _tempLine = Line(_lineStart, offset);
    }
  }

  void _onPanEnd() {
    if (_lineEnd == null) {
      //单点操作
      if (_startOperation) {
        //单点操作添加了新点
        mathCellData.addPaintOperation(true, 1, 0);
      }
    } else {
      //拖动操作
      //查找线段终点并且不断刷新终点
      Offset end = mathCellData.searchCubeNearestPoint(_lineEnd);
      if (end != null) {
        if (end != _lineStart) {
          Line line = Line(_lineStart, end);

          bool insertSuccess = mathCellData.insertLine(line);
          if (insertSuccess) {
            bool endOperation = mathCellData.insertFocusPoint(end);
            int count = _startOperation ? 1 : 0;
            if (endOperation) {
              count++;
            }
            mathCellData.addPaintOperation(false, count, 0);
          } else {
            if (_startOperation) {
              mathCellData.removeFocusPoint();
            }
          }
        } else {
          //起点终点选了同一点，且起点为新焦点，视为画了一点
          if (_startOperation) {
            mathCellData.addPaintOperation(true, 1, 0);
          }
        }
      } else {
        //未画出完整线段，清除此次新增起点
        if (_startOperation) {
          mathCellData.removeFocusPoint();
          _startOperation = false;
        }
      }
      //重置
      _tempLine = null;
      _lineStart = null;
      _lineEnd = null;
    }
    _startOperation = false;
  }

  //验证是否绘制正确（做题是否正确）
  _verifyResult() {
    if (mathCellData.verifyResult()) {
      onResult(ExerciseDetails<bool>(data: true));
      //进行完成动画的绘制
      _animResult();
    } else {
      printHelper('请继续作答');
    }
  }

  AnimationController controller;

  Animation<double> answerRightPointAnimation;
  Animation<double> answerRightLineAnimation;

  // 答对动画
  _animResult() {
    controller = AnimationController(
        vsync: Overlay.of(context),
        duration: const Duration(milliseconds: 500));
    CurvedAnimation curve =
    CurvedAnimation(parent: controller, curve: Cubic(1, 0.06, 0.97, -0.39));
    answerRightPointAnimation =
        new Tween(begin: resizeUtil(4.5), end: resizeUtil(6.5)).animate(curve);
    answerRightLineAnimation =
        new Tween(begin: resizeUtil(3), end: resizeUtil(6)).animate(curve);

    controller.forward();

    controller.addStatusListener((AnimationStatus state) {
      if (state == AnimationStatus.completed) {
        onFinish(); //答题结束
      }
    });

    controller.addListener(() {
      setState(() {
        //点动画
        mathCellData.answerRightPointRadius = answerRightPointAnimation.value;
        //线动画
        mathCellData.answerRightLinePaint.strokeWidth =
            answerRightLineAnimation.value;
      });
    });
  }

  @override
  void showAnswer(bool isShow) {
    //构造图形没有查看答案
  }
}

class MathCell extends CustomPainter {
  MathCellData mathCellData;

  //临时绘制线
  Line tempLine;

  //临时绘制点
  Offset tempPoint;

  MathCell({@required this.mathCellData, Line tempLine, Offset tempPoint})
      : super() {
    this.tempLine = tempLine;
    this.tempPoint = tempPoint;
  }

  @override
  void paint(Canvas canvas, Size size) {
    _drawBaseCell(canvas);
    _drawExtendLine(canvas);
    _drawOriginLine(canvas);
    _drawLine(canvas);
    _drawTempLine(canvas);
    _drawTipLine(canvas);
    _drawOriginPoints(canvas);
    _drawFocusPoints(canvas);
  }

  @override
  bool shouldRepaint(MathCell oldDelegate) {
    return true;
  }

  void _drawBaseCell(Canvas canvas) {
    for (Line baseLine in mathCellData.baseLineList) {
      canvas.drawLine(baseLine.start, baseLine.end, mathCellData.baseCellPaint);
    }
  }

  void _drawTempLine(Canvas canvas) {
    if (tempLine != null) {
      canvas.drawLine(tempLine.start, tempLine.end, mathCellData.tempLinePaint);
    }
  }

  void _drawTipLine(Canvas canvas) {
    if (mathCellData.tipLine != null) {
      drawDashLine(mathCellData.tipLine.start, mathCellData.tipLine.end,
          resizeUtil(10), resizeUtil(5), mathCellData.extendLinePaint, canvas);
    }
  }

  void _drawExtendLine(Canvas canvas) {
    if (mathCellData.extendLineList != null &&
        mathCellData.extendLineList.length > 0) {
      mathCellData.extendLineList.forEach((extendLine) {
//        printHelper('extendLine:${extendLine.start.dx},${extendLine.start.dy} -- ${extendLine.end.dx},${extendLine.end.dy}');
//        canvas.drawLine(extendLine.start, extendLine.end, mathCellData.extendLinePaint);
        //延长线用虚线来绘制
        drawDashLine(extendLine.start, extendLine.end, resizeUtil(10),
            resizeUtil(5), mathCellData.extendLinePaint, canvas);
      });
    }
  }

  ///绘制题目的起始线
  void _drawOriginLine(Canvas canvas) {
    if (mathCellData.originLineList != null &&
        mathCellData.originLineList.length > 0) {
      for (Line drawLine in mathCellData.originLineList) {
        canvas.drawLine(drawLine.start, drawLine.end, mathCellData.originLinePaint);
      }
    }
  }

  void _drawLine(Canvas canvas) {
    if (mathCellData.drawLineList != null && mathCellData.drawLineList.length > 0) {
      // 普通线
      for (Line drawLine in mathCellData.drawLineList) {
        if (mathCellData.isAnswerRight && isLineInList(drawLine, mathCellData.targetLineList)) {
          //执行结果动画绘制
          canvas.drawLine(drawLine.start, drawLine.end, mathCellData.answerRightLinePaint);
        } else {
          canvas.drawLine(drawLine.start, drawLine.end, mathCellData.linePaint);
        }
      }

      // 合并线
      for (Line combineLine in mathCellData.combineLineList) {
        if (mathCellData.isAnswerRight && isLineInList(combineLine, mathCellData.targetLineList)) {
          //执行结果动画绘制
          canvas.drawLine(combineLine.start, combineLine.end, mathCellData.answerRightLinePaint);
        }
      }
    }
  }

  ///绘制题目的起始点
  void _drawOriginPoints(Canvas canvas) {
    if (mathCellData.originPoints != null &&
        mathCellData.originPoints.length > 0) {
      mathCellData.originPoints.forEach((focusPoint) {
        canvas.drawCircle(focusPoint, mathCellData.originPointRadius,
            mathCellData.originPointPaint);
      });
    }
  }

  void _drawFocusPoints(Canvas canvas) {
    if (mathCellData.focusPoints != null &&
        mathCellData.focusPoints.length > 0) {
      mathCellData.focusPoints.forEach((focusPoint) {
        if (mathCellData.isAnswerRight &&
            pointInList(focusPoint, mathCellData.targetPoints)) {
          //执行结果动画绘制
          canvas.drawCircle(focusPoint, mathCellData.answerRightPointRadius,
              mathCellData.answerRightPointPaint);
        } else {
          canvas.drawCircle(focusPoint, mathCellData.focusPointRadius,
              mathCellData.confirmPointInsidePaint);
          canvas.drawCircle(focusPoint, mathCellData.focusPointRadius,
              mathCellData.confirmPointOutsidePaint);
        }
      });
    }
    if (tempPoint != null) {
      canvas.drawCircle(tempPoint, mathCellData.tempPointRadius,
          mathCellData.tempPointInsidePaint);
      canvas.drawCircle(tempPoint, mathCellData.tempPointRadius,
          mathCellData.tempPointOutsidePaint);
    }
  }
}