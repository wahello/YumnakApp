import 'package:flutter/material.dart';
import 'package:yumnak/screens/register.dart';
import 'package:yumnak/screens/sign_in.dart';

    class Authenticate extends StatefulWidget {
      @override
      _AuthenticateState createState() => _AuthenticateState();
    }



    class _AuthenticateState extends State<Authenticate> {

      bool showSignIn = true;

      void toggleView(){  // we have to call it in onPressed method so we passed it in the parameters
        setState(() => showSignIn = !showSignIn);  // ! gets the revers of whats its currently is
      }


      @override
      Widget build(BuildContext context) {
        if (showSignIn) {return SignIn(toggleView: toggleView);}
        else{ return Register(toggleView: toggleView);}
      }
    }
