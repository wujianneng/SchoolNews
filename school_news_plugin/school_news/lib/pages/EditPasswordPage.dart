import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:school_news/coustomViews/LoadingDialog.dart';
import 'package:school_news/utils/Global.dart';
import 'package:school_news/utils/NetworkUtil.dart';

class EditPasswordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _EditPasswordPageState();
  }
}

class _EditPasswordPageState extends State<EditPasswordPage> {
  TextEditingController passwordCtl = TextEditingController();
  TextEditingController passwordAgainCtl = TextEditingController();

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
          "修改密碼",
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
                style: TextStyle(
                    fontSize: 16, color: Color(Global.colorPrimaryDark)),
                controller: passwordCtl,
                cursorColor: Color(Global.colorAccent),
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                    hintText: "请输入新密碼",
                    hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
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
                controller: passwordAgainCtl,
                style: TextStyle(
                    fontSize: 16, color: Color(Global.colorPrimaryDark)),
                cursorColor: Color(Global.colorAccent),
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                    hintText: "请再次確認新密碼",
                    hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
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
                if (passwordCtl.text.isEmpty) {
                  Fluttertoast.showToast(msg: "請先輸入密碼");
                  return;
                }
                if (passwordAgainCtl.text.isEmpty) {
                  Fluttertoast.showToast(msg: "請先再確認密碼");
                  return;
                }
                if (passwordAgainCtl.text != passwordCtl.text) {
                  Fluttertoast.showToast(msg: "兩次輸入密碼不一致");
                  return;
                }
                showDialog(
                    context: context,
                    builder: (context) => LoadingDialog("正在修改密碼..."));
                NetworkUtil.post(
                    "/api/user/change",
                    {
                      "newpassword": passwordCtl.text,
                    },
                    true, (respone) {
                  Navigator.pop(context);
                  Fluttertoast.showToast(msg: "修改密碼成功");
                  Navigator.pop(context);
                }, (erro) {
                  Navigator.pop(context);
                  Fluttertoast.showToast(msg: "修改密碼失敗");
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
}
