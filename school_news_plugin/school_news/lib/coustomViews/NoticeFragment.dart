import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/phoenix_header.dart';
import 'package:school_news/beans/ChildrenEntity.dart';
import 'package:school_news/beans/NoticeListEntity.dart';
import 'package:school_news/beans/UpdateChildEvent.dart';
import 'package:school_news/pages/NoticeDetailPage.dart';
import 'package:school_news/utils/Global.dart';
import 'package:school_news/utils/NetworkUtil.dart';

class NoticeFragment extends StatefulWidget {
  _NoticeFragmentState __noticeFragmentState;

  @override
  _NoticeFragmentState createState() {
    return __noticeFragmentState = _NoticeFragmentState();
  }

  updateChildrenList() {
    __noticeFragmentState.initDatas();
  }
}

class _NoticeFragmentState extends State<NoticeFragment> {
  TextEditingController searchController = TextEditingController();
  int requestPage = 1;
  List<List<NoticeListResult>> dataList = List();
  EasyRefreshController refreshController = EasyRefreshController();
  var _eventBusOn;

  void initDatas() {
    setState(() {});
    Global.selectedChild = Global.childrenList[0];
    onRefreshData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _eventBusOn.cancel();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _eventBusOn = Global.eventBus.on<UpdateChildEvent>().listen((data) {
      print("updateevent0");
      onRefreshData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      controller: refreshController,
      header: PhoenixHeader(),
      onRefresh: onRefreshData,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Color(Global.colorPrimaryDark),
            centerTitle: true,
            title:
                Text("通告", style: TextStyle(color: Colors.white, fontSize: 20)),
            expandedHeight: 105,
            floating: true,
            pinned: true,
            snap: true,
            actions: <Widget>[
              Visibility(
                visible: !Global.preferences.getBool("isTeacher"),
                child: Container(
                  alignment: Alignment.center,
                  margin:
                  EdgeInsets.only(left: 16,right: 5),
                  child: Row(
                    children: <Widget>[
                      Text(
                          Global.childrenList.length == 0
                              ? ""
                              : Global.selectedChild.name,
                          style:
                          TextStyle(color: Colors.white, fontSize: 16)),
                      PopupMenuButton(
                        tooltip: "學生列表",
                        offset: Offset.fromDirection(1,45),
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white,
                        ),
                        onSelected: (choice) {
                          Global.selectedChild = choice;
                          Global.eventBus.fire(UpdateChildEvent(choice));
                          onRefreshData();
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
                ),
              )
            ],
            flexibleSpace: FlexibleSpaceBar(
                background: Container(
                    margin: EdgeInsets.only(
                        left: 16, top: 75, right: 16, bottom: 10),
                    child: TextField(
                      controller: searchController,
                      cursorColor: Color(Global.colorAccent),
                      decoration: InputDecoration(
                          hintText: "搜尋",
                          prefixIcon: Icon(
                            Icons.search,
                            color: Color(0xff8273BB),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.only(
                              left: 16, top: 10, right: 16, bottom: 0)),
                    ))),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => NoticeGroupItemView(dataList[index]),
              childCount: dataList.length,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> onRefreshData() async {
    String url = "";
    if (Global.preferences.getBool("isTeacher")) {
      url = "/api/staff/notices/list" +
          "?page=" +
          requestPage.toString() +
          "&search=" +
          searchController.text;
    } else {
      url = "/api/parent/notices/list" +
          "?page=" +
          requestPage.toString() +
          "&studentid=" +
          Global.selectedChild.id.toString() +
          "&search=" +
          searchController.text;
    }
    await NetworkUtil.get(url, true, (respone) {
      NoticeListEntity noticeListEntity = NoticeListEntity.fromJson(
          jsonDecode(Utf8Decoder().convert(respone.bodyBytes)));
      dataList.clear();
      noticeListEntity.results.forEach((item) {
        List<NoticeListResult> list = ifDataListcontainsKey(item.publish);
        if (list != null) {
          list.add(item);
        } else {
          List<NoticeListResult> list = List();
          list.add(item);
          dataList.add(list);
        }
      });
      setState(() {});
      refreshController.finishRefresh(success: true);
    }, (erro) {
      print(erro);
    });
  }

  List<NoticeListResult> ifDataListcontainsKey(String publish) {
    dataList.forEach((item) {
      if (item[0].publish == publish) return item;
    });
    return null;
  }
}

class NoticeGroupItemView extends StatelessWidget {
  List<NoticeListResult> noticelist;

  NoticeGroupItemView(List<NoticeListResult> list) {
    noticelist = list;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            color: Color(0xffF8F8FF),
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 16, top: 0, right: 16, bottom: 0),
            width: double.infinity,
            height: 40,
            child: Text(
              noticelist[0].publish + "  " + noticelist[0].week,
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                  decoration: TextDecoration.none),
            ),
          ),
          Divider(
            height: 1,
          ),
          MediaQuery.removePadding(
            removeTop: true,
            context: context,
            child: ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, i) => NoticeChildIteView(noticelist[i]),
                separatorBuilder: (context, i) => Divider(
                      height: 1,
                    ),
                itemCount: noticelist.length),
          )
        ],
      ),
    );
  }
}

class NoticeChildIteView extends StatelessWidget {
  NoticeListResult notice;

  NoticeChildIteView(NoticeListResult notice) {
    this.notice = notice;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => NoticeDetailPage(notice.id, false)));
        },
        child: Container(
          width: double.infinity,
          height: 80,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 0, top: 10, right: 0, bottom: 0),
                height: 30,
                child: Row(
                  children: <Widget>[
                    Visibility(
                      child: Container(
                        width: 10,
                        height: 10,
                        margin: EdgeInsets.only(
                            left: 16, top: 0, right: 16, bottom: 0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color(Global.colorAccent)),
                      ),
                      visible: !notice.read,
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: !notice.read ? 0 : 16,
                          top: 0,
                          right: 0,
                          bottom: 0),
                      child: Text(notice.subject,
                          style: TextStyle(
                              color: Color(Global.colorPrimaryDark),
                              fontSize: 15,
                              decoration: TextDecoration.none)),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(""),
                    ),
                    Text(notice.time,
                        style: TextStyle(
                            color: Color(0xff827BA5),
                            fontSize: 13,
                            decoration: TextDecoration.none)),
                    Container(
                      margin: EdgeInsets.only(
                          left: 16, top: 0, right: 16, bottom: 0),
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        color: Color(0xff827BA5),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 30,
                child: Row(
                  children: <Widget>[
                    Visibility(
                      visible: notice.attachment,
                      child: Container(
                        margin: EdgeInsets.only(
                            left: 12, top: 0, right: 10, bottom: 0),
                        child: Image.asset(
                          "images/inform_icon_file_small.png",
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: notice.attachment ? 0 : 16,
                          top: 0,
                          right: 0,
                          bottom: 0),
                      child: Text(
                        notice.description,
                        style: TextStyle(
                            color: Color(0xff7D7C7D),
                            fontSize: 13,
                            decoration: TextDecoration.none),
                        maxLines: 1,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(""),
                    ),
                    Visibility(
                      visible: !Global.preferences.getBool("isTeacher"),
                      child: Container(
                        margin: EdgeInsets.only(
                            left: 16, top: 0, right: 18, bottom: 0),
                        child: Image.asset(
                          notice.submitted
                              ? "images/commited.png"
                              : "images/un_commited.png",
                          width: 20,
                          height: 20,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
