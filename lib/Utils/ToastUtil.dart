import 'package:fluttertoast/fluttertoast.dart';

class ToastUtil {
  void showMsg(
      msg, bgColor, txtColor, fontSize, String length, String gravity) {
    gravity = gravity.toUpperCase();
    length = length.toUpperCase();
    var tgravity, tlength;
    if (gravity == "BOTTOM") {
      tgravity = ToastGravity.BOTTOM;
    } else if (gravity == "TOP") {
      tgravity = ToastGravity.TOP;
    } else {
      tgravity = ToastGravity.CENTER;
    }

    if (length == "SHORT") {
      tlength = Toast.LENGTH_SHORT;
    } else {
      tlength = Toast.LENGTH_LONG;
    }
    Fluttertoast.cancel();
    Fluttertoast.showToast(
        msg: msg,
        toastLength: tlength,
        gravity: tgravity,
        timeInSecForIosWeb: 3,
        backgroundColor: bgColor,
        textColor: txtColor,
        fontSize: fontSize);
  }
}
