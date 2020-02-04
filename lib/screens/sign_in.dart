import 'package:flutter/material.dart';
import 'package:yumnak/screens/authenticate.dart';
import 'package:yumnak/services/auth.dart';

class SignIn extends StatefulWidget {


  final Function toggleView;
  SignIn({this.toggleView});


  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService  _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email="";
  String password="";
  String error="";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text("Sign in"),
          actions: <Widget>[
            FlatButton.icon(
                onPressed: (){widget.toggleView();},
                icon: Icon(Icons.person), label: Text("Register"))
          ],
    ),
      body:
        Container(
          padding: EdgeInsets.symmetric(vertical: 20,horizontal: 50),
          child: Form(
            key: _formKey,  //for validation
            child: Column(
              children: <Widget>[
                SizedBox(height: 20),
                TextFormField(
                  validator: (val) => val.isEmpty ? "Enter an email" : null,  //null means valid email
                  onChanged: (val){
                    setState(() => email=val);
                  },

                ),

                SizedBox(height: 20),
                TextFormField(
                  validator: (val) => val.length < 6 ? "enter a password 6+ chars long" : null,  //null means valid password
                  onChanged: (val){ setState(() => password =val);},
                  obscureText: true,
                ),

                SizedBox(height: 20),
                RaisedButton(
                  child: Text("Sign in"),
                  onPressed: () async {
                    if (_formKey.currentState.validate()){
                      dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                      if (result == null ){
                        setState(() => error= 'could not sign in with those credintials');
                      }
                      // } else{print("signed in"); }
                    }
                  },
                ),
                SizedBox(height: 20),
                Text(error, style: TextStyle(color: Colors.red, fontSize: 14),)

              ],
            ),
          )
        )






    );
  }
}
