import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resapp/server/auth.dart';
import 'package:resapp/utils/dimensions.dart';
import 'package:resapp/utils/utils.dart';
import '../wrapper.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double x = 0;

  @override
  void initState() {
    super.initState();
    startSplash();
  }

  void startSplash() {
    Future.delayed(Duration(milliseconds: 2500), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(
          settings: RouteSettings(name: 'Wrapper',),
          builder: (_) =>
      StreamProvider<User?>.value(
          initialData:null, value: AuthService().user, child: Wrapper())));
    });
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.callAtBuild(context: context);

    return Scaffold(
      backgroundColor: Color(0xff291749),
      body: Center(
        child: Image.asset(
          "assets/images/logo.png",
          fit: BoxFit.contain,
          height: Dimensions.getWidth(80.0),
          width: Dimensions.getWidth(80.0),
        ),
      ),
    );
  }
}


