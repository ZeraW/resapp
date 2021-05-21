import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:resapp/models/db_model.dart';
import 'package:resapp/server/auth.dart';
import 'package:resapp/server/database_api.dart';
import 'package:resapp/ui_widget/textfield_widget.dart';
import 'package:resapp/utils/dimensions.dart';
import 'package:resapp/utils/utils.dart';

class ProfileScreen extends StatefulWidget {
  UserModel user;

  ProfileScreen(this.user);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _typeController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
String _nameError='',_pwError='';

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user.firstName! + " " + widget.user.lastName!;
    _phoneController.text = widget.user.phone!;
    _typeController.text = widget.user.type!;
    _passwordController.text = widget.user.password!;

  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text('Profile'),),
      body: SingleChildScrollView(
        child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.getWidth(10)),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(Dimensions.getWidth(13)),
                        child: Container(
                          height: Dimensions.getWidth(26),
                          width: Dimensions.getWidth(26),
                          child: widget.user.logo != null
                              ? CachedNetworkImage(
                                  imageUrl: widget.user.logo!,
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error))
                              : Icon(
                                  Icons.person,
                                  size: 70,
                                  color: Colors.white,
                                ), // replace
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Dimensions.getHeight(3.5),
                    ),
                    TextFormBuilder(
                      hint: "Name",
                      enabled: true,
                      controller: _nameController,
                    ),
                    SizedBox(
                      height: Dimensions.getHeight(3.0),
                    ),
                    TextFormBuilder(
                      hint: "Email",
                      keyType: TextInputType.number,
                      enabled: false,
                      controller: _phoneController,
                    ),
                    SizedBox(
                      height: Dimensions.getHeight(3.0),
                    ),
                    TextFormBuilder(
                      hint: "Password",
                      keyType: TextInputType.text,
                      isPassword: true,
                      enabled: true,
                      controller: _passwordController,
                    ),
                    SizedBox(
                      height: Dimensions.getHeight(3.0),
                    ),
                    TextFormBuilder(
                      hint: "Account Type",
                      keyType: TextInputType.text,
                      enabled: false,
                      controller: _typeController,
                    ),
                    SizedBox(
                      height: Dimensions.getHeight(1.0),
                    ),


                    Container(
                      margin: EdgeInsets.only(top: Dimensions.getHeight(2)),
                      height: Dimensions.getHeight(7.0),
                      width: Dimensions.getWidth(65),
                      child: ElevatedButton(
                        onPressed: () async {
                          _editProfile();
                        },
                        style: ButtonStyle(
                            backgroundColor: MyColors.materialColor(Colors.amberAccent),
                            shape: MyColors.materialShape(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)))),
                        child: Text(
                          "Edit Profile",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: Dimensions.getWidth(4.0),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Dimensions.getHeight(3.0),
                    ),

                  ],
                ),
              ),
      ),
    );
  }

  _editProfile() async {
    String firstName = _nameController.text;
    String password = _passwordController.text;

    if (firstName == null || firstName.isEmpty) {
      _nameError = "Please enter first name";
      setState(() {
      });
    }else if (password == null || password.isEmpty || password.length<5) {
      clear();
      _pwError = "Please enter Valid Password";
      setState(() {
      });
    }else {
      clear();
      UserModel newUser = UserModel(
          id: widget.user.id,
          firstName: firstName,
          lastName: '',
          password: password,
          phone: widget.user.phone,
          logo: widget.user.logo,
          type: widget.user.type,restaurantId: widget.user.restaurantId);

      if(widget.user.firstName != firstName || widget.user.password !=password){
        AuthService().changePassword(password==widget.user.password?null:password,()async{
          await DatabaseService().updateUserData(user: newUser);
        });
      }



    }
  }

  void clear() {
    setState(() {
      _pwError = "";
      _nameError = "";

    });
  }
}
