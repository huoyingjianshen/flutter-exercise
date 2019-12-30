import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_exercise/utils/resize_utils.dart';

///键盘风格
enum ExerciseKeyboardStyle {
  yellow, //金字塔
  lightYellow, //竖式计算
  blue, //容斥原理应用
  lightBlue, //测量
}

///键盘状态
enum ExerciseKeyboardState { normal, selected }

///键盘类型
enum ExerciseKeyboardType { num, delete, point }

typedef KeyboardCallback = void Function(ExerciseKeyboardData keyboardData);

class CommonExerciseKeyboard extends StatefulWidget {
  final ExerciseKeyboardStyle style;
  final KeyboardCallback onPressed;
  final bool isDisable;

  CommonExerciseKeyboard({
    this.isDisable = false,
    this.style,
    this.onPressed
  });

  @override
  _CommonExerciseKeyboardState createState() => _CommonExerciseKeyboardState();
}

class _CommonExerciseKeyboardState extends State<CommonExerciseKeyboard> {
  //键盘数据
  List<ExerciseKeyboardData> _keyboardList;

  //字体颜色
  Map<ExerciseKeyboardStyle, Map<ExerciseKeyboardType, Color>> _textColor = {
    ExerciseKeyboardStyle.yellow: {
      ExerciseKeyboardType.num: Color.fromRGBO(75, 34, 12, 1),
      ExerciseKeyboardType.point: Color.fromRGBO(75, 34, 12, 1),
      ExerciseKeyboardType.delete: Color.fromRGBO(255, 242, 226, 1),
    },
    ExerciseKeyboardStyle.blue: {
      ExerciseKeyboardType.num: Color.fromRGBO(89, 115, 169, 1),
      ExerciseKeyboardType.point: Color.fromRGBO(89, 115, 169, 1),
      ExerciseKeyboardType.delete: Color.fromRGBO(255, 242, 226, 1),
    },
    ExerciseKeyboardStyle.lightYellow: {
      ExerciseKeyboardType.num: Color.fromRGBO(143, 103, 63, 1),
      ExerciseKeyboardType.point: Color.fromRGBO(143, 103, 63, 1),
      ExerciseKeyboardType.delete: Color.fromRGBO(255, 242, 226, 1),
    },
    ExerciseKeyboardStyle.lightBlue: {
      ExerciseKeyboardType.num: Color.fromRGBO(91, 190, 255, 1),
      ExerciseKeyboardType.point: Color.fromRGBO(91, 190, 255, 1),
      ExerciseKeyboardType.delete: Color.fromRGBO(255, 242, 226, 1),
    },
  };

