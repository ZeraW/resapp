import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:resapp/models/db_model.dart';
import 'package:firebase_core/firebase_core.dart';

/*
import 'package:toast/toast.dart';
*/
import 'database_api.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on firebase user
  UserModel _userFromFirebaseUser(User user) {return user != null ? UserModel(id: user.uid) : UserModel();}

  // auth change user stream
  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  // sign in with email and password
  Future signInWithEmailAndPassword({BuildContext? context, required String email, required String password}) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        /*Toast.show("No user found for that phone number.", context,
            backgroundColor: Colors.redAccent,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM);*/
        Fluttertoast.showToast(
            msg: "No user found for that phone number.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      } else if (e.code == 'wrong-password') {
       /* Toast.show("Wrong password provided for that user.", context,
            backgroundColor: Colors.redAccent,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM);*/

        Fluttertoast.showToast(
            msg: "Wrong password provided for that user.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );

      }
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword({BuildContext? context,required UserModel newUser,File? userImage,String? imageUrl}) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: '${newUser.phone}.${newUser.type}', password: newUser.password!);
/*
      print('XDA : ' + result.user!.uid);
*/

      User fbUser = result.user!;
      newUser.id = fbUser.uid;
      await DatabaseService().updateUserData(user: newUser);

      if (userImage!=null) {
        newUser.logo =await (DatabaseService().uploadImageToStorage(id:'users/${fbUser.uid}',file: userImage));
        await DatabaseService().updateUserData(user: newUser);
      }



      return _userFromFirebaseUser(fbUser);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        /*Toast.show("The password provided is too weak.", context,
            backgroundColor: Colors.redAccent,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM);*/

        Fluttertoast.showToast(
            msg: "The password provided is too weak.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );

      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        /*Toast.show("The account already exists for that email.", context,
            backgroundColor: Colors.redAccent,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM);*/

        Fluttertoast.showToast(
            msg: "The account already exists for that email.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );


      }
    } catch (e) {
      print(e);
    }
  }

  /*// register with email and password
  Future registerRestaurant({BuildContext? context,required UserModel newUser}) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: '${newUser.phone}.${newUser.type}', password: newUser.password!);
      User fbUser = result.user!;
      newUser.id = fbUser.uid;
      await DatabaseService().updateUserData(user: newUser);
      Navigator.pop(context!);
      return false;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        *//*Toast.show("The password provided is too weak.", context,
            backgroundColor: Colors.redAccent,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM);*//*

        Fluttertoast.showToast(
            msg: "The password provided is too weak.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );

      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
            msg: "The account already exists for that email.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    } catch (e) {
      print(e);
    }
  }*/


   Future registerRestaurant({BuildContext? context,required UserModel newUser}) async {
    FirebaseApp app = await Firebase.initializeApp(
        name: 'Secondary', options: Firebase.app().options);
    try {
      UserCredential userCredential = await FirebaseAuth.instanceFor(app: app)
          .createUserWithEmailAndPassword(
          email: '${newUser.phone}.${newUser.type}', password: newUser.password!);
      User fbUser = userCredential.user!;
      newUser.id = fbUser.uid;
      await DatabaseService().updateUserData(user: newUser);
      await app.delete();
      Navigator.pop(context!);

    }
    on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        /*Toast.show("The password provided is too weak.", context,
            backgroundColor: Colors.redAccent,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM);*/

        Fluttertoast.showToast(
            msg: "The password provided is too weak.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );

      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
            msg: "The account already exists for that email.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
        await app.delete();
      }
    } catch (e) {
      await app.delete();
      print(e);
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
