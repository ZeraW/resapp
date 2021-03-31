import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:resapp/models/db_model.dart';
import 'package:resapp/server/auth.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController.text = widget.user.firstName! + " " + widget.user.lastName!;
    _phoneController.text = widget.user.phone!;
    _typeController.text = widget.user.type!;

  }

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      appBar: AppBar(title: Text('Profile'),),
      body: Padding(
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
                    hint: "First Name",
                    enabled: false,
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
                    hint: "Account Type",
                    keyType: TextInputType.text,
                    enabled: false,
                    controller: _typeController,
                  ),
                  SizedBox(
                    height: Dimensions.getHeight(3.0),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: Dimensions.getHeight(2)),
                    height: Dimensions.getHeight(7.0),
                    width: Dimensions.getWidth(65),
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await AuthService().signOut();
                      },
                      style: ButtonStyle(
                          backgroundColor: MyColors.materialColor(Color(0xffc13001)),
                          shape: MyColors.materialShape(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)))),
                      child: Text(
                        "Log out",
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
    );
  }
}
