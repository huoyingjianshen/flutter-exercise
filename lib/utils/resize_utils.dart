//目前适配iPhone和iPad机型尺寸
import 'dart:io';
import 'dart:ui';
import 'dart:math';

bool initScale = false;
//针对ios平台的scale系数
double iosScaleRatio = 0;
//针对android平台的scale系数
// （因为所有设计稿均使用ios的设计稿进行，所以需要转换为android设计稿上的尺寸，
// 否则无法进行小屏幕上的适配）
double androidScaleRatio = 0;
//文字缩放比
double textScaleRatio = 0;

const double baseIosWidth = 375;
const double baseIosHeight = 667;
const double baseIosHeightX = 812;

const double baseAndroidWidth = 360;
const double baseAndroidHeight = 640;

void _calResizeRatio() {
//  if (Platform.isIOS) {
//    final width = window.physicalSize.width;
//    final height = window.physicalSize.height;
//    final ratio = window.devicePixelRatio;
//    final widthScale = (width / ratio) / baseIosWidth;
//    final heightScale = (height / ratio) / baseIosHeight;
//    iosScaleRatio = min(widthScale, heightScale);
//  } else if (Platform.isAndroid) {
//    double widthScale = (baseAndroidWidth / baseIosWidth);
//    double heightScale = (baseAndroidHeight / baseIosHeight);
//    double scaleRatio = min(widthScale, heightScale);
//    //取两位小数
//    androidScaleRatio = double.parse(scaleRatio.toString().substring(0, 4));
//  }
}

bool isFullScreen() {
  return false;
}

//缩放
double resizeUtil(double value) {
  if (!initScale) {
    _calResizeRatio();
    initScale = true;
  }

  return value;

//  if (Platform.isIOS) {
//    return value * iosScaleRatio;
//  } else if (Platform.isAndroid) {
//    return value * androidScaleRatio;
//  } else {
//    return value;
//  }
}

//缩放还原
//每个屏幕的缩放比不一样，如果在ios设备上出题，则题目坐标值需要换算成原始坐标，加载的时候再通过不同平台换算回来
double unResizeUtil(double value) {
  if (iosScaleRatio == 0) {
    _calResizeRatio();
  }

  if (Platform.isIOS) {
    return value / iosScaleRatio;
  } else {
    return value;
  }
}

//文字缩放大小
_calResizeTextRatio() {
  final width = window.physicalSize.width;
  final height = window.physicalSize.height;
  final ratio = window.devicePixelRatio;
  double heightRatio = (height / ratio) / baseIosHeight / window.textScaleFactor;
  double widthRatio = (width / ratio) / baseIosWidth / window.textScaleFactor;
  textScaleRatio = min(heightRatio, widthRatio);
}

double resizeTextSize(double value) {
  if (textScaleRatio == 0) {
    _calResizeTextRatio();
  }
  return value * textScaleRatio;
}

double resizePadTextSize(double value) {
  return value;
//  if (Platform.isIOS) {
//    final width = window.physicalSize.width;
//    final ratio = window.devicePixelRatio;
//    final realWidth = width / ratio;
//    if (realWidth > 450) {
//      return value * 1.5;
//    } else {
//      return value;
//    }
//  } else {
//    return value;
//  }
}

double autoSize(double percent, bool isHeight) {
  final width = window.physicalSize.width;
  final height = window.physicalSize.height;
  final ratio = window.devicePixelRatio;
  if (isHeight) {
    return height / ratio * percent;
  } else {
    return width / ratio * percent;
  }
}
