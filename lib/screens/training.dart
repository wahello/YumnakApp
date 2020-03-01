import 'package:flutter/material.dart';
import 'package:yumnak/screens/privateTraining.dart';
import 'availableSP.dart';

class training extends StatefulWidget {
  dynamic uid;
  training(dynamic u){uid=u;}

  @override
  _trainingState createState() => _trainingState(uid);
}

class _trainingState extends State<training> {

  static dynamic uid;
  _trainingState(dynamic u){uid=u; print('training: $uid');}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.grey[200],
          iconTheme: IconThemeData(color: Colors.black38),
        ),


        resizeToAvoidBottomPadding: false,
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 10.0),
                child: Text('تعليم وتدريب', style: TextStyle(color: Colors.lightBlueAccent, fontSize: 40.0, fontWeight: FontWeight.bold, fontFamily: "Montserrat"),),
              ),
              SizedBox(height: 10.0),
              Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SizedBox(
                          width: 130.0, height: 130.0,
                          child: RaisedButton(color: Colors.grey[400],
                            onPressed: () {
                              Navigator.push(context, new MaterialPageRoute(
                                  builder: (context) => availableSP(uid, "تحفيظ القرآن")
                              ));
                            },
                            child: Text("تحفيظ القرآن", textAlign: TextAlign.center , style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold,fontSize: 24.0, fontFamily: 'Montserrat', )),
                          )
                      ),
                      SizedBox(
                        width: 130.0, height: 130.0,
                        child: RaisedButton(
                          color: Colors.tealAccent[100],
                          onPressed: () {
                            Navigator.push(context, new MaterialPageRoute(
                              builder: (context) => privateTraining(uid)
                          ));
                            },
                          child: Text("دروس خصوصية", textAlign: TextAlign.center ,style: TextStyle(
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SizedBox(
                          width: 130.0, height: 130.0,
                          child: RaisedButton(color: Colors.cyan[200],
                            onPressed: () {
                              Navigator.push(context, new MaterialPageRoute(
                                  builder: (context) => availableSP(uid, "دروس بدنية")
                              ));
                            },
                            child: Text("دروس بدنية",  textAlign: TextAlign.center ,style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold,fontSize: 24.0, fontFamily: 'Montserrat', )),
                          )
                      ),
                      SizedBox(
                        width: 130.0, height: 130.0,
                        child: RaisedButton(
                          color: Colors.green[300],
                          onPressed: () {
                            Navigator.push(context, new MaterialPageRoute(
                                builder: (context) => availableSP(uid, "قيادة")
                            ));
                          },
                          child: Text("قيادة", textAlign: TextAlign.center ,style: TextStyle(
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SizedBox(
                          width: 130.0, height: 130.0,
                          child: RaisedButton(color: Colors.purple[200],
                            onPressed: () {
                              Navigator.push(context, new MaterialPageRoute(
                                  builder: (context) => availableSP(uid, "موسيقى")
                              ));
                            },
                            child: Text("موسيقى",  textAlign: TextAlign.center ,style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold,fontSize: 24.0, fontFamily: 'Montserrat', )),
                          )
                      ),
                      SizedBox(
                        width: 130.0, height: 130.0,
                        child: RaisedButton(
                          color: Colors.grey[300],
                          onPressed: () {
                            Navigator.push(context, new MaterialPageRoute(
                                builder: (context) => availableSP(uid, "رقص")
                            ));
                          },
                          child: Text("رقص" ,textAlign: TextAlign.center ,style: TextStyle(
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
