import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:resapp/models/db_model.dart';
import 'package:resapp/server/database_api.dart';
import 'package:resapp/ui_screens/admin/register_restaurant.dart';
import 'package:resapp/ui_screens/register.dart';
import 'package:resapp/ui_widget/admin/home/admin_card.dart';
import 'package:resapp/ui_widget/drop_down.dart';
import 'package:resapp/ui_widget/my_card.dart';
import 'package:resapp/ui_widget/textfield_widget.dart';
import 'package:resapp/utils/dimensions.dart';
import 'package:resapp/utils/utils.dart';

class ManageAccountsScreen extends StatelessWidget {
  String id,image;

  ManageAccountsScreen({required this.id, required this.image});

  @override
  Widget build(BuildContext context) {
    final mList = Provider.of<List<UserModel>?>(context);

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: MyColors().mainColor,
          title: Text(
            'Manage Accounts',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: Dimensions.getWidth(5)),
          )),
      body: mList != null
          ? ListView(
        children: [
          Center(
            child: Wrap(
              children: mList
                  .map((item) => UsersCard(
                name: '${item.firstName} ${item.lastName}',
                image: item.logo!,
                email: item.phone,
                password: item.password,
              ))
                  .toList()
                  .cast<Widget>(),
            ),
          ),
        ],
      )
          : Text('No data'),
      floatingActionButton: FloatingActionButton(
        heroTag: 'addAccount',
        onPressed: () => _increment(
            context: context, nextId: mList != null ? mList.length + 1 : 0),
        tooltip: 'Increment',
        backgroundColor: Colors.green.withOpacity(0.9),
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }

  void _increment({required BuildContext context, required int nextId}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => CreateRestaurantAccountScreen(
              restaurantId: id,restaurantImage:image,
            )));
  }
}
