import 'package:event_bus/event_bus.dart';
import 'package:school_news/beans/ChildrenEntity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Global{
  static String API_TOKEN = "Token";
  static String BASE_URL = "http://schoolcomm.infitack.net";
  static SharedPreferences preferences;
  static int colorPrimaryDark = 0xff8273BB;
  static int colorAccent = 0xffFFC526;
  static List<childResults> childrenList = List();
  static childResults selectedChild = childResults();
  static EventBus eventBus;
}