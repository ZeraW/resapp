import 'package:flutter/material.dart';
import 'package:resapp/models/db_model.dart';
import 'package:resapp/server/auth.dart';

class HomeUser extends StatelessWidget {
   UserModel user;


   HomeUser(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User')),
      body: Center(child: ElevatedButton(onPressed: ()async{
        await AuthService().signOut();
      },child: Text('sign out'),),),
    );
  }
}
