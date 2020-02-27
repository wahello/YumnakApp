import 'package:flutter/material.dart';
import 'package:yumnak/screens/SignIn_Cust.dart';
import 'package:yumnak/screens/SignIn_SP.dart';
import 'package:yumnak/services/location_service.dart';


class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.grey[200] ,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
                      child: Image(image:  AssetImage("assets/logo1.png"), width: 250.0, height: 250.0)
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(70.0, 0.0, 5.0, 25.0),
              child: Text( 'الي ماتعداك',
                  style: TextStyle(
                    color: Colors.lightBlueAccent, fontWeight: FontWeight.bold, fontSize: 20.0, fontFamily: 'Montserrat',)
              ),
            ),

            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(160.0, 1.0, 5.0, 10.0),
              child: Text( '..أنا',
                  style: TextStyle(color: Colors.lightBlueAccent, fontWeight: FontWeight.bold, fontSize: 25.0, fontFamily: 'Montserrat',)
              ),
            ),

            Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ButtonTheme(minWidth: 160.0, height: 120.0,
                        child: RaisedButton(color: Colors.white,
                          onPressed: () {
                           Navigator.push(context, new MaterialPageRoute(
                                builder: (context) => SignIn_SP()
                            ));
                            },
                          child: Text("مقدم خدمة",  style: TextStyle(
                            color: Colors.grey[600], fontWeight: FontWeight.bold,fontSize: 24.0, fontFamily: 'Montserrat', )),
                        )
                    ),
                    ButtonTheme(
                      minWidth: 160.0, height: 120.0,
                      child: RaisedButton(
                        color: Colors.white,
                        onPressed: () {
                          Navigator.push(context, new MaterialPageRoute(
                              builder: (context) => SignIn_Cust(),
                          ));
                          },
                        child: Text("أبحث عن خدمة  ", style: TextStyle(
                          color: Colors.grey[600],fontWeight: FontWeight.bold,fontSize: 24.0, fontFamily: 'Montserrat',
                        ),),
                      ),
                    )

                  ],
                )),

           ],
        ),

    );
  }
}
