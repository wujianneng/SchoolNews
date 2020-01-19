import 'package:flutter/material.dart';
import 'package:school_news/beans/NoticeListEntity.dart';
import 'package:school_news/utils/Global.dart';
import 'package:school_news/utils/NetworkUtil.dart';

class NoticeDetailPage extends StatefulWidget {
  _NoticeDetailPageState __noticeDetailPageState;

  NoticeDetailPage(int noticeBeanId, bool isFromNotification) {
    __noticeDetailPageState =
        _NoticeDetailPageState(noticeBeanId, isFromNotification);
  }

  @override
  _NoticeDetailPageState createState() => __noticeDetailPageState;
}

class _NoticeDetailPageState extends State<NoticeDetailPage> {
  int noticeBeanId;
  bool isFromNotification;

  _NoticeDetailPageState(int noticeBeanId, bool isFromNotification) {
    this.noticeBeanId = noticeBeanId;
    this.isFromNotification = isFromNotification;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (isFromNotification) {
    } else {
      getDatas();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(Global.colorPrimaryDark),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        title:
            Text("通告詳情", style: TextStyle(fontSize: 20, color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  child: Text("古文第一课",
                      style: TextStyle(fontSize: 16, color: Color(0xff5A489E))),
                  margin: EdgeInsets.only(left: 16, top: 8),
                ),
                Expanded(
                  flex: 1,
                  child: Text(""),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.people,
                      color: Color(Global.colorPrimaryDark),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8, right: 5),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.attach_file,
                      color: Color(Global.colorPrimaryDark),
                    ),
                  ),
                )
              ],
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(left: 16, bottom: 20),
              child: Text(
                "上午：9:30 2019/07/23",
                style: TextStyle(fontSize: 14, color: Color(0xff827BA5)),
              ),
            ),
            Divider(
              height: 1,
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                r"山不在高，有仙则灵；水不在深，有龙则灵；斯是陋室，唯吾德馨！苔痕上阶绿，草色入帘青。"
                r"永德九年，岁在癸丑。环滁皆山也。其西南诸峰，林壑尤美，望之蔚然而深秀者，琅琊也。山行六七里，渐闻水声潺潺而泻出于两峰之间者，"
                r"酿泉也。峰回路转，有亭翼然临于泉上者，醉翁亭也。作亭者谁？山之僧智仙也。名之者谁？太守自谓也。太守与客来饮于此，饮少辄醉，"
                r"而年又最高，故自号曰醉翁也。醉翁之意不在酒，在乎山水之间也。山水之乐，得之心而寓之酒也。",
                style: TextStyle(color: Color(0xff666667)),
              ),
            ),
            ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, i) => QuestionItemView(),
                separatorBuilder: (context, i) => Divider(
                      height: 1,
                    ),
                itemCount: 2),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(left: 40, right: 40, top: 10, bottom: 30),
              height: 44,
              child: RaisedButton(
                onPressed: () {},
                color: Color(Global.colorAccent),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22)),
                child: Text(
                  "提 交",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void getDatas() {
    String url = "";
    if (Global.preferences.getBool("isTeacher")) {
      url = "/api/staff/notices/detail?noticeid=" + noticeBeanId.toString();
    } else {
      url = "/api/parent/notices/detail?noticeid=" +
          noticeBeanId.toString() +
          "&studentid=" +
          Global.selectedChild.id.toString();
    }
    NetworkUtil.get(url, true, (respone) {}, (erro) {});
  }
}

class QuestionItemView extends StatefulWidget {
  @override
  _QuestionItemViewState createState() => _QuestionItemViewState();
}

List<String> answers = ["此文写于民国时期", "此文写于西晋时期", "此文写于东汉末期", "其他"];
String selectAnswer = answers[0];

class _QuestionItemViewState extends State<QuestionItemView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                "问题1: 此篇文章写于哪个朝代？",
                style: TextStyle(color: Color(0xff5A489E)),
              ),
              Expanded(
                flex: 1,
                child: Text(""),
              ),
              Text(
                "*必填",
                style: TextStyle(fontSize: 14, color: Color(0xffE86838)),
              )
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, i) => Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Radio<String>(
                      value: answers[i],
                      groupValue: selectAnswer,
                      activeColor: Color(Global.colorAccent),
                      onChanged: (data) {
                        setState(() {
                          selectAnswer = data;
                        });
                      },
                    ),
                    Text(answers[i],
                        style:
                            TextStyle(fontSize: 14, color: Color(0xff827BA5)))
                  ],
                ),
                Visibility(
                  visible: answers[i] != "其他",
                  child:  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                            height: 73,
                            margin: EdgeInsets.all(2),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: new Image.asset("images/logo.png", fit: BoxFit.fill),
                            )
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                            height: 73,
                            margin: EdgeInsets.all(2),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: new Image.asset("images/logo.png", fit: BoxFit.fill),
                            )
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                            height: 73,
                            margin: EdgeInsets.all(2),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: new Image.asset("images/logo.png", fit: BoxFit.fill),
                            )
                        ),
                      )
                    ],
                  ),
                ),
                Visibility(
                  visible: selectAnswer == "其他" && answers[i] == "其他",
                  child: Container(
                    width: double.infinity,
                    height: 90,
                    color: Color(0xffF5F5F5),
                    child: TextField(
                      onChanged: (str){},
                      cursorColor: Color(Global.colorAccent),
                      decoration: InputDecoration(
                        hintText: "请输入补充内容...",
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none
                        )
                      ),
                    ),
                  ),
                )
              ],
            ),
            itemCount: answers.length,
          )
        ],
      ),
    );
  }
}
