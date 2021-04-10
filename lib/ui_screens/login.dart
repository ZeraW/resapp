import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:resapp/server/auth.dart';
import 'package:resapp/server/auth_manage.dart';
import 'package:resapp/ui_widget/textfield_widget.dart';
import 'package:resapp/utils/dimensions.dart';
import 'package:resapp/utils/utils.dart';

class LoginScreen extends StatefulWidget {
  final String? type;
  final Color? color;
  LoginScreen({this.type,this.color});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  String _phoneError = "";
  String _passwordError = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () => Provider.of<AuthManage>(context, listen: false)
                .toggleWidgets(currentPage: 0, type: widget.type,color: widget.color),
            child: Icon(
              Icons.chevron_left,
              color: Colors.white,
              size: Dimensions.getWidth(8.0),
            ),
          ),
          backgroundColor: MyColors().mainColor,
          elevation: 0.0,
          title: Text('Login'),
          centerTitle: true,
        ),
        backgroundColor: MyColors().mainColor,
        body: Container(
          padding: EdgeInsets.symmetric(
              horizontal: Dimensions.isPortrait()
                  ? Dimensions.getWidth(6.0)
                  : Dimensions.getWidth(100.0)),
          child: ListView(
            children: [
              Center(
                child: Image.asset(
                  "assets/images/logo.png",
                  fit: BoxFit.contain,
                  height: Dimensions.getWidth(40.0),
                  width: Dimensions.getWidth(40.0),
                ),
              ),
              SizedBox(
                height: Dimensions.getHeight(4.0),
              ),
              TextFormBuilder(
                controller: _phoneController,
                hint: "Email",
                keyType: TextInputType.emailAddress,
                errorText: _phoneError,
              ),
              SizedBox(
                height: Dimensions.getHeight(3.0),
              ),
              TextFormBuilder(
                controller: _passwordController,
                hint: "Password",
                keyType: TextInputType.visiblePassword,
                isPassword: true,
                errorText: _passwordError,
              ),
              SizedBox(
                height: Dimensions.getHeight(4.0),
              ),
              SizedBox(
                height: Dimensions.getHeight(7.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => widget.color!)),
                  onPressed: () {
                    _login(context);
                  },
                  child: Text(
                    "SIGN IN",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: Dimensions.getWidth(4.0),
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ), //Spacer(),
              SizedBox(
                height: Dimensions.getHeight(4.0),
              ),
             widget.type=='User'? GestureDetector(
                onTap: () {
                  Provider.of<AuthManage>(context, listen: false)
                      .toggleWidgets(currentPage: 2, type: widget.type,color: widget.color);
                },
                child: Center(
                  child: Text(
                    "Sign up new account",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: Dimensions.getWidth(4.0)),
                  ),
                ),
              ):SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  _login(BuildContext context) async {
    String phone =
        _phoneController.text.replaceAll(new RegExp(r"\s+\b|\b\s"), "");
    String password = _passwordController.text;
    if (phone != null &&
        phone.isNotEmpty &&
        password != null &&
        password.isNotEmpty) {
      setState(() {
        _passwordError = '';
        _phoneError = '';
      });
      await AuthService().signInWithEmailAndPassword(
          context: context,
          email: '${_phoneController.text}.${widget.type}',
          password: _passwordController.text);
    } else {
      setState(() {
        if (phone == null || phone.isEmpty) {
          _phoneError = "Enter a valid Email.";
          _passwordError = '';
        } else {
          _passwordError = "Enter a valid password.";
          _phoneError = '';
        }
      });
    }
  }
}
