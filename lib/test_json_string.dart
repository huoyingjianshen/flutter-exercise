String construction2DData = "{\n" +
    "\t\"questionName\": \"2x2正方形\",\n" +
    "\t\"questionId\": \"123123\",\n" +
    "\t\"questionType\": 0,\n" +
    "\t\"input\": {\n" +
    "\t\t\"drawLineList\": [{\n" +
    "\t\t\t\"start\": {\n" +
    "\t\t\t\t\"dx\": 108.0,\n" +
    "\t\t\t\t\"dy\": 216.0\n" +
    "\t\t\t},\n" +
    "\t\t\t\"end\": {\n" +
    "\t\t\t\t\"dx\": 216.0,\n" +
    "\t\t\t\t\"dy\": 216.0\n" +
    "\t\t\t}\n" +
    "\t\t}],\n" +
    "\t\t\"focusPoints\": [{\n" +
    "\t\t\t\"dx\": 108.0,\n" +
    "\t\t\t\"dy\": 108.0\n" +
    "\t\t}, {\n" +
    "\t\t\t\"dx\": 108.0,\n" +
    "\t\t\t\"dy\": 216.0\n" +
    "\t\t}, {\n" +
    "\t\t\t\"dx\": 216.0,\n" +
    "\t\t\t\"dy\": 216.0\n" +
    "\t\t}]\n" +
    "\t},\n" +
    "\t\"output\": {\n" +
    "\t\t\"drawLineList\": [{\n" +
    "\t\t\t\"start\": {\n" +
    "\t\t\t\t\"dx\": 108.0,\n" +
    "\t\t\t\t\"dy\": 216.0\n" +
    "\t\t\t},\n" +
    "\t\t\t\"end\": {\n" +
    "\t\t\t\t\"dx\": 216.0,\n" +
    "\t\t\t\t\"dy\": 216.0\n" +
    "\t\t\t}\n" +
    "\t\t}, {\n" +
    "\t\t\t\"start\": {\n" +
    "\t\t\t\t\"dx\": 108.0,\n" +
    "\t\t\t\t\"dy\": 108.0\n" +
    "\t\t\t},\n" +
    "\t\t\t\"end\": {\n" +
    "\t\t\t\t\"dx\": 108.0,\n" +
    "\t\t\t\t\"dy\": 216.0\n" +
    "\t\t\t}\n" +
    "\t\t}, {\n" +
    "\t\t\t\"start\": {\n" +
    "\t\t\t\t\"dx\": 108.0,\n" +
    "\t\t\t\t\"dy\": 108.0\n" +
    "\t\t\t},\n" +
    "\t\t\t\"end\": {\n" +
    "\t\t\t\t\"dx\": 216.0,\n" +
    "\t\t\t\t\"dy\": 108.0\n" +
    "\t\t\t}\n" +
    "\t\t}, {\n" +
    "\t\t\t\"start\": {\n" +
    "\t\t\t\t\"dx\": 216.0,\n" +
    "\t\t\t\t\"dy\": 108.0\n" +
    "\t\t\t},\n" +
    "\t\t\t\"end\": {\n" +
    "\t\t\t\t\"dx\": 216.0,\n" +
    "\t\t\t\t\"dy\": 216.0\n" +
    "\t\t\t}\n" +
    "\t\t}],\n" +
    "\t\t\"focusPoints\": [{\n" +
    "\t\t\t\"dx\": 108.0,\n" +
    "\t\t\t\"dy\": 108.0\n" +
    "\t\t}, {\n" +
    "\t\t\t\"dx\": 108.0,\n" +
    "\t\t\t\"dy\": 216.0\n" +
    "\t\t}, {\n" +
    "\t\t\t\"dx\": 216.0,\n" +
    "\t\t\t\"dy\": 216.0\n" +
    "\t\t}, {\n" +
    "\t\t\t\"dx\": 216.0,\n" +
    "\t\t\t\"dy\": 108.0\n" +
    "\t\t}]\n" +
    "\t}\n" +
    "}";
