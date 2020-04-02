import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yumnak/screens/HomePage.dart';
import 'package:yumnak/screens/SP_HomePage.dart';
import 'package:yumnak/services/auth.dart';
import 'package:yumnak/services/location_service.dart';
import 'models/user.dart';
import 'screens/Main.dart';

class YumnakApp extends StatelessWidget {
   YumnakApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    initState();
    return MultiProvider(
      providers: [
        StreamProvider<User>.value(
          value: AuthService().user,
        ),
        //StreamProvider<FirebaseUser>.value(value: AuthService().authState()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LandingPage(),
        //Wrapper(),
      ),
    );
  }
}

void initState() {
  LocationService().locationStream;
  spReference=_firebaseRef.child('Service Provider').orderByChild('uid');
  cuReference=_firebaseRef.child('Customer').orderByChild('uid');
}
var spReference;
var _firebaseRef =FirebaseDatabase.instance.reference();
var cuReference;

Map data1 ;
var spUid;
Map data2 ;
var custUid;
List customers=[];
List SP=[];
var current;
class LandingPage extends StatelessWidget {

   LandingPage({Key key}) : super(key: key);
  @override


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: AuthService().authState(),
          builder: (context, snapshot) {

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(), );
            }  else
              if(snapshot.data!=null){
              current=snapshot.data.uid;
              return  StreamBuilder(
                stream: spReference.onValue,
                builder: (context,snapshot){
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator(), );
                  }else
                    data1 = snapshot.data.snapshot.value;
                  List spItem = [];
                  data1.forEach((index, data1) => spItem.add({"key": index, ...data1}));

                  for(var i=0; i<spItem.length; i++){
                    SP.add(spItem.elementAt(i)['uid']);}

                  return StreamBuilder(
                    stream: cuReference.onValue,
                    builder: (context, snapshot){
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator(), );
                      }else
                        data2 = snapshot.data.snapshot.value;
                      List custItem = [];
                      data2.forEach((index, data2) => custItem.add({"key": index, ...data2}));

                      for(var i=0; i<custItem.length; i++){
                        customers.add((custItem.elementAt(i)['uid']).toString());}



                      if(SP.contains(current.toString())){
                        return SP_HomePage(current.toString());
                      }
                      if(customers.contains(current.toString()))
                        return HomePage(current.toString());
                      return Main();
                    },
                  );
                },
              );
              } else return Main();

            /*else if (snapshot.hasData) {

              return SP_HomePage(snapshot.data.uid);
            } else {
              return Main();
            }*/
          }),
    );
  }
}