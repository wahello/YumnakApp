import 'package:flutter/material.dart';
import 'package:yumnak/models/user.dart';
import 'package:yumnak/screens/HomePage.dart';
import 'package:yumnak/screens/Main.dart';
import 'package:provider/provider.dart';
import 'package:yumnak/services/auth.dart';
import 'package:yumnak/services/location_service.dart';




void main() => runApp(MyApp());
@override
void initState() {
  LocationService().locationStream;
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    initState();
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
         home: Main(),
        //Wrapper(),
      ),


    );

  }


  }




