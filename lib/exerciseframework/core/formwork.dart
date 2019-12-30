import 'package:flutter/material.dart';
import 'package:flutter_exercise/datamodel/exercise/base_exercise_entity.dart';
import 'package:flutter_exercise/exerciseframework/construction_2d/construction_2d.dart';

///题目模板构造器，客户端解析数据之后，调用对应的模板构造器
///[ExerciseFormWork]进行题目模板的构造,题目模板的具体类型对应[FormWork]中的枚举参数

///提莫模板枚举，有新添加的题目的时候在这里添加枚举
enum FormWork {
  //0构造图形
  CONSTRUCTION_2D,
}

///题目的基础模板构造器，通过传入的[ExerciseFormWorkFactory.formWork]来查找对应的题目模板，
///并通过[ExerciseFormWorkFactory.onExerciseLoading]等接口来进行题目进行的状态回调
class ExerciseFormWork<T extends ExerciseFormWorkFactory>
    extends StatefulWidget {
  //构造器的参数工厂
  final T formWorkFactory;

  ExerciseFormWork({Key key, @required this.formWorkFactory}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    //泛化 泛型 T 中的具体数据，并取出来构造
    ExerciseFormWorkFactory factory = formWorkFactory;
    BaseExerciseEntity entity = factory.exerciseEntity;
    FormWork formWork = FormWork.values[entity.questionType];

    //构造对应的State<ExerciseFormWork>并返回
    switch (formWork) {
      case FormWork.CONSTRUCTION_2D:
        //构造图形
        return Construction2DState();
        break;
    }

    return null;
  }
}

//题目模板的基类，构造器中所需要的State<ExerciseFormWork>均继承自该基础类
abstract class BaseExerciseFormWorkState<T extends ExerciseFormWorkFactory>
    extends State<ExerciseFormWork> {
  //在子类中进行初始化
  @required
  T formWorkFactory;

  @override
  void initState() {
    super.initState();
    formWorkFactory = widget.formWorkFactory;
    if (formWorkFactory != null) {
      ExerciseFormWorkFactory factory = formWorkFactory;
      if (factory.onExerciseLoading != null) {
        factory.onExerciseLoading(ExerciseDetails<String>(data: '渲染中...'));
      }
    }

    //监听渲染完成
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      onReady();
    });

    //绑定显示答案callback
    formWorkFactory?.attachShowAnswerCallBack(showAnswer);
  }

  @override
  void didUpdateWidget(
      ExerciseFormWork<
              ExerciseFormWorkFactory<
                  BaseExerciseEntity<BaseInputOutputEntity,
                      BaseInputOutputEntity>>>
          oldWidget) {
    super.didUpdateWidget(oldWidget);
    //重建Widget之后，可能不会重建State，所以在这里获取新的formWorkFactory
    formWorkFactory = widget.formWorkFactory;
    //绑定显示答案callback
    formWorkFactory?.attachShowAnswerCallBack(showAnswer);
  }

  //展示答案 isShow 是否展示
  void showAnswer(bool isShow);

  //加载完成后的回调
  @mustCallSuper
  void onReady() {
    if (formWorkFactory != null) {
      ExerciseFormWorkFactory factory = formWorkFactory;
      if (factory.onExerciseReady != null) {
        factory.onExerciseReady(ExerciseDetails<String>(data: '渲染完成...'));
      }
    }
  }

  //做题结果
  void onResult(ExerciseDetails details) {
    if (formWorkFactory != null) {
      ExerciseFormWorkFactory factory = formWorkFactory;
      if (factory.onExerciseResult != null) {
        factory.onExerciseResult(details);
      }
    }
  }

  //做题结束
  void onFinish() {
    if (formWorkFactory != null) {
      ExerciseFormWorkFactory factory = formWorkFactory;
      if (factory.onExerciseFinish != null) {
        factory.onExerciseFinish();
      }
    }
  }
}

//数据模板工厂
class ExerciseFormWorkFactory<T extends BaseExerciseEntity> {
  //具体的数据模板
  T exerciseEntity;

  //系统操作回调
  ExerciseLoadingCallback onExerciseLoading;
  ExerciseReadyCallback onExerciseReady;
  ExerciseResultCallback onExerciseResult;
  ExerciseFinishCallback onExerciseFinish;
  Function(bool) onShowAnswer;

  ExerciseFormWorkFactory(
      {@required this.exerciseEntity,
      this.onExerciseLoading,
      this.onExerciseReady,
      this.onExerciseResult,
      this.onExerciseFinish})
      : super();

  void attachShowAnswerCallBack(Function(bool) call) {
    onShowAnswer = call;
  }

  //显示答案
  void showAnswer(bool isShow) {
    if (onShowAnswer != null) {
      onShowAnswer(isShow);
    }
  }
}

//构造对应的返回类型
class ExerciseDetails<T> {
  ExerciseDetails({this.data}) : super();

  final T data;
}

typedef ExerciseLoadingCallback = void Function(ExerciseDetails details);
typedef ExerciseReadyCallback = void Function(ExerciseDetails details);
typedef ExerciseResultCallback = void Function(ExerciseDetails details);
typedef ExerciseFinishCallback = void Function();
