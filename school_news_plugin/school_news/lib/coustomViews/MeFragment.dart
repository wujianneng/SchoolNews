import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:school_news/beans/ChildrenEntity.dart';
import 'package:school_news/beans/UpdateChildEvent.dart';
import 'package:school_news/pages/AddKidPage.dart';
import 'package:school_news/pages/EditPasswordPage.dart';
import 'package:school_news/pages/EditPhonePage.dart';
import 'package:school_news/pages/LoginPage.dart';
import 'package:school_news/utils/Global.dart';
import 'package:school_news/utils/NetworkUtil.dart';

class MeFragment extends StatefulWidget {
  _MeFragmentState _meFragmentState;

  MeFragment() {
    _meFragmentState = _MeFragmentState();
  }

  @override
  _MeFragmentState createState() => _meFragmentState;

  updateChild() {
    _meFragmentState.initDatas();
  }
}

class _MeFragmentState extends State<MeFragment> {
  int viewIndex = 0; //0家長，1老師
  List<String> taglist = ["古箏隊", "江門市新會區古井鎮舞蹈隊", "..."];
  var _eventBusOn;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Global.preferences.getBool("isTeacher")) getTeacherInfo();
    _eventBusOn = Global.eventBus.on<UpdateChildEvent>().listen((data) {
      print("updateevent1");
      setState(() {});
    });
  }

  void initDatas() {
    Global.selectedChild = Global.childrenList[0];
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _eventBusOn.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff8273BB),
        elevation: 0,
        centerTitle: true,
        title: Text("我的", style: TextStyle(color: Colors.white, fontSize: 20)),
        actions: <Widget>[
          Center(
            child: Container(
              margin: EdgeInsets.only(left: 0, top: 0, right: 16, bottom: 0),
              child: InkWell(
                onTap: () {
                  Global.preferences.setBool("logined", false);
                  Navigator.pushAndRemoveUntil(
                      context,
                      CupertinoPageRoute(builder: (context) => LoginPage()),
                      (route) => route == null);
                },
                child: Text("登出",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        child: Stack(
          children: <Widget>[
            Container(
              color: Color(0xff8273BB),
              height: 120,
              width: double.infinity,
            ),
            Container(
              margin: EdgeInsets.only(left: 16, top: 10, right: 16, bottom: 0),
              width: double.infinity,
              height: 150,
              child: Card(
                color: Colors.white,
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: IndexedStack(
                  index: viewIndex,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          child: Image.asset(
                            "images/me_def.png",
                            width: 74,
                            height: 74,
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(37)),
                          height: 160,
                          margin: EdgeInsets.only(left: 16, right: 16),
                        ),
                        Container(
                          height: 160,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(Global.selectedChild.name ?? "",
                                  style: TextStyle(
                                      fontSize: 16, color: Color(0xff827BA5))),
                              Text(Global.selectedChild.classgroup ?? "",
                                  style: TextStyle(
                                      fontSize: 15, color: Color(0xff827BA5))),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(""),
                        ),
                        PopupMenuButton(
                          tooltip: "學生列表",
                          offset: Offset.fromDirection(1,60),
                          child: Container(
                            width: 26,
                            height: 26,
                            margin: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(13),
                              color: Color(Global.colorAccent),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xffcccccc),
                                  blurRadius: 3.0,
                                ),
                              ]
                            ),
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                            ),
                          ),
                          onSelected: (choice) {
                            Global.selectedChild = choice;
                            Global.eventBus.fire(UpdateChildEvent(choice));
                          },
                          //Called when the user selects a value from the popup menu created by this button..
                          itemBuilder: (BuildContext context) {
                            return Global.childrenList.map((childResults choice) {
                              return new PopupMenuItem(
                                  child: new Text(choice.name), value: choice);
                            }).toList();
                          },
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          child: Image.asset("images/me_def.png",
                              width: 74, height: 74),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(37)),
                          height: 160,
                          margin: EdgeInsets.only(left: 16, right: 16),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 160,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.topRight,
                                  height: 26,
                                  margin: EdgeInsets.only(top: 12, right: 20),
                                  child: RaisedButton(
                                      padding:
                                          EdgeInsets.only(left: 5, right: 5),
                                      onPressed: () {},
                                      child: Text("班主任",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15)),
                                      color: Color(Global.colorAccent)),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  alignment: Alignment.topLeft,
                                  child: Text("陳大文",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xff827BA5))),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 6),
                                  alignment: Alignment.topLeft,
                                  child: Wrap(
                                    children: taglist
                                        .map((item) => ActionChip(
                                              backgroundColor:
                                                  Color(0xffFFF6D9),
                                              label: ConstrainedBox(
                                                constraints: BoxConstraints(
                                                    maxWidth: 60),
                                                child: Text(
                                                  item,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Color(0xff827BA5)),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textWidthBasis:
                                                      TextWidthBasis.parent,
                                                ),
                                              ),
                                              elevation: 1,
                                              onPressed: () {
                                                if (item == "...") {
                                                  Fluttertoast.showToast(
                                                      msg: "...");
                                                }
                                              },
                                            ))
                                        .toList(),
                                    spacing: 16,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 16, top: 170, right: 16, bottom: 0),
              width: double.infinity,
              height: 129,
              child: Card(
                color: Colors.white,
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: <Widget>[
                    InkWell(
                      onTap: () async {
                        bool hasEdited = await Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => EditPhonePage()));
                        if (hasEdited) setState(() {});
                      },
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Text("手機號碼",
                                style: TextStyle(
                                    fontSize: 16, color: Color(0xff827BA5))),
                            Expanded(
                              flex: 1,
                              child: Text(""),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: 10, top: 0, right: 10, bottom: 0),
                              child: Text(
                                  Global.preferences.getString("username"),
                                  style: TextStyle(
                                      fontSize: 14, color: Color(0xff827BA5))),
                            ),
                            Icon(
                              Icons.keyboard_arrow_right,
                              color: Color(0xff827BA5),
                            )
                          ],
                        ),
                        height: 60,
                        padding: EdgeInsets.only(
                            left: 16, top: 0, right: 16, bottom: 0),
                      ),
                    ),
                    Divider(height: 1),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => EditPasswordPage()));
                      },
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Text("修改密碼",
                                style: TextStyle(
                                    fontSize: 16, color: Color(0xff827BA5))),
                            Expanded(
                              flex: 1,
                              child: Text(""),
                            ),
                            Icon(
                              Icons.keyboard_arrow_right,
                              color: Color(0xff827BA5),
                            )
                          ],
                        ),
                        height: 60,
                        padding: EdgeInsets.only(
                            left: 16, top: 0, right: 16, bottom: 0),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Visibility(
              visible: !Global.preferences.getBool("isTeacher"),
              child: Container(
                width: double.infinity,
                height: 55,
                margin:
                    EdgeInsets.only(left: 20, top: 310, right: 20, bottom: 0),
                child: RaisedButton(
                  elevation: 1,
                  onPressed: () {
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (context) => AddKidPage(isFormMe: true)));
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.add_circle_outline, color: Color(0xff847EA7)),
                      Container(
                        margin: EdgeInsets.only(
                            left: 5, top: 0, right: 0, bottom: 0),
                        child: Text("添加學生",
                            style: TextStyle(
                                color: Color(0xff847EA7), fontSize: 16)),
                      )
                    ],
                  ),
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getTeacherInfo() {
    NetworkUtil.get("/api/user/staff/info", true, (respone) {}, (erro) {});
  }
}
