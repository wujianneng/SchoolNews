import 'package:http/http.dart' as http;

import 'Global.dart';

class NetworkUtil {
//  response.bodyBytes

  static String getRequestUrl(String url) {
    return Global.BASE_URL + url;
  }

  static Future postWithBody(String url, var body, bool useToken,
      Function onSuccess, Function onFailed) async {
    http.Response response = null;
    if (useToken) {
      Map<String, String> headers = {
        "Authorization": Global.API_TOKEN,
        "content-type": "application/json"
      };
      response =
          await http.post(getRequestUrl(url), headers: headers, body: body);
    } else
      response = await http.post(getRequestUrl(url), body: body);

    if (response != null && response.statusCode == 200)
      onSuccess(response);
    else
      onFailed(response.reasonPhrase);
  }

  static Future post(String url, Map<String, Object> params, bool useToken,
      Function onSuccess, Function onFailed) async {
    http.Response response = null;
    if (useToken) {
      Map<String, String> headers = {"Authorization": Global.API_TOKEN};
      response =
          await http.post(getRequestUrl(url), headers: headers, body: params);
    } else
      response = await http.post(getRequestUrl(url), body: params);
    print("url:" + getRequestUrl(url));
    if (response != null && response.statusCode == 200) {
      onSuccess(response);
      print("response:" + response.body);
    }else {
      onFailed(response.reasonPhrase);
      print("erro:" + response.reasonPhrase);
    }
  }

  static Future get(
      String url, bool useToken, Function onSuccess, Function onFailed) async {
    http.Response response = null;
    if (useToken) {
      Map<String, String> headers = {"Authorization": Global.API_TOKEN};
      response = await http.get(getRequestUrl(url), headers: headers);
    } else
      response = await http.get(getRequestUrl(url));
    print("url:" + getRequestUrl(url));
    if (response != null && response.statusCode == 200) {
      onSuccess(response);
      print("response:" + response.body);
    }else {
      onFailed(response.reasonPhrase);
      print("erro:" + response.reasonPhrase);
    }
  }

  static Future delete(
      String url, bool useToken, Function onSuccess, Function onFailed) async {
    http.Response response = null;
    if (useToken) {
      Map<String, String> headers = {"Authorization": Global.API_TOKEN};
      response = await http.delete(getRequestUrl(url), headers: headers);
    } else
      response = await http.delete(getRequestUrl(url));
    if (response != null && response.statusCode == 200)
      onSuccess(response);
    else
      onFailed(response.reasonPhrase);
  }

  static Future put(
      String url, bool useToken, Function onSuccess, Function onFailed) async {
    http.Response response = null;
    if (useToken) {
      Map<String, String> headers = {"Authorization": Global.API_TOKEN};
      response = await http.put(getRequestUrl(url), headers: headers);
    } else
      response = await http.put(getRequestUrl(url));
    if (response != null && response.statusCode == 200)
      onSuccess(response);
    else
      onFailed(response.reasonPhrase);
  }

  static Future putWithParams(String url, Map<String, Object> params,
      bool useToken, Function onSuccess, Function onFailed) async {
    http.Response response = null;
    if (useToken) {
      Map<String, String> headers = {"Authorization": Global.API_TOKEN};
      response =
          await http.put(getRequestUrl(url), headers: headers, body: params);
    } else
      response = await http.put(getRequestUrl(url), body: params);
    if (response != null && response.statusCode == 200)
      onSuccess(response);
    else
      onFailed(response.reasonPhrase);
  }
}
