import 'package:http/http.dart' as http;

import '../constants.dart';

void callAPI(String url, {Object? params, Map<String, String>? headers,
    Function(String data)? callback, Function(int statusCode, String data)? errorCallback}) async {
  var _url = Uri.parse('$BASE_URL$url');

  var response = await http.post(_url, body: params, headers: headers);
print(params);
  if (response.statusCode < 200 || response.statusCode > 399) {
    if (errorCallback != null) errorCallback(response.statusCode, response.body);
  } else {
    if (callback != null) callback(response.body);
  }
}
