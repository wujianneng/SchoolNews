import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:school_news/coustomViews/LoadingDialog.dart';
import 'package:school_news/utils/Global.dart';
import 'package:school_news/utils/NetworkUtil.dart';

class EditPhonePage extends StatefulWidget {
  @override
  _EditPhonePageState createState() => _EditPhonePageState();
}

class _EditPhonePageState extends State<EditPhonePage> {
  bool canGetAuthCode = true;
  int countdownTime = 60;
  TextEditingController phoneCtl = TextEditingController();
  TextEditingController authCtl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Color(Global.colorPrimaryDark),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Text(
          "修改手机号",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 70,
            margin: EdgeInsets.only(left: 16, right: 16, top: 30),
            child: Card(
              color: Colors.white,
              child: TextField(
                style: TextStyle(fontSize: 16,color: Color(Global.colorPrimaryDark)),
                controller: phoneCtl,
                cursorColor: Color(Global.colorAccent),
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    hintText: "请输入新手机号码",
                    hintStyle: TextStyle(fontSize: 16,color: Colors.grey),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none)),
              ),
            ),
          ),
          Container(
            height: 70,
            margin: EdgeInsets.only(left: 16, right: 16, top: 10),
            child: Card(
              color: Colors.white,
              child: TextField(
                controller: authCtl,
                style: TextStyle(fontSize: 16,color: Color(Global.colorPrimaryDark)),
                cursorColor: Color(Global.colorAccent),
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    suffix: Container(
                      width: 60,
                      height: 36,
                      margin: EdgeInsets.only(right: 5),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)),
                        onPressed: () {
                          if (canGetAuthCode) {
                            getAuthCode();
                          }
                        },
                        color: canGetAuthCode
                            ? Color(0xff4BBFE0)
                            : Color(0xffcccccc),
                        child: Text(
                          canGetAuthCode ? "獲取" : countdownTime.toString(),
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),
                    ),
                    hintText: "请输入驗證碼",
                    hintStyle: TextStyle(fontSize: 16,color: Colors.grey),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none)),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 44,
            margin: EdgeInsets.only(left: 20, right: 20, top: 30),
            child: RaisedButton(
              onPressed: () {
                if (phoneCtl.text.isEmpty) {
                  Fluttertoast.showToast(msg: "請先輸入手機號碼");
                  return;
                }
                if (authCtl.text.isEmpty) {
                  Fluttertoast.showToast(msg: "請先輸入驗證碼");
                  return;
                }
                showDialog(
                    context: context,
                    builder: (context) => LoadingDialog("正在修改手機號..."));
                NetworkUtil.post(
                    "/api/user/verify",
                    {
                      "mobile": phoneCtl.text,
                      "arenacode": phoneCtl.text.length == 8 ? "853" : "86",
                      "token": authCtl.text,
                      "type": "changemobile"
                    },
                    true, (respone) {
                  Navigator.pop(context);
                  Fluttertoast.showToast(msg: "修改手機號成功");
                  Global.preferences.setString("username", phoneCtl.text);
                  Navigator.pop(context, true);
                }, (erro) {
                  Navigator.pop(context);
                  Fluttertoast.showToast(msg: "修改手機號失敗");
                });
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22)),
              child: Text(
                "確認",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              color: Color(Global.colorAccent),
            ),
          )
        ],
      ),
    );
  }

  void doCountDown() {
    if (countdownTime == 1) {
      setState(() {
        canGetAuthCode = true;
        countdownTime = 60;
      });
    } else {
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          canGetAuthCode = false;
          countdownTime = countdownTime - 1;
        });
        doCountDown();
      });
    }
  }

  void getAuthCode() {
    if (phoneCtl.text.isEmpty) {
      Fluttertoast.showToast(msg: "請先輸入手機號碼");
      return;
    }
    showDialog(
        context: context,
        builder: (context) => LoadingDialog("正在获取验证码..."));
    NetworkUtil.post(
        "/api/user/verify",
        {
          "mobile": phoneCtl.text,
          "arenacode": phoneCtl.text.length == 8 ? "853" : "86",
          "type": "reset"
        },
        true, (respone) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "请求发送验证码成功，注意短信查收验证码");
      setState(() {
        canGetAuthCode = false;
      });
      doCountDown();
    }, (erro) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "请求发送验证码失败");
    });
  }
}
