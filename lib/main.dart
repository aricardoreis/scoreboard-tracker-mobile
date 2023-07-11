import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:scoreboard_mobile/src/utils/constants.dart' as constants;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'ScoreBoard Tracker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _home = 0;
  int _guest = 0;

  String? token;

  final dio = Dio(
    BaseOptions(
      validateStatus: (status) {
        return status! < 500;
      },
    ),
  );

  @override
  void initState() {
    getToken();

    FirebaseMessaging.instance.requestPermission().then((settings) =>
        print('User granted permission: ${settings.authorizationStatus}'));

    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      print('onTokenRefresh: $fcmToken');
      token = fcmToken;
    });

    FirebaseMessaging.onMessage.listen((message) {
      print('MESSAGE ${message.data}');
      if (message.notification != null) {
        print(
            'Message also contained a notification: ${message.notification?.title}');
      }

      setState(() {
        _home = int.parse(message.data["home"]);
        _guest = int.parse(message.data["guest"]);
      });
    });

    super.initState();
  }

  getToken() async {
    token = await FirebaseMessaging.instance.getToken();

    print('TOKEN $token');

    var result = await dio.post(
      constants.addTokenUrl,
      data: {
        "token": token,
      },
      options: Options(contentType: 'application/json; charset=utf-8'),
    );

    print("Send token to server: $result");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'HOME',
                ),
                Text(
                  '$_home',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'GUEST',
                ),
                Text(
                  '$_guest',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
