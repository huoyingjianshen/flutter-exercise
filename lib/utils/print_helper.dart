//if the content is too long to printHelper in the console,
// please use printHelper to printHelper what you want

import 'package:flutter_exercise/utils/global_build_enviroment.dart';

void printHelper(Object object) {
  if (!globalBuildRelease) {
    String msg = "$object";
    int segmentSize = 600;
    int length = msg.length;

    if (length <= segmentSize) {
      print(msg);
    } else {
      while (msg.length > segmentSize) {
        String logContent = msg.substring(0, segmentSize);
        msg = msg.replaceAll(logContent, "");
        print(logContent);
      }
      print(msg);
    }
  }

}
