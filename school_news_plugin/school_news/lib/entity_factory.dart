import 'package:school_news/beans/ChildrenEntity.dart';
import 'package:school_news/beans/LoginEntity.dart';
import 'package:school_news/beans/NoticeListEntity.dart';
import 'package:school_news/beans/RelationShipEntity.dart';

class EntityFactory {
  static T generateOBJ<T>(json) {
    if (1 == 0) {
      return null;
    } else if (T.toString() == "ChildrenEntity") {
      return ChildrenEntity.fromJson(json) as T;
    } else if (T.toString() == "LoginEntity") {
      return LoginEntity.fromJson(json) as T;
    } else if (T.toString() == "NoticeListEntity") {
      return NoticeListEntity.fromJson(json) as T;
    } else if (T.toString() == "RelationShipEntity") {
      return RelationShipEntity.fromJson(json) as T;
    } else {
      return null;
    }
  }
}