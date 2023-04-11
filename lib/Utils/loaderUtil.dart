import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class Loader {
  ProgressDialog pr;
  showValueLoader(String message, context) {
    pr = ProgressDialog(context: context);
    pr.show(
      max: 100,
      msg: message,
      progressValueColor: Colors.white,
      progressBgColor: Colors.black38,
      backgroundColor: Colors.black38,
      msgColor: Colors.white,
    );
  }

  updateValueLoader(
    String message,
    context,
  ) {
    pr.update(msg: message, value: 100);
  }

  hideValueLoader(BuildContext context) {
    pr.close();
  }
}
