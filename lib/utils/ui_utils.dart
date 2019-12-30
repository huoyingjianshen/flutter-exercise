//全局appbar的基础高度
import 'package:flutter/material.dart';
import 'package:flutter_exercise/utils/resize_utils.dart';

const double globalAppbarHeight = 44;

//整个屏幕的绘制宽度
double screenContentWidth = 0;
//整个页面除开刘海以及statusBar之后可以绘制的高度，用来换算并且适配长屏中的布局
double screenContentHeight = 0;
//全面屏的底部安全区域高度(iphone)
double safeAreaBottom = 0;
//全面屏的顶部部安全区域高度(iphone)
double safeAreaTop = 0;


///题板键盘相关值
//键盘区域高度
double exerciseKeyboardHeight = 0;
//键盘顶部间距
double exerciseKeyboardTopMargin = 0;

//计算除开刘海和导航栏之外可以用于绘制的区域大小
void calContentSize(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final padding = MediaQuery.of(context).padding;
  screenContentWidth = size.width;
  screenContentHeight = size.height - resizeUtil(globalAppbarHeight) - padding.top - padding.bottom;
  safeAreaBottom = padding.bottom;
  safeAreaTop = padding.top;
  exerciseKeyboardHeight = safeAreaBottom > 0 ? resizeUtil(162) : resizeUtil(118);
  exerciseKeyboardTopMargin = safeAreaBottom > 0 ? resizeUtil(16) : resizeUtil(3);
}