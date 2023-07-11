import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'src/screens/scoreboard_display.dart';
import 'src/utils/firebase.dart';
import 'src/utils/network.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // enter full screen
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? token;

  int _home = 0;
  int _guest = 0;

  @override
  void initState() {
    FirebaseMessaging.instance.requestPermission().then((settings) =>
        print('User granted permission: ${settings.authorizationStatus}'));

    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      print('onTokenRefresh: $fcmToken');
    });

    // TODO: move code responsible to listen messages to the display widget
    FirebaseMessaging.onMessage.listen((message) {
      print('MESSAGE ${message.data}');
      if (message.notification != null) {
        print(
            'Message also contained a notification: ${message.notification?.title}');
      }

      if (message.data.isNotEmpty) {
        setState(() {
          _home = int.parse(message.data["home"]);
          _guest = int.parse(message.data["guest"]);
        });
      }
    });

    FirebaseMessaging.instance.subscribeToTopic("scoreResult");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return token == null
        ? FutureBuilder(
            future: _loadToken(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              token = snapshot.data.toString();
              return ScoreBoardDisplay(
                homeName: 'home',
                guestName: 'guest',
                homeScore: _home,
                guestScore: _guest,
              );
            },
          )
        : ScoreBoardDisplay(
            homeName: 'home',
            guestName: 'guest',
            homeScore: _home,
            guestScore: _guest,
          );
  }

  _loadToken() async {
    var token = await getToken();
    if (token != null) {
      await addToken(token);
    }
    return token;
  }
}
