import 'dart:convert' as convert;

///基础的练习数据类型，各个题型的数据模板均继承于该类，确保题目模板基础类别的统一
///基础类中只保存[questionName]、[id]、[questionType] 等基础数据类型，其他的类型到子类中进行扩展.
///server端数据存储结构采用关系型数据对教师端接口生成的题目数据进行存储
///IN 答题数据
///OUT 答案数据
abstract class BaseExerciseEntity<I extends BaseInputOutputEntity, O extends BaseInputOutputEntity> {
  //题目的名称
  String questionName;

  //题目id
  String questionId;

  //题目类型参考formwork.dart中的[FormWork]
  int questionType;

  //是否显示查看答案
  bool showAnswer = false;

  //题目初始态
  I input;

  //题目答案
  O output;

  //版本
  int version;

  BaseExerciseEntity({this.questionName, this.questionId, this.questionType});

  BaseExerciseEntity.fromJson(Map<String, dynamic> json) {
    if(json['props'] != null) {
      var props = convert.json.decode(json['props']);
      if (props is Map) {
        showAnswer = props['showAnswer'] ?? false;
      }
    }
    questionName = json['questionName'] == null ? '' : json['questionName'];
    questionId = json['questionId'];
    questionType = json['questionType'];
    version = json['version'];
    input = json['input'] != null ? decodeInput(json['input']) : null;
    output = json['output'] != null ? decodeOutput(json['output']) : null;
  }

  I decodeInput(Map<String, dynamic> json);

  O decodeOutput(Map<String, dynamic> json);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['questionName'] = this.questionName;
    data['questionType'] = this.questionType;
    if (this.input != null) {
      data['input'] = this.input.toJson();
    }
    if (this.output != null) {
      data['output'] = this.output.toJson();
    }
    return data;
  }
}

//基本的input output数据
abstract class BaseInputOutputEntity {
  BaseInputOutputEntity();

  Map<String, dynamic> toJson();
}
