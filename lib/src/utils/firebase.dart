import 'package:firebase_messaging/firebase_messaging.dart';

Future<String?> getToken() async {
  String? token = await FirebaseMessaging.instance.getToken();

  print('getToken called: $token');

  return token;
}
