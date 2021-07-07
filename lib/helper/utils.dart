import 'dart:convert';
import 'package:crypto/crypto.dart';

class Utils {
  static String hashPassword(String original) {
    var key = utf8.encode('thu&3r');
    var bytes = utf8.encode(original);

    var hmacSha256 = new Hmac(sha256, key); // HMAC-SHA256
    var digest = hmacSha256.convert(bytes);

    return digest.toString();
  }
}
