import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:resapp/ui_screens/splash.dart';
import 'package:resapp/utils/utils.dart';
import 'package:bot_toast/bot_toast.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Restaurant App',
      theme: MyTheme().buildLightTheme(),
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      home: SplashScreen(),
    );
  }
}
