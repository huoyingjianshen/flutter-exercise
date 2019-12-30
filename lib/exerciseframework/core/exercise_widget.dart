import 'package:flutter/material.dart';
import 'package:flutter_exercise/datamodel/exercise/base_exercise_entity.dart';
import 'package:flutter_exercise/utils/print_helper.dart';

import 'formwork.dart';

typedef IndexExerciseLoadingCallback = void Function(
    int index, ExerciseDetails details);
typedef IndexExerciseReadyCallback = void Function(
    int index, ExerciseDetails details);
typedef IndexExerciseResultCallback = void Function(
    int index, ExerciseDetails details);
typedef IndexExerciseFinishCallback = void Function(int index);

class ExerciseView<T extends BaseExerciseEntity> extends StatefulWidget {
  final IndexExerciseLoadingCallback onExerciseLoading;
  final IndexExerciseReadyCallback onExerciseReady;
  final IndexExerciseResultCallback onExerciseResult;
  final IndexExerciseFinishCallback onExerciseFinish;
  final List<T> exerciseEntityList;
  final ExerciseViewController controller;

  ExerciseView.builder({
    Key key,
    @required this.exerciseEntityList,
    @required this.controller,
    this.onExerciseLoading,
    this.onExerciseReady,
    this.onExerciseResult,
    this.onExerciseFinish,
  }) : super(key: key) {
    {
      if (controller != null) {
        controller.itemCount = exerciseEntityList?.length ?? 0;
      }
    }
  }

  @override
  _ExerciseViewState createState() {
    return _ExerciseViewState();
  }
}

class _ExerciseViewState extends State<ExerciseView> {
  int _index = 0;
  Key key;
  ExerciseFormWorkFactory exerciseFactory;

  @override
  void initState() {
    if (widget.controller != null) {
      _index = widget.controller.index;
      widget.controller.attachCallBack(
        (index) {
          setState(() {
            printHelper('显示第$index个');
            _index = index;
          });
        },
        (isShow) {
          //是否显示答案
          exerciseFactory?.showAnswer(isShow);
        },
      );
    }
    super.initState();
  }

  @override
  void dispose() {
    if (widget.controller != null) {
      widget.controller.attachCallBack(null, null);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //构造不同的数据模板
    exerciseFactory = ExerciseFormWorkFactory(
      exerciseEntity: widget.exerciseEntityList[_index],
      onExerciseLoading: loadingCallBack,
      onExerciseReady: readyCallBack,
      onExerciseResult: resultCallBack,
      onExerciseFinish: finishCallBack,
    );

    return ExerciseFormWork(
      //题目数据的hashCode + flag  KEY
      key: ValueKey(widget.exerciseEntityList[_index].hashCode +
          (widget.controller?.flag ?? 0)),
      formWorkFactory: exerciseFactory,
    );
  }

  void loadingCallBack(ExerciseDetails details) {
    if (widget.onExerciseLoading != null)
      widget.onExerciseLoading(_index, details);
  }

  void readyCallBack(ExerciseDetails details) {
    if (widget.onExerciseReady != null) widget.onExerciseReady(_index, details);
  }

  void resultCallBack(ExerciseDetails details) {
    if (widget.onExerciseResult != null)
      widget.onExerciseResult(_index, details);
  }

  void finishCallBack() {
    if (widget.onExerciseFinish != null) widget.onExerciseFinish(_index);
  }
}

typedef VoidCallBack = void Function(int index);
typedef BoolCallBack = void Function(bool b);

class ExerciseViewController {
  int _flag = 0; //刷新标识
  int itemCount;
  int index;
  VoidCallBack _callBack;

  //展示答案callback
  BoolCallBack _showAnswerCallBack;

  int get flag => _flag;

  bool get hasNext => index < itemCount - 1;

  bool get hasPrev => index > 0;

  ExerciseViewController({this.index = 0});

  attachCallBack(VoidCallBack callBack, BoolCallBack showAnswerCallBack) {
    this._callBack = callBack;
    this._showAnswerCallBack = showAnswerCallBack;
  }

  next() {
    if (hasNext) {
      index++;
      jumpToIndex(index);
    }
  }

  prev() {
    if (hasPrev) {
      index--;
      jumpToIndex(index);
    }
  }

  jumpToIndex(int index) {
    this.index = index;
    _flag++;
    if (_callBack != null) {
      _callBack(index);
    }
  }

  //展示答案
  showAnswer(bool isShow) {
    if (_showAnswerCallBack != null) _showAnswerCallBack(isShow);
  }
}
