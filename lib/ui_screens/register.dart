import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:resapp/models/db_model.dart';
import 'package:resapp/server/auth.dart';
import 'package:resapp/server/auth_manage.dart';
import 'package:resapp/ui_widget/textfield_widget.dart';
import 'package:resapp/utils/dimensions.dart';
import 'package:resapp/utils/utils.dart';
/*import 'package:toast/toast.dart';*/

import 'login.dart';

class RegisterScreen extends StatefulWidget {
 final String? type;
 final Color? color;
  RegisterScreen({this.type,this.color});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _lastNameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _repasswordController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();

  String _phoneError = "";
  String _nameError = "";
  String _lastNameError = "";
  String _passError = "";
  String _rePassError = "";

  File? _storedImage;

  @override
  Widget build(BuildContext context) {
    Future<void> _takePicture() async {
      final imageFile = await ImagePicker().getImage(source: ImageSource.gallery, imageQuality: 80);

      if (imageFile == null) {
        return;
      }
      setState(() {
        _storedImage = File(imageFile.path);
        print('_storedImage');

        print(_storedImage);
      });
    }

    return Scaffold(
      backgroundColor: MyColors().mainColor,
      appBar: new AppBar(
          centerTitle: true,
          elevation: 0.0,
          leading: GestureDetector(
            onTap: () => Provider.of<AuthManage>(context, listen: false)
                .toggleWidgets(currentPage: 1, type: widget.type,color: widget.color),
            child: Icon(
              Icons.chevron_left,
              color: Colors.white,
              size: Dimensions.getWidth(8.0),
            ),
          ),
          backgroundColor: MyColors().mainColor,
          title: Text(
            "Sign Up",
            style: TextStyle(
                color: Colors.white, fontSize: Dimensions.getWidth(4.5)),
          )),
      body: Container(
        height: Dimensions.getHeight(100),
        padding: EdgeInsets.symmetric(
            vertical: Dimensions.getHeight(2),
            horizontal: Dimensions.getWidth(4)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: GestureDetector(
                  onTap: _takePicture,
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(Dimensions.getWidth(13)),
                    child: Container(
                      height: Dimensions.getWidth(26),
                      width: Dimensions.getWidth(26),
                      color: Colors.grey,
                      child: _storedImage != null
                          ? Image.file(_storedImage!)
                          : Icon(
                              Icons.person,
                              size: 70,
                              color: Colors.white,
                            ), // replace
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: Dimensions.getHeight(3.5),
              ),
              TextFormBuilder(
                hint: "First Name",
                controller: _nameController,
                errorText: _nameError,
              ),
              SizedBox(
                height: Dimensions.getHeight(3.0),
              ),
              TextFormBuilder(
                hint: "Last Name",
                controller: _lastNameController,
                errorText: _lastNameError,
              ),
              SizedBox(
                height: Dimensions.getHeight(3.0),
              ),
              TextFormBuilder(
                hint: "Email",
                keyType: TextInputType.emailAddress,
                controller: _phoneController,
                errorText: _phoneError,
              ),
              SizedBox(
                height: Dimensions.getHeight(3.0),
              ),
              TextFormBuilder(
                hint: "Password",
                isPassword: true,
                controller: _passwordController,
                errorText: _passError,
              ),
              SizedBox(
                height: Dimensions.getHeight(3.0),
              ),
              TextFormBuilder(
                hint: "Confirm Password",
                isPassword: true,
                controller: _repasswordController,
                errorText: _rePassError,
              ),
              SizedBox(
                height: Dimensions.getHeight(3.0),
              ),
              SizedBox(
                height: Dimensions.getHeight(7.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                              (states) => widget.color!)),
                  onPressed: () {
                    _reg(context);
                  },
                  child: Text(
                    "SIGN UP",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: Dimensions.getWidth(4.0),
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _reg(BuildContext context) async {
    String firstName = _nameController.text;
    String lastName = _lastNameController.text;
    String phone = _phoneController.text.replaceAll(new RegExp(r"\s+\b|\b\s"), "");
    String password = _passwordController.text;
    String passwordConfirm = _repasswordController.text;

    if (firstName == null || firstName.isEmpty) {
      _nameError = "Please enter first name";
      setState(() {

      });
    } else if (lastName == null || lastName.isEmpty) {
      clear();
      _lastNameError = "Please enter last name";
      setState(() {

      });
    }
    else if (phone == null || phone.isEmpty) {
      clear();
      _phoneError = "Please enter email Address";
      setState(() {

      });
    }else if(!isEmail(phone)){
      clear();
      _phoneError = "Please enter Correct email Address";
      setState(() {

      });
    } else if (password == null || password.isEmpty) {
      clear();
      _passError = "Please enter password";
      setState(() {

      });
    } else if (passwordConfirm == null || passwordConfirm.isEmpty) {
      clear();
      _rePassError = "Please enter Password confirm";
      setState(() {

      });
    }else if(password.length<6){
      clear();
      _passError = "Password must be 6 or more character";
    } else if (password != passwordConfirm) {
      clear();
      _passError = "Passwords don't matach";
      _rePassError = "Passwords don't matach";
      setState(() {

      });
    } else {
      clear();
      UserModel newUser = UserModel(
          firstName: firstName,
          lastName: lastName,
          password: password,
          phone: phone,
          type: widget.type);
      await AuthService().registerWithEmailAndPassword(
          context: context, newUser: newUser, userImage: _storedImage);
    }
  }
  bool isEmail(String em) {

    String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(em);
  }
  void clear() {
    setState(() {
      _phoneError = "";
      _nameError = "";
      _lastNameError = "";
      _passError = "";
      _rePassError = "";
    });
  }
}
