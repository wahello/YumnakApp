
import 'package:firebase_auth/firebase_auth.dart';
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

      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      print(result);
      FirebaseUser user = result.user;
      User u =_userFromFirebaseUser(user);
      var uid= u.uid;
      return uid;

  }

// sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      User u =_userFromFirebaseUser(user);
      var uid= u.uid;
      return uid;
    } catch (e) {
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
      return null;
    }
}

  Future sendPasswordResetEmail(String email) async {
      return await _auth.sendPasswordResetEmail(email: email);
  }


}