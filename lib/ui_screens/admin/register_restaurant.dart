
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resapp/models/db_model.dart';
import 'package:resapp/server/auth.dart';
import 'package:resapp/server/auth_manage.dart';
import 'package:resapp/ui_widget/textfield_widget.dart';
import 'package:resapp/utils/dimensions.dart';
import 'package:resapp/utils/utils.dart';

class CreateRestaurantAccountScreen extends StatefulWidget {
 final String? type;
 final Color? color;
 final String restaurantId,restaurantImage;
  CreateRestaurantAccountScreen({this.type,this.color,required this.restaurantId, required this.restaurantImage});

  @override
  _CreateRestaurantAccountScreenState createState() => _CreateRestaurantAccountScreenState();
}

class _CreateRestaurantAccountScreenState extends State<CreateRestaurantAccountScreen> {
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: MyColors().mainColor,
      appBar: new AppBar(
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: MyColors().mainColor,
          title: Text(
            "Create Restaurant Account",
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
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(Dimensions.getWidth(13)),
                  child: Container(
                    height: Dimensions.getWidth(26),
                    width: Dimensions.getWidth(26),
                    color: Colors.grey,
                    child: Image.network(widget.restaurantImage), // replace
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
                              (states) => Colors.blue)),
                  onPressed: () {
                    _reg(context);
                  },
                  child: Text(
                    "Create Account",
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
    } else if (phone == null || phone.isEmpty) {
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
      setState(() {

      });
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
          logo: widget.restaurantImage,
          restaurantId: widget.restaurantId,
          phone: phone,
          type: 'restaurant');
      await AuthService().registerRestaurant(
          context: context, newUser: newUser );
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
