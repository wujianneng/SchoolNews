import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:school_news/beans/LoginEntity.dart';
import 'package:school_news/pages/AddKidPage.dart';
import 'package:school_news/pages/LoginPage.dart';
import 'package:school_news/pages/MainPage.dart';
import 'package:school_news/utils/Global.dart';
import 'package:school_news/utils/NetworkUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    goOtherPage();
  }

  void goOtherPage() async {
    Global.preferences = await SharedPreferences.getInstance();
    bool logined =  Global.preferences.getBool("logined");
    if(logined == null)
      logined = false;
    if (logined)
      autoLogin();
    else
      Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (context) => LoginPage()),
              (route) => route == null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Image.asset("images/splash.png",width: 300,height: 500,fit: BoxFit.fill),
        ),
      ),
    );
  }

  void autoLogin() {
    String phone = Global.preferences.get("username");
    if (phone.length == 8)
      phone = "853" + phone;
    else if (phone.length == 11) phone = "86" + phone;

    NetworkUtil.post("/api/user/token-auth",
        {"username": phone, "password": Global.preferences.get("password")}, false, (respone) {
          print(respone.body);
          Navigator.pop(context);
          LoginEntity loginEntity = LoginEntity.fromJson(
              jsonDecode(Utf8Decoder().convert(respone.bodyBytes)));
          Global.API_TOKEN = "Token " + loginEntity.data.token;
          if (loginEntity.data.profile == "staff") {
            print("MainPage");
            Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(builder: (context) => MainPage()),
                    (rount) => rount == null);
          } else {
            if (!loginEntity.data.students) {
              print("AddKidPage");
              Navigator.pushAndRemoveUntil(
                  context,
                  CupertinoPageRoute(builder: (context) => AddKidPage()),
                      (rount) => rount == null);
            } else {
              print("MainPage");
              Navigator.pushAndRemoveUntil(
                  context,
                  CupertinoPageRoute(builder: (context) => MainPage()),
                      (rount) => rount == null);
            }
          }
        }, (erro) {
          print(erro);
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "登錄失敗");
        });
  }
}
