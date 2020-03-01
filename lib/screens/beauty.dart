import 'package:flutter/material.dart';
import 'availableSP.dart';

class beauty extends StatefulWidget {

  dynamic uid;
  beauty(dynamic u){uid=u;}

  @override
  _beautyState createState() => _beautyState(uid);
}

class _beautyState extends State<beauty> {

  static dynamic uid;
  _beautyState(dynamic u){uid=u; print('beauty: $uid');}

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
                child: Text('تجميل', style: TextStyle(color: Colors.lightBlueAccent, fontSize: 40.0, fontWeight: FontWeight.bold, fontFamily: "Montserrat"),),
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
                                  builder: (context) => availableSP(uid,"شعر")
                              ));
                            },
                            child: Text("شعر",  textAlign: TextAlign.center ,style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold,fontSize: 24.0, fontFamily: 'Montserrat', )),
                          )
                      ),
                      SizedBox(
                        width: 130.0, height: 130.0,
                        child: RaisedButton(
                          color: Colors.tealAccent[100],
                          onPressed: () {
                            Navigator.push(context, new MaterialPageRoute(
                                builder: (context) => availableSP(uid, "مكياج")
                            ));
                          },
                          child: Text("مكياج" ,textAlign: TextAlign.center ,style: TextStyle(
                            color: Colors.black,fontWeight: FontWeight.bold,fontSize: 24.0, fontFamily: 'Montserrat',
                          ),),

                        ),
                      )
                    ],
                  )
              ),
              SizedBox(height:10.0),
              Container(

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      SizedBox(
                        width: 130.0, height: 130.0,
                        child: RaisedButton(
                          color: Colors.green[300],
                          onPressed: () {
                            Navigator.push(context, new MaterialPageRoute(
                                builder: (context) => availableSP(uid, "عناية واسترخاء")
                            ));
                          },
                          child: Text("عناية واسترخاء", textAlign: TextAlign.center ,style: TextStyle(
                            color: Colors.black,fontWeight: FontWeight.bold,fontSize: 24.0, fontFamily: 'Montserrat',
                          ),),
                        ),
                      ),   SizedBox(width:33.0),

                    ],
                  )
              ),

            ])


    );
  }
}
