import 'package:flutter/material.dart';
import 'package:resapp/ui_screens/choose_login_type.dart';
import 'package:resapp/ui_screens/login.dart';
import 'package:resapp/ui_screens/register.dart';


class AuthManage extends ChangeNotifier {
  int? pageState = 0;
  String? type = '';
  Color? color = Colors.amber;

  void toggleWidgets({int? currentPage, String? type,Color? color}) {
    this.pageState = currentPage;
    this.type = type;
    this.color = color;
    notifyListeners();
  }

  void onBackPressed() {
    if (pageState == 1) {
      this.pageState = 0;
      notifyListeners();
    } else if (pageState == 2) {
      this.pageState = 1;
      this.type = type;
      notifyListeners();
    } else {
      notifyListeners();
    }
  }

  Widget currentWidget() {
    if (pageState == 1) {
      return LoginScreen(type: type,color: color,isAnonymous: false,);
    } else if (pageState == 2) {
      return RegisterScreen(type: type,color: color,isAnonymous: false,);
    } else {
      return ChooseLoginType();
    }
  }
}