String measure2DData =
    "{\"questionName\":\"长度测量\",\"version\":null,\"questionId\":\"\",\"questionType\":2,\"input\":{\"imageUrl\":\"_Q_CTT_:13DF2F3772BD42939C53D26EF46A6FF9\",\"imageWidth\":150.0,\"imageHeight\":100.0,\"subject\":\"测量图形并计算出周长|该图形的周长为\",\"unit\":\"厘米\"},\"output\":{\"answer\":\"20\"}}";

String AreaDataString =
    "{\"questionName\":\"等积变换\",\"questionId\":\"123\",\"questionType\":1,\"input\":{\"triangleList\":[{\"pointA\":{\"dx\":0.0,\"dy\":0.0},\"pointB\":{\"dx\":0.0,\"dy\":1.0},\"pointC\":{\"dx\":2.0,\"dy\":1.0},\"area\":0.0},{\"pointA\":{\"dx\":0.0,\"dy\":1.0},\"pointB\":{\"dx\":2.0,\"dy\":1.0},\"pointC\":{\"dx\":2.0,\"dy\":2.0},\"area\":20971.520000000004},{\"pointA\":{\"dx\":2.0,\"dy\":1.0},\"pointB\":{\"dx\":2.0,\"dy\":2.0},\"pointC\":{\"dx\":4.0,\"dy\":2.0},\"area\":20971.520000000004},{\"pointA\":{\"dx\":2.0,\"dy\":2.0},\"pointB\":{\"dx\":4.0,\"dy\":2.0},\"pointC\":{\"dx\":4.0,\"dy\":2.9999999999999996},\"area\":20971.51999999999}],\"area\":4}}";

//神奇计算器
String CalculatorDataString =
    "{\"questionName\":\"神奇计算器\",\"questionType\":10,\"input\":{\"level\":0,\"desc\":\"333\"}}";
//纸牌游戏
String CardGameString = "{\"questionName\":\"纸牌游戏\",\"questionType\":3,\"input\":{\"desc\":\"把时间相同的两张牌消一消！\"}}";
//数阵图
String NumberFormationString = "{\"questionName\":\"数阵图\",\"questionType\":12,\"input\":{\"type\":0,\"numList\":[2.0,3.0,4.0,1.0,5.0],\"desc\":\"测试\",\"answer\":0.0,\"answerList\":[1,2,3,4,5]}}";
//面积&周长
String CircumferenceAreaString = "{\"questionName\":\"面积&周长\",\"questionType\":16,\"input\":{\"column\":8,\"row\":11,\"orderList\":[4,8,6,10,9,12],\"initialSizeList\":[1,1,2,2,2,1],\"tipList\":[0,0,2,2,5,0,2,3,1,7,3,3]}}";
//金字塔
String NumPyramidString =
    "{\"questionName\":\"金字塔\",\"questionType\":17,\"input\":{\"level\":0,\"desc\":\"填充金字塔数字，两数之和等于上一层\",\"rule\":\"金字塔做题规则详细解释\"}}";
