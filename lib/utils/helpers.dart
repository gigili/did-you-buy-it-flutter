import 'dart:convert';

import 'package:crypto/crypto.dart';

String hashStr(String str) {
  var bytes = utf8.encode(str); // data being hashed
  return sha256.convert(bytes).toString();
}
