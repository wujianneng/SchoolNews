import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:school_news/beans/RelationShipEntity.dart';
import 'package:school_news/beans/UpdateChildrenEvent.dart';
import 'package:school_news/coustomViews/LoadingDialog.dart';
import 'package:school_news/utils/Global.dart';
import 'package:school_news/utils/NetworkUtil.dart';

class AddKidPage extends StatefulWidget {
  _AddKidPageState __addKidPageState;

  AddKidPage({bool isFormMe = false}) {
    __addKidPageState = _AddKidPageState(isFormMe);
  }

  @override
  _AddKidPageState createState() => __addKidPageState;
}

class _AddKidPageState extends State<AddKidPage> {
  TextEditingController numberCtl = TextEditingController();
  String bornDate;
  RelationShipData data;
  List<RelationShipData> datalist = List();
  bool isFormMe = false;

  _AddKidPageState(bool isFormMe) {
    this.isFormMe = isFormMe;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRelativeList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(Global.colorPrimaryDark),
        centerTitle: true,
        title: Text(
          "添加学生",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 35, top: 14, right: 35, bottom: 0),
          child: Column(
            children: <Widget>[
              Image.asset("images/add_import_def.png"),
              Container(
                margin: EdgeInsets.only(top: 40),
                padding: EdgeInsets.only(left: 18, right: 15),
                height: 44,
                width: double.infinity,
                color: Color(0x9fF8F8FF),
                child: TextField(
                  keyboardAppearance: Brightness.dark,
                  controller: numberCtl,
                  keyboardType: TextInputType.phone,
                  cursorColor: Color(Global.colorAccent),
                  decoration: InputDecoration(
                    hintText: "請輸入学号",
                    hintStyle:
                        TextStyle(fontSize: 14, color: Color(0xffA6A2BA)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent)),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                height: 44,
                width: double.infinity,
                child: FlatButton(
                    onPressed: () {
                      DateTime datetime = DateTime.now();
                      CupertinoDatePicker picker = CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime: datetime,
                        onDateTimeChanged: (date) {
                          datetime = date;
                        },
                      );
                      showCupertinoModalPopup(
                          context: context,
                          builder: (context) => Container(
                                height: 260,
                                child: Stack(
                                  children: <Widget>[
                                    picker,
                                    Container(
                                      alignment: Alignment.topRight,
                                      child: FlatButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          String month = (datetime.month < 10)
                                              ? ("0" +
                                                  datetime.month.toString())
                                              : datetime.month.toString();
                                          String day = (datetime.day < 10)
                                              ? ("0" + datetime.day.toString())
                                              : datetime.day.toString();
                                          setState(() {
                                            bornDate =
                                                datetime.year.toString() +
                                                    "-" +
                                                    month +
                                                    "-" +
                                                    day;
                                          });
                                        },
                                        child: Text("確定"),
                                      ),
                                    )
                                  ],
                                ),
                              ));
                    },
                    color: Color(0x9fF8F8FF),
                    child: Row(
                      children: <Widget>[
                        Text(bornDate ?? "请选择出生日期",
                            style: TextStyle(
                                fontSize: 14, color: Color(0xffA6A2BA))),
                        Expanded(
                          child: Text(""),
                          flex: 1,
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: Color(Global.colorPrimaryDark),
                        )
                      ],
                    )),
              ),
              Container(
                height: 44,
                width: double.infinity,
                margin: EdgeInsets.only(top: 14),
                color: Color(0x9fF8F8FF),
                child: PopupMenuButton(
                  tooltip: "关系列表",
                  child: FlatButton(
                      child: Row(
                    children: <Widget>[
                      Text(data?.name ?? "请选择与学生的关系",
                          style: TextStyle(
                              fontSize: 14, color: Color(0xffA6A2BA))),
                      Expanded(
                        child: Text(""),
                        flex: 1,
                      ),
                      Icon(
                        Icons.keyboard_arrow_right,
                        color: Color(Global.colorPrimaryDark),
                      )
                    ],
                  )),
                  onSelected: (choice) {
                    setState(() {
                      data = choice;
                    });
                  },
                  //Called when the user selects a value from the popup menu created by this button..
                  itemBuilder: (BuildContext context) {
                    return datalist.map((RelationShipData choice) {
                      return new PopupMenuItem(
                          child: new Text(choice.name), value: choice);
                    }).toList();
                  },
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 30, bottom: 30),
                height: 44,
                child: RaisedButton(
                  onPressed: () {
                    if (numberCtl.text.isEmpty) {
                      Fluttertoast.showToast(msg: "请先输入学号");
                      return;
                    }
                    if (bornDate.isEmpty) {
                      Fluttertoast.showToast(msg: "请先选择出生日期");
                      return;
                    }
                    if (data == null) {
                      Fluttertoast.showToast(msg: "请先选择与学生的关系");
                      return;
                    }
                    addChild(false);
                  },
                  color: Color(Global.colorAccent),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22)),
                  child: Text(
                    "添加",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void addChild(bool isComfirm) {
    showDialog(
        context: context, builder: (context) => LoadingDialog("正在添加子女..."));
    NetworkUtil.post(
        "/api/parent/student/add",
        {
          "confirm": isComfirm,
          "studentno": numberCtl.text,
          "birthdate": bornDate,
          "relationship": data.id.toString()
        },
        true, (respone) {
      Map reslut = jsonDecode(Utf8Decoder().convert(respone.bodyBytes));
      Navigator.pop(context);
      if (reslut["code"] == 301) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("提示"),
                  content: Text(reslut["msg"]),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("取消"),
                    ),
                    FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                          addChild(true);
                        },
                        child: Text("確定"))
                  ],
                ));
      } else {
        Fluttertoast.showToast(msg: "添加成功");
        if (isFormMe) {
          Navigator.pop(context);
          Global.eventBus.fire(UpdateChildrenEvent("updateChildren"));
        }
      }
    }, (erro) {
      Fluttertoast.showToast(msg: "添加失败");
      Navigator.pop(context);
    });
  }

  void getRelativeList() {
    NetworkUtil.get("/api/parent/student/add", true, (respone) {
      RelationShipEntity relationShipEntity = RelationShipEntity.fromJson(
          jsonDecode(Utf8Decoder().convert(respone.bodyBytes)));
      datalist = relationShipEntity.data;
    }, (erro) {});
  }
}
