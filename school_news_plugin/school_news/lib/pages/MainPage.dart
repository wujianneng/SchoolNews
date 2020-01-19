import 'dart:convert';
import 'dart:io';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:school_news/beans/ChildrenEntity.dart';
import 'package:school_news/beans/UpdateChildrenEvent.dart';
import 'package:school_news/coustomViews/MeFragment.dart';
import 'package:school_news/coustomViews/NoticeFragment.dart';
import 'package:school_news/pages/NoticeDetailPage.dart';
import 'package:school_news/utils/Global.dart';
import 'package:school_news/utils/NetworkUtil.dart';
import 'package:school_news_plugin/school_news_plugin.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with AutomaticKeepAliveClientMixin<MainPage> {
  NoticeFragment noticeWidget;
  MeFragment meWidget;
  int currentPageIndex = 0;
  List<Widget> _children = List();
  JPush jpush = new JPush();

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Global.eventBus = EventBus();
    Global.preferences.setBool("logined", true);
    if (!Global.preferences.get("isTeacher")) {
      Global.eventBus.on<UpdateChildrenEvent>().listen((data) {
        getChildrenList();
      });
      getChildrenList();
    }
    noticeWidget = NoticeFragment();
    meWidget = MeFragment();
    _children = [noticeWidget, meWidget];
    jpush.setup(
      appKey: "baf5b3a9866d4de736f2a2c5",
      channel: "10000",
      production: false,
      debug: true,
    );
    if (Platform.isIOS)
      jpush.applyPushAuthority(
          new NotificationSettingsIOS(sound: true, alert: true, badge: true));
    jpush.getRegistrationID().then((rid) {
      print(rid);
    });
    jpush.setAlias(Global.preferences.getString("username")).then((map) {});
    jpush.addEventHandler(
      // 接收通知回调方法。
      onReceiveNotification: (Map<String, dynamic> message) async {
        print("flutter onReceiveNotification: $message");
      },
      // 点击通知回调方法。
      onOpenNotification: (Map<String, dynamic> message) async {
        print("flutter onOpenNotification: $message");
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => NoticeDetailPage(1, true)));
      },
      // 接收自定义消息回调方法。
      onReceiveMessage: (Map<String, dynamic> message) async {
        print("flutter onReceiveMessage: $message");
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Global.eventBus.destroy();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: IndexedStack(
                index: currentPageIndex,
                children: _children,
              ),
            ),
            BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.notifications),
                  title: Text('通告'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  title: Text('我的'),
                )
              ],
              currentIndex: currentPageIndex,
              selectedItemColor: Color(Global.colorPrimaryDark),
              onTap: _onItemTapped,
            )
          ],
        ),
      ),
      onWillPop: () {
        print("onclick back");
        SchoolNewsPlugin.onBackToHome;
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  void getChildrenList() {
    NetworkUtil.get("/api/parent/student/list", true, (respone) {
      print("kidlist:" + respone.body);
      ChildrenEntity childrenEntity = ChildrenEntity.fromJson(
          jsonDecode(Utf8Decoder().convert(respone.bodyBytes)));
      childrenEntity.results[0].name = "湯姆";
      Global.childrenList = childrenEntity.results;
      noticeWidget.updateChildrenList();
      meWidget.updateChild();
    }, (erro) {
      print(erro);
    });
  }
}
