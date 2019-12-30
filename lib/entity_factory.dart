import 'package:flutter_exercise/datamodel/exercise/construction_2d_entity.dart';

///数据解析工厂
class EntityFactory {
  static T generateOBJ<T>(json) {
    if (1 == 0) {
      return null;
    } else if (T.toString() == "Construction2DEntity") {
      /// 图形构造数据模型
      return Construction2DEntity.fromJson(json) as T;
    } else {
      return null;
    }
  }
}
