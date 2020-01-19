import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_news/coustomViews/LoadingDialog.dart';

class CommonUtils {
  static void showLoadingDialog(BuildContext context, String text) {
    showDialog(context: context, builder: (context) => LoadingDialog(text));
  }
}