  //键盘颜色
  Map<ExerciseKeyboardStyle, Map<ExerciseKeyboardType, Map<ExerciseKeyboardState, Color>>>
      _colorMap = {
    //容斥原理应用
    ExerciseKeyboardStyle.blue: {
      ExerciseKeyboardType.num: {
        ExerciseKeyboardState.normal: Color.fromRGBO(243, 250, 255, 1),
        ExerciseKeyboardState.selected: Color.fromRGBO(109, 216, 255, 0.4)
      },
      ExerciseKeyboardType.point: {
        ExerciseKeyboardState.normal: Color.fromRGBO(243, 250, 255, 1),
        ExerciseKeyboardState.selected: Color.fromRGBO(195, 236, 255, 0.4)
      },
      ExerciseKeyboardType.delete: {
        ExerciseKeyboardState.normal: Color.fromRGBO(255, 161, 71, 1),
        ExerciseKeyboardState.selected: Color.fromRGBO(255, 118, 4, 0.4)
      },
    },
    //金字塔
    ExerciseKeyboardStyle.yellow: {
      ExerciseKeyboardType.num: {
        ExerciseKeyboardState.normal: Color.fromRGBO(255, 208, 128, 1),
        ExerciseKeyboardState.selected: Color.fromRGBO(255, 127, 0, 0.4)
      },
      ExerciseKeyboardType.point: {
        ExerciseKeyboardState.normal: Color.fromRGBO(255, 208, 128, 1),
        ExerciseKeyboardState.selected: Color.fromRGBO(255, 127, 0, 0.6)
      },
      ExerciseKeyboardType.delete: {
        ExerciseKeyboardState.normal: Color.fromRGBO(242, 138, 38, 1),
        ExerciseKeyboardState.selected: Color.fromRGBO(255, 92, 0, 0.4)
      },
    },
    //竖式计算
    ExerciseKeyboardStyle.lightYellow: {
      ExerciseKeyboardType.num: {
        ExerciseKeyboardState.normal: Color.fromRGBO(255, 247, 224, 1),
        ExerciseKeyboardState.selected: Color.fromRGBO(255, 187, 68, 0.4)
      },
      ExerciseKeyboardType.point: {
        ExerciseKeyboardState.normal: Color.fromRGBO(255, 247, 224, 1),
        ExerciseKeyboardState.selected: Color.fromRGBO(255, 187, 68, 0.4)
      },
      ExerciseKeyboardType.delete: {
        ExerciseKeyboardState.normal: Color.fromRGBO(255, 177, 25, 1),
        ExerciseKeyboardState.selected: Color.fromRGBO(255, 118, 4, 0.4)
      },
    },
    //测量
    ExerciseKeyboardStyle.lightBlue: {
      ExerciseKeyboardType.num: {
        ExerciseKeyboardState.normal: Color.fromRGBO(243, 250, 255, 1),
        ExerciseKeyboardState.selected: Color.fromRGBO(109, 216, 255, 0.4)
      },
      ExerciseKeyboardType.point: {
        ExerciseKeyboardState.normal: Color.fromRGBO(243, 250, 255, 1),
        ExerciseKeyboardState.selected: Color.fromRGBO(195, 236, 255, 0.4)
      },
      ExerciseKeyboardType.delete: {
        ExerciseKeyboardState.normal: Color.fromRGBO(255, 161, 71, 1),
        ExerciseKeyboardState.selected: Color.fromRGBO(255, 118, 4, 0.4)
      },
    },
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _generateKeyboardData();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      width: resizeUtil(342),
      height: resizeUtil(112),
      alignment: Alignment.center,
      child: GridView.count(
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 6,
          childAspectRatio: 1,
          crossAxisSpacing: resizeUtil(3),
          mainAxisSpacing: resizeUtil(3),
          children: _keyboardList
              .map((keyboardData) => GestureDetector(
                    child: Container(
                      alignment: Alignment.center,
                      foregroundDecoration: BoxDecoration(
                        color: _keyboardColor(keyboardData, true),
                        borderRadius: BorderRadius.circular(resizeUtil(5)),
                      ),
                      decoration: BoxDecoration(
                        color: _keyboardColor(keyboardData, false),
                        borderRadius: BorderRadius.circular(resizeUtil(5)),
                      ),
                      child: Text(
                        keyboardData.displayString,
                        style: TextStyle(
                            color: _keyboardTextColor(keyboardData),
                            fontSize: keyboardData.fontSize,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    onTapDown: (TapDownDetails details) {
                      setState(() {
                        if (!widget.isDisable) {
                          keyboardData.state = ExerciseKeyboardState.selected;
                          widget.onPressed(keyboardData);
                        }
                      });
                    },
                    onTapUp: (TapUpDetails details) {
                      setState(() {
                        if (keyboardData.state ==
                            ExerciseKeyboardState.selected) {
                          keyboardData.state = ExerciseKeyboardState.normal;
                        }
                      });
                    },
                    onTapCancel: () {
                      setState(() {
                        if (keyboardData.state ==
                            ExerciseKeyboardState.selected) {
                          keyboardData.state = ExerciseKeyboardState.normal;
                        }
                      });
                    },
                  ))
              .toList()),
    );
  }

  void _generateKeyboardData() {
    _keyboardList = [];
    for (int i = 0; i < 12; i++) {
      ExerciseKeyboardData data;
      if (i == 5) {
        data = ExerciseKeyboardData(
            num: 0, displayString: '删除', type: ExerciseKeyboardType.delete);
      } else if (i == 11) {
        data = ExerciseKeyboardData(
            num: 0, displayString: '.', type: ExerciseKeyboardType.point);
      } else if (i < 5) {
        data = ExerciseKeyboardData(
            num: i + 1,
            displayString: (i + 1).toString(),
            type: ExerciseKeyboardType.num);
      } else {
        data = ExerciseKeyboardData(
            num: i % 10,
            displayString: (i % 10).toString(),
            type: ExerciseKeyboardType.num);
      }
      _keyboardList.add(data);
    }
  }

  Color _keyboardColor(ExerciseKeyboardData data, bool isCover) {
    if (isCover) {
      return data.state == ExerciseKeyboardState.selected ?  _colorMap[widget.style][data.type][ExerciseKeyboardState.selected] : null;
    } else {
      return _colorMap[widget.style][data.type][ExerciseKeyboardState.normal];
    }

  }

  Color _keyboardTextColor(ExerciseKeyboardData data) {
    return _textColor[widget.style][data.type];
  }
}

class ExerciseKeyboardData {
  int num;
  String displayString;
  ExerciseKeyboardState state = ExerciseKeyboardState.normal;
  ExerciseKeyboardType type;
  double fontSize = resizePadTextSize(35);

  ExerciseKeyboardData({this.num, this.displayString, this.type}) : super() {
    if (type == ExerciseKeyboardType.delete) {
      fontSize = resizePadTextSize(24);
    }
  }
}
