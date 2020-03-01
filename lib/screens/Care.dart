import 'package:flutter/material.dart';
import 'availableSP.dart';


class Care extends StatefulWidget {

  dynamic uid;
  Care(dynamic u){uid=u;}

  @override
  _CareState createState() => _CareState(uid);
}

class _CareState extends State<Care> {

  static dynamic uid;
  _CareState(dynamic u){uid=u; print('Care: $uid');}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          //automaticallyImplyLeading: false,     //عشان يروح سهم الرجوع
          backgroundColor: Colors.grey[200],
          iconTheme: IconThemeData(color: Colors.black38),
        ),


        resizeToAvoidBottomPadding: false,
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 10.0),
                child: Text('مجالسة', style: TextStyle(color: Colors.lightBlueAccent, fontSize: 40.0, fontWeight: FontWeight.bold, fontFamily: "Montserrat"),),
              ),

              SizedBox(height:10.0),
              Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SizedBox(
                          width: 130.0, height: 130.0,
                          child: RaisedButton(color: Colors.grey[400],
                            onPressed: () {
                              Navigator.push(context, new MaterialPageRoute(
                                  builder: (context) => availableSP(uid, "كبار السن")
                              ));
                            },
                            child: Text("كبار السن",  textAlign: TextAlign.center ,style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold,fontSize: 24.0, fontFamily: 'Montserrat', )),
                          )
                      ),
                      SizedBox(
                        width: 130.0, height: 130.0,
                        child: RaisedButton(
                          color: Colors.tealAccent[100],
                          onPressed: () {
                            Navigator.push(context, new MaterialPageRoute(
                                builder: (context) => availableSP(uid, "مربية أطفال")
                            ));
                          },
                          child: Text("مربية أطفال" ,textAlign: TextAlign.center ,style: TextStyle(
                            color: Colors.black,fontWeight: FontWeight.bold,fontSize: 24.0, fontFamily: 'Montserrat',
                          ),),

                        ),
                      )
                    ],
                  )
              ),


            ])


    );
  }
}
