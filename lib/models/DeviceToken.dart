import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:paywise/constants.dart';

// class DeviceToken {
//   final String finalToken;
//   DeviceToken({this.finalToken});
// }

// DeviceToken finalToken = DeviceToken(finalToken: '');

Future<http.Response> sendNotification(String title, String token) {
  EasyLoading.show(status: 'loading...');
  return http.post(
    Uri.https('fcm.googleapis.com', 'fcm/send'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'key=$serverKey'
    },
    body: jsonEncode(<String, Object>{
      'to': token,
      'notification': {'title': title, 'body': 'This is Notification'}
    }),
  );
}