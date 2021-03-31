import 'package:flutter/material.dart';

import 'dimensions.dart';

class MyColors {
  Color mainColor = Color(0xff291749);
  Color pinkColor = Color(0xffF4DEFD);
  Color accentColor = Colors.amber;
  Color greenColor = Color(0xff84ae1a);
  Color btnColor = Color(0xff373951);
  Color offWhite = Color(0xffF1F1F1);
  Color textColor = Color(0xff373951);
  Color backGroundColor = Color(0xffd8dbff);
  Color black = Colors.black;
  Color white = Colors.white;

  static MaterialStateProperty<Color> materialColor(var color) {
    return MaterialStateProperty.all<Color>(color);
  }

  static MaterialStateProperty<OutlinedBorder> materialShape(var shape) {
    return MaterialStateProperty.all<OutlinedBorder>(shape);
  }
}

class EnStrings {
  String appName = "BookingApp";
}

class MyTheme {
  ThemeData buildLightTheme() {
    final ThemeData base = ThemeData.light();
    return base.copyWith(
        textTheme: TextTheme(
          //title
          headline6: TextStyle(
            fontWeight: FontWeight.w400,
            color: MyColors().mainColor,
          ),
          headline1: TextStyle(
            fontWeight: FontWeight.w400,
            color: MyColors().mainColor,
          ),
          headline2: TextStyle(
            fontWeight: FontWeight.w400,
            color: MyColors().mainColor,
          ),
          headline3: TextStyle(
            fontWeight: FontWeight.w400,
            color: MyColors().mainColor,
          ),
          headline4: TextStyle(
            fontWeight: FontWeight.w400,
            color: MyColors().mainColor,
          ),
          headline5: TextStyle(
            fontWeight: FontWeight.w400,
            color: MyColors().mainColor,
          ),
          bodyText1: TextStyle(
            fontWeight: FontWeight.w400,
            color: MyColors().textColor,
          ),
          bodyText2: TextStyle(
            fontWeight: FontWeight.w400,
            color: MyColors().textColor,
          ),
          button: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          subtitle1: TextStyle(
            fontWeight: FontWeight.w400,
            color: MyColors().textColor,
          ),
          subtitle2: TextStyle(
            fontWeight: FontWeight.w400,
            color: MyColors().textColor,
          ),


        ),
        primaryColor: MyColors().mainColor,
        accentColor: MyColors().accentColor,
        scaffoldBackgroundColor: MyColors().mainColor,
        cardColor: Colors.white,
        textSelectionTheme: TextSelectionThemeData(
            selectionColor: Colors.amberAccent,
            selectionHandleColor: Colors.grey),
        errorColor: MyColors().greenColor,
        appBarTheme: _appBarTheme());
  }

  AppBarTheme _appBarTheme() {
    return AppBarTheme(
      elevation: 0.0,
      centerTitle: true,
      textTheme: TextTheme(
          headline6: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w600,
        color: MyColors().white,
      )),
      color: MyColors().mainColor,
      iconTheme: IconThemeData(
        color: MyColors().white,
      ),
    );
  }


}

class MyStyle{
  TextStyle whiteStyleW600(){
    return TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: Dimensions.getWidth(3.6));
  }
  TextStyle blackStyleW600(){
    return TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w600,
        fontSize: Dimensions.getWidth(4.5));
  }
  TextStyle textStyleBold(){
    return TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: Dimensions.getWidth(3.6));
  }
  TextStyle bigBold(){
    return TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: Dimensions.getWidth(5));
  }
}

class OnClick extends StatelessWidget {
  final Widget child;
  final Function() onTap;
  final Color? color;
  OnClick({required this.child,this.color,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
        color: color!=null ? color : MyColors().mainColor,
        child: InkWell(onTap: onTap,child:child ,));
  }
}
