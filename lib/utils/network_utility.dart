import 'package:did_you_buy_it/.env.dart';
import 'package:did_you_buy_it/utils/exceptions/service_unavailable_exception.dart';
import 'package:did_you_buy_it/utils/types.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

Future<http.Response> callAPI(
  String url, {
  Map<String, dynamic>? params,
  Map<String, String>? headers,
  Function(String data)? callback,
  Function(int statusCode, String data)? errorCallback,
  RequestMethod requestMethod = RequestMethod.GET,
  XFile? file,
}) async {
  Uri _url = Uri.parse('$BASE_URL$url');
  try {
    switch (requestMethod) {
      case RequestMethod.POST:
        return await http.post(_url, body: params, headers: headers);

      case RequestMethod.PUT:
        return await http.put(_url, body: params, headers: headers);

      case RequestMethod.PATCH:
        return await http.patch(_url, body: params, headers: headers);

      case RequestMethod.DELETE:
        return await http.delete(_url, body: params, headers: headers);

      default:
        return await http.get(_url, headers: headers);
    }
  } catch (ex) {
    throw ServiceUnavailableException();
  }
}

Future<http.StreamedResponse> callAPIFileUpload(
  String url, {
  Map<String, String>? params,
  Map<String, String>? headers,
  RequestMethod requestMethod = RequestMethod.POST,
  required XFile file,
}) async {
  Uri _url = Uri.parse('$BASE_URL$url');
  var rqMethod = requestMethod == RequestMethod.POST ? "POST" : "PATCH";
  var request = new http.MultipartRequest(rqMethod, _url);

  if (params != null) request.fields.addAll(params);
  if (headers != null) request.headers.addAll(headers);

  request.files.add(await http.MultipartFile.fromPath(file.name, file.path));
  return await request.send();
}
