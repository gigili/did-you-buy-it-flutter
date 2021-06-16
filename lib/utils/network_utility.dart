import 'package:did_you_buy_it/utils/types.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

void callAPI(
  String url, {
  Object? params,
  Map<String, String>? headers,
  Function(String data)? callback,
  Function(int statusCode, String data)? errorCallback,
  RequestMethod requestMethod = RequestMethod.GET,
}) async {
  Uri _url = Uri.parse('$BASE_URL$url');
  http.Response response;

  switch (requestMethod) {
    case RequestMethod.POST:
      response = await http.post(_url, body: params, headers: headers);
      break;

    case RequestMethod.PUT:
      response = await http.put(_url, body: params, headers: headers);
      break;

    case RequestMethod.PATCH:
      response = await http.patch(_url, body: params, headers: headers);
      break;

    case RequestMethod.DELETE:
      response = await http.delete(_url, body: params, headers: headers);
      break;

    default:
      response = await http.get(_url, headers: headers);
      break;
  }

  if (response.request != null) {
    if (response.statusCode < 200 || response.statusCode > 399) {
      if (errorCallback != null) {
        errorCallback(response.statusCode, response.body);
      } else {
        print("[ERROR] " + response.body);
      }
      return;
    }

    if (callback != null) {
      callback(response.body);
    } else {
      print("[INFO] " + response.body);
    }
  } else {
    print("[ERROR] NO HTTP call");
  }
}
