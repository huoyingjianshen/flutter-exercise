import 'dart:ui';

///自定义可以构造json解析的offset
class ExerciseOffset extends Offset {
  ExerciseOffset(double dx, double dy) : super(dx, dy);

  ExerciseOffset.fromJson(Map<String, dynamic> json)
      : super(json['dx'], json['dy']);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dx'] = this.dx;
    data['dy'] = this.dy;
    return data;
  }
}
