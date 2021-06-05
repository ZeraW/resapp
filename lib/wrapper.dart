import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resapp/server/auth_manage.dart';
import 'package:resapp/server/database_api.dart';
import 'models/db_model.dart';
import 'ui_screens/choose_login_type.dart';
import 'ui_screens/home.dart';

class Wrapper extends StatefulWidget {
  static String UID = '';

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    // return either the Home or Authenticate widget
    if (user == null && Wrapper.UID!='temp') {
      return ChangeNotifierProvider(
          create: (context) => AuthManage(), child: RootScreen());
    } else {
      //Wrapper.UID = user.uid;
      return MultiProvider(providers: [
        StreamProvider<UserModel?>.value(
          initialData: UserModel(id: 'temp',firstName: 'temp',phone: '',lastName: '',logo: '',password: '',type: 'User',),
            catchError: (_, __) => null,
            value: DatabaseService().getUserById2)
      ], child: HomeScreen());
    }
  }
}
