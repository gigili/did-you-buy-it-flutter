import 'package:http/http.dart' as http;

const String BASE_URL = "http://10.9.9.66:8098";

void networkLogin(String username, String password) async{
  var url = Uri.parse('$BASE_URL/login');
  var response = await http.post(url, body: {
    'username': username,
    'password': password
  });
  
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
}
