import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:school_news/beans/LoginEntity.dart';
import 'package:school_news/coustomViews/LoadingDialog.dart';
import 'package:school_news/pages/AddKidPage.dart';
import 'package:school_news/pages/MainPage.dart';
import 'package:school_news/utils/CommonUtils.dart';
import 'package:school_news/utils/Global.dart';
import 'package:school_news/utils/NetworkUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  TextEditingController phoneCtl = TextEditingController();
  TextEditingController passwordCtl = TextEditingController();
  bool isRememberAccount = false;
  bool isShowPassword = false;

  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    animation = Tween(begin: 0.0, end: 0.5).animate(controller);
    initAccount();
  }

  void initAccount(){
    setState(() {
      phoneCtl.text = Global.preferences.get("username");
      passwordCtl.text = Global.preferences.get("password");
      isRememberAccount =
          Global.preferences.getBool("isRememberAccount") ?? false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 450,
            color: Color(Global.colorPrimaryDark),
          ),
          Container(
            margin: EdgeInsets.only(left: 15, top: 70, right: 15, bottom: 0),
            child: Image.asset("images/login_logo.png"),
          ),
          Container(
            margin: EdgeInsets.only(left: 15, top: 230, right: 15, bottom: 0),
            height: 270,
            width: double.infinity,
            child: Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8))),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 33, top: 250, right: 33, bottom: 0),
            padding: EdgeInsets.only(left: 15, top: 0, right: 15, bottom: 0),
            height: 44,
            width: double.infinity,
            color: Color(0xffF8F8FF),
            child: TextField(
              controller: phoneCtl,
              keyboardType: TextInputType.phone,
              cursorColor: Color(Global.colorAccent),
              decoration: InputDecoration(
                hintText: "請輸入手機號碼",
                hintStyle: TextStyle(fontSize: 14, color: Color(0xffA6A2BA)),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent)),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 33, top: 305, right: 33, bottom: 0),
            padding: EdgeInsets.only(left: 15, top: 0, right: 15, bottom: 0),
            height: 44,
            width: double.infinity,
            color: Color(0xffF8F8FF),
            child: TextField(
              controller: passwordCtl,
              obscureText: !isShowPassword,
              keyboardType: TextInputType.visiblePassword,
              cursorColor: Color(Global.colorAccent),
              decoration: InputDecoration(
                suffixIcon: RotationTransition(
                  alignment: Alignment.center,
                  turns: animation,
                  child: Container(
                    width: 44,
                    height: 44,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          isShowPassword = !isShowPassword;
                        });
                        if (isShowPassword)
                          controller.reverse();
                        else
                          controller.forward();
                      },
                      child: Icon(
                        isShowPassword? Icons.visibility : Icons.visibility_off,
                        color: Color(Global.colorPrimaryDark),
                      ),
                    ),
                  ),
                ),
                hintText: "請輸入密碼",
                hintStyle: TextStyle(fontSize: 14, color: Color(0xffA6A2BA)),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent)),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 15, top: 372, right: 33, bottom: 0),
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () {},
              child: Text(
                "忘記密碼?",
                style: TextStyle(color: Color(0xff8874c1), fontSize: 13),
              ),
            ),
          ),
          Container(
              margin: EdgeInsets.only(left: 36, top: 420, right: 33, bottom: 0),
              child: Text("記住密碼?",
                  style: TextStyle(color: Colors.black54, fontSize: 13))),
          Container(
              alignment: Alignment.topRight,
              margin: EdgeInsets.only(left: 35, top: 405, right: 33, bottom: 0),
              child: Switch(
                value: isRememberAccount,
                onChanged: (b) => setState(() => isRememberAccount = b),
              )),
          Container(
            width: double.infinity,
            height: 44,
            margin: EdgeInsets.only(left: 35, top: 470, right: 33, bottom: 0),
            child: RaisedButton(
              onPressed: () {
                doLogin();
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(22))),
              child: Text("登 入",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              color: Color(Global.colorAccent),
            ),
          ),
          Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.only(left: 36, top: 540, right: 33, bottom: 0),
            child: InkWell(
                onTap: () {},
                child: Text("去注冊",
                    style: TextStyle(color: Color(0xff8874c1), fontSize: 14))),
          ),
        ],
      ),
    );
  }

  void doLogin() async {
    if (phoneCtl.text.isEmpty) {
      Fluttertoast.showToast(msg: "请输入完整手机号");
      return;
    }
    if (passwordCtl.text.isEmpty) {
      Fluttertoast.showToast(msg: "请输入密码");
      return;
    }
    String phone = phoneCtl.text;
    if (phone.length == 8)
      phone = "853" + phone;
    else if (phone.length == 11) phone = "86" + phone;
    CommonUtils.showLoadingDialog(context, "正在登錄...");
    NetworkUtil.post("/api/user/token-auth",
        {"username": phone, "password": passwordCtl.text}, false, (respone) {
      print(respone.body);
      Navigator.pop(context);
      LoginEntity loginEntity = LoginEntity.fromJson(
          jsonDecode(Utf8Decoder().convert(respone.bodyBytes)));
      Global.preferences.setString("username", phoneCtl.text);
      Global.preferences.setString("password", passwordCtl.text);
      Global.preferences.setInt("userId", loginEntity.data.userId);
      Global.preferences.setBool("isRememberAccount", isRememberAccount);
      Global.preferences
          .setBool("isTeacher", loginEntity.data.profile == "staff");
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
