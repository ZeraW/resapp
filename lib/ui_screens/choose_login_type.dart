import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:resapp/server/auth_manage.dart';
import 'package:resapp/utils/dimensions.dart';
import 'package:resapp/utils/utils.dart';
import 'package:resapp/wrapper.dart';

class RootScreen extends StatefulWidget {
  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<AuthManage>(builder: (context, auth, child) {
        return WillPopScope(
            onWillPop: () async {
              // You can do some work here.
              // Returning true allows the pop to happen, returning false prevents it.
              auth.onBackPressed();
              return false;
            }, child: auth.currentWidget());
      }),
    );
  }
}

class ChooseLoginType extends StatefulWidget {
  @override
  _ChooseLoginTypeState createState() => _ChooseLoginTypeState();
}

class _ChooseLoginTypeState extends State<ChooseLoginType> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors().mainColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: Dimensions.getHeight(6),
            ),
            Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  height: Dimensions.getHeight(20),
                  width: Dimensions.getWidth(80),
                  fit: BoxFit.contain,
                )),
            Spacer(),
            Container(
              child: Column(
                children: [
                  Text(
                    'Choose Account Type',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: Dimensions.getWidth(7)),
                  ),
                  SizedBox(height: 15,),
                  GestureDetector(
                    onTap: () async{
                     /* Provider.of<AuthManage>(context, listen: false)
                          .toggleWidgets(currentPage: 1, type: "User",color: Colors.amber);*/

                      await FirebaseAuth.instance.signInAnonymously();
                    },

                    child: Container(
                      width: Dimensions.getWidth(70),
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.amber,borderRadius: BorderRadius.circular(8)),
                      margin: EdgeInsets.symmetric(vertical: Dimensions.getHeight(1.5)),

                      child: Text(
                        'User',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: Dimensions.getWidth(6)),
                      ),
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        Provider.of<AuthManage>(context, listen: false)
                            .toggleWidgets(currentPage: 1, type: "admin",color: Colors.green);
                      },
                      child: Container(
                        width: Dimensions.getWidth(70),
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.green,borderRadius: BorderRadius.circular(8)),
                        margin: EdgeInsets.symmetric(vertical: Dimensions.getHeight(1.5)),

                        child: Text(
                          'Admin',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: Dimensions.getWidth(6)),
                        ),
                      )),
                  GestureDetector(
                      onTap: () {
                        Provider.of<AuthManage>(context, listen: false)
                            .toggleWidgets(currentPage: 1, type: "Restaurant",color:Colors.blue );
                      },
                      child: Container(
                        width: Dimensions.getWidth(70),
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.blue,borderRadius: BorderRadius.circular(8)),
                        margin: EdgeInsets.symmetric(vertical: Dimensions.getHeight(1.5)),

                        child: Text(
                          'Restaurant',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: Dimensions.getWidth(6)),
                        ),
                      )),
                ],
              ),
            ),
            Spacer(),

          ],
        ));
  }
}
