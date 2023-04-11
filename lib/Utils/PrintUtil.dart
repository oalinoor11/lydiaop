import 'package:flutter_app/Resources/Constant.dart';

class PrintUtil {
  /* Common Print Method */
  void printMsg(msg) {
    if (Constant.buildType != 1) {
      printWrapped(msg.toString());
    }
  }

  /* To Print Larger Response */
  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }
}
