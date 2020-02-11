
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:yumnak/models/user.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user obj based in FairbaseUser
  User _userFromFirebaseUser(FirebaseUser user){
  return user != null ? User(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }


  // sign in anon
  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

// register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      print(result);
      FirebaseUser user = result.user;

        await user.sendEmailVerification();
       // bool b = user.isEmailVerified;

      User u = _userFromFirebaseUser(user);
      var uid = u.uid;
      return uid;

    }
    catch (e) {

      if (e.toString() == "PlatformException(ERROR_EMAIL_ALREADY_IN_USE, The email address is already in use by another account., null)"){
        Fluttertoast.showToast(
            msg: "البريد الإلكتروني مستخدم",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 20,
            backgroundColor: Colors.red[100],
            textColor: Colors.red[800]
        );
      }
      if (e.toString() == "PlatformException(ERROR_INVALID_EMAIL, The email address is badly formatted., null)"){
        Fluttertoast.showToast(
            msg: "البريد الإلكتروني غير صحيح",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 20,
            backgroundColor: Colors.red[100],
            textColor: Colors.red[800]
        );}


      print(e.toString());
        print("HI");
      return null;

  }
  }

// sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      bool b= user.isEmailVerified;
      if (b == true){
        User u =_userFromFirebaseUser(user);
        var uid= u.uid;
        return uid;
      }else{
        Fluttertoast.showToast(
            msg: ("الرجاء تفعيل الحساب عن طريق البريد الإلكتروني"),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 20,
            backgroundColor: Colors.red[100],
            textColor: Colors.red[800]
        );
        return null;
      }


    } catch (e) {
      print("hiiiiii");
      if(e.toString() == "PlatformException(ERROR_WRONG_PASSWORD, The password is invalid or the user does not have a password., null)"){
        Fluttertoast.showToast(
            msg: ("كلمة المرور غير صحيحة"),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 20,
            backgroundColor: Colors.red[100],
            textColor: Colors.red[800]
        );}

      if(e.toString() == "PlatformException(ERROR_USER_NOT_FOUND, There is no user record corresponding to this identifier. The user may have been deleted., null)"){
        Fluttertoast.showToast(
            msg: ("البريد الإلكتروني غير موجود"),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 20,
            backgroundColor: Colors.red[100],
            textColor: Colors.red[800]
        );}
      if(e.toString() == "PlatformException(ERROR_INVALID_EMAIL, The email address is badly formatted., null)"){
        Fluttertoast.showToast(
            msg: ("البريد الإلكتروني غير صحيح"),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 20,
            backgroundColor: Colors.red[100],
            textColor: Colors.red[800]
        );}

      print(e.toString());
      return null;
    }
  }

// sign out
Future signOut() async {
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return "Could not sign out";
    }
}

  Future sendPasswordResetEmail(String email) async {
    try{
      await _auth.sendPasswordResetEmail(email: email);
      Fluttertoast.showToast(
          msg: "تم إرسال رابط تغير كلمة المرور إليك",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 25,
          backgroundColor: Colors.lightBlueAccent,
          textColor: Colors.white
      );
      return  null;
    }catch(e){
      if(e.toString() == "PlatformException(ERROR_INVALID_EMAIL, The email address is badly formatted., null)"){
        Fluttertoast.showToast(
            msg: ("البريد الإلكتروني غير صحيح"),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 20,
            backgroundColor: Colors.red[100],
            textColor: Colors.red[800]
        );
      }
      if(e.toString() == "PlatformException(ERROR_USER_NOT_FOUND, There is no user record corresponding to this identifier. The user may have been deleted., null)"){
        Fluttertoast.showToast(
            msg: ("البريد الإلكتروني غير موجود"),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 20,
            backgroundColor: Colors.red[100],
            textColor: Colors.red[800]
        );
      }
      print(e.toString());
   return "."; }

  }


}