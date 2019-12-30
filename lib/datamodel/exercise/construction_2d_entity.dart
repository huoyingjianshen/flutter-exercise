import 'package:flutter_exercise/datamodel/exercise/base_exercise_entity.dart';
import 'package:flutter_exercise/exerciseframework/formulae/exercise_offset.dart';
import 'package:flutter_exercise/exerciseframework/formulae/line.dart';

///构造2D图形-构造正方形的数据模板
class Construction2DEntity extends BaseExerciseEntity<Input, Output> {
  Construction2DEntity();

  Construction2DEntity.fromJson(Map<String, dynamic> json)
      : super.fromJson(json);

  @override
  Input decodeInput(Map<String, dynamic> json) {
    return json != null ? new Input.fromJson(json) : null;
  }

  @override
  Output decodeOutput(Map<String, dynamic> json) {
    return json != null ? new Output.fromJson(json) : null;
  }
}

///输入的题目
class Input extends BaseInputOutputEntity {
  List<ExerciseOffset> focusPoints;
  List<Line> drawLineList;
  String questionDesc;//题目描述

  Input(this.focusPoints, this.drawLineList);

  Input.fromJson(Map<String, dynamic> json) {
    if (json['focusPoints'] != null) {
      focusPoints = new List<ExerciseOffset>();
      (json['focusPoints'] as List).forEach((v) {
        focusPoints.add(new ExerciseOffset.fromJson(v));
      });
    }
    if (json['drawLineList'] != null) {
      drawLineList = new List<Line>();
      (json['drawLineList'] as List).forEach((v) {
        drawLineList.add(new Line.fromJson(v));
      });
    }
    questionDesc = json['questionDesc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.drawLineList != null) {
      data['drawLineList'] = this.drawLineList.map((v) => v.toJson()).toList();
    }
    if (this.focusPoints != null) {
      data['focusPoints'] = this.focusPoints.map((v) => v.toJson()).toList();
    }
    data['questionDesc'] = questionDesc;
    return data;
  }
}

///输入的题目
class Output extends BaseInputOutputEntity {
  List<ExerciseOffset> focusPoints;
  List<Line> drawLineList;

  Output(this.focusPoints, this.drawLineList);

  Output.fromJson(Map<String, dynamic> json) {
    if (json['focusPoints'] != null) {
      focusPoints = new List<ExerciseOffset>();
      (json['focusPoints'] as List).forEach((v) {
        focusPoints.add(new ExerciseOffset.fromJson(v));
      });
    }
    if (json['drawLineList'] != null) {
      drawLineList = new List<Line>();
      (json['drawLineList'] as List).forEach((v) {
        drawLineList.add(new Line.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.drawLineList != null) {
      data['drawLineList'] = this.drawLineList.map((v) => v.toJson()).toList();
    }
    if (this.focusPoints != null) {
      data['focusPoints'] = this.focusPoints.map((v) => v.toJson()).toList();
    }
    return data;
  }
}