//对称图形
String symmetricShapeString = "{\"questionName\":\"对称图形\",\"questionType\":18,\"input\":{\"originPointList\":[{\"dx\":50.0,\"dy\":100.0},{\"dx\":200.0,\"dy\":0.0},{\"dx\":200.0,\"dy\":100.0}],\"originLineList\":[{\"start\":{\"dx\":50.0,\"dy\":100.0},\"end\":{\"dx\":200.0,\"dy\":0.0}},{\"start\":{\"dx\":200.0,\"dy\":0.0},\"end\":{\"dx\":200.0,\"dy\":100.0}},{\"start\":{\"dx\":50.0,\"dy\":100.0},\"end\":{\"dx\":200.0,\"dy\":100.0}}],\"symmetryAxis\":{\"start\":{\"dx\":0.0,\"dy\":150.0},\"end\":{\"dx\":300.0,\"dy\":150.0}}}}";
//对称拓展
String symmetricExpandString = "{\"questionName\":\"对称扩展\",\"questionType\":19,\"input\":{\"originPointList\":[{\"dx\":100.0,\"dy\":0.0},{\"dx\":50.0,\"dy\":100.0},{\"dx\":250.0,\"dy\":100.0}],\"originLineList\":[{\"start\":{\"dx\":100.0,\"dy\":0.0},\"end\":{\"dx\":50.0,\"dy\":100.0}},{\"start\":{\"dx\":100.0,\"dy\":0.0},\"end\":{\"dx\":250.0,\"dy\":100.0}},{\"start\":{\"dx\":50.0,\"dy\":100.0},\"end\":{\"dx\":250.0,\"dy\":100.0}}],\"symmetricPointList\":[{\"dx\":50.0,\"dy\":200.0},{\"dx\":100.0,\"dy\":300.0},{\"dx\":250.0,\"dy\":200.0}],\"symmetricLineList\":[{\"start\":{\"dx\":50.0,\"dy\":200.0},\"end\":{\"dx\":100.0,\"dy\":300.0}},{\"start\":{\"dx\":50.0,\"dy\":200.0},\"end\":{\"dx\":250.0,\"dy\":200.0}},{\"start\":{\"dx\":250.0,\"dy\":200.0},\"end\":{\"dx\":100.0,\"dy\":300.0}}]}}";
//容斥原理应用
String ToleranceExclusionString =
    "{\"questionName\":\"容斥原理应用\",\"questionType\":27,\"input\":{\"questionContent\":\"班级里参加语文竞赛的同学有13人，参加数学竞赛的有14人，参加竞赛的同学一共有23人。\",\"question\":\"两项都参加的有几人？\",\"leftString\":\"参加语文竞赛的同学\",\"rightString\":\"参加数学竞赛的同学\",\"answer\":\"4\"}}";

String AdditionNumVerticalPuzzleDataString =
    "{\"questionName\":\"加法竖式谜\",\"questionType\":6,\"input\":{\"diff\":0}}";
String SubtractioNumVerticalPuzzleDataString =
    "{\"questionName\":\"减法竖式谜\",\"questionType\":7,\"input\":{\"diff\":0}}";
String MultiplicationNumVerticalPuzzleDataString =
    "{\"questionName\":\"乘法竖式谜\",\"questionType\":8,\"input\":{\"diff\":0}}";

String RecognizeFractionDataString =
    "{\"questionName\":\"认识分数\",\"questionType\":10,\"input\":{\"ices\":[[0,0,0,0,0,0],[0,1,1,1,0,0],[0,1,1,1,0,0],[0,1,1,1,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0]], \"molecule\": 1, \"denominator\": 3}}";
String FractionReplenishDataString =
    "{\"questionName\":\"根据分数补充图形\",\"questionType\":12,\"input\":{\"ices\":[[0,0,0,0,0,0],[0,1,1,1,0,0],[0,1,1,1,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0]], \"molecule\": 1, \"denominator\": 2, \"isSquer\": false}}";
//凯撒
String caesarTestData =
    "{\"questionName\":\"凯撒密码\",\"questionType\":5,\"input\":{\"offset\":2,\"desc\":\"快来拨动密码盘，找出正确的加密方式。\",\"cleartext\":\"good good\"}}";

String FoldBoardDataString = 
    "{\"questionName\":\"折叠板\",\"questionType\":14,\"input\":{\"cellRow\": 2, \"cellColumn\": 2, \"cells\":[[2,0],[2,0]], \"analysisDatas\":[{\"i\":0, \"j\":0, \"direction\":3}]}";

String elementaryArithmeticDataString = "{\"questionName\":\"竖式计算-加减法\",\"questionType\":21,\"input\":{\"arithmeticType\":0,\"arithmeticDegree\":0}}";

String decimalSimpleCalculateDataString = "{\"questionName\":\"小数的简单的计算-难度1\",\"questionType\":14,\"input\":{\"diff\":0}}";

String maxArea = "{\"questionName\":\"面积最大化-难度1\",\"questionType\":20,\"input\":{\"diff\":0}}";

//测试数据
String testQuestionData = '';
