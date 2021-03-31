import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:resapp/models/db_model.dart';
import 'package:resapp/server/auth.dart';
import 'package:resapp/server/database_api.dart';
import 'package:resapp/ui_screens/user/user_home.dart';
import 'package:resapp/utils/dimensions.dart';
import 'package:resapp/utils/utils.dart';

import 'admin/admin_home.dart';
import 'restaurant/restaurant_home.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
   UserModel? user;


  @override
  Widget build(BuildContext context) {
    final snapshot = Provider.of<DocumentSnapshot?>(context);

    if (snapshot != null) {
      user = UserModel.fromJson(snapshot.data()!);
    }

    List<Map<String, Widget>> homeWidget = user!=null ?[
      {'user': HomeUser((user!=null ? user :UserModel())!)},
      {'admin': HomeAdmin((user!=null ? user :UserModel())!)},
      {'restaurant': MultiProvider(providers: [
        StreamProvider<DocumentSnapshot?>.value(
            initialData: null,
            value: DatabaseService().getRestaurantById(user!.restaurantId!))
      ],child:HomeRestaurant((user!=null ? user :UserModel())!))}
    ]:[];



    return snapshot != null && user!=null
        ? homeWidget
            .firstWhere((element) => element.keys.first == user!.type)
            .values
            .first
        : CircularProgressIndicator();
  }
}


