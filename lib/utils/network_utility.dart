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
}) {
  Uri _url = Uri.parse('$BASE_URL$url');

  switch (requestMethod) {
    case RequestMethod.POST:
      http.post(_url, body: params, headers: headers).then((value) {
        handleNetworkResponse(value, callback, errorCallback);
      });
      break;

    case RequestMethod.PUT:
      http.put(_url, body: params, headers: headers).then((value) {
        handleNetworkResponse(value, callback, errorCallback);
      });
      break;

    case RequestMethod.PATCH:
      http.patch(_url, body: params, headers: headers).then((value) {
        handleNetworkResponse(value, callback, errorCallback);
      });
      break;

    case RequestMethod.DELETE:
      http.delete(_url, body: params, headers: headers).then((value) {
        handleNetworkResponse(value, callback, errorCallback);
      });
      break;

    default:
      http.get(_url, headers: headers).then((value) {
        handleNetworkResponse(value, callback, errorCallback);
      });
      break;
  }
}

void handleNetworkResponse(http.Response response, Function? callback, Function? errorCallback) {
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