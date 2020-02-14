import 'package:flutter/material.dart';

class events extends StatefulWidget {
  @override
  _eventsState createState() => _eventsState();
}

class _eventsState extends State<events> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.grey[200],
        ),


        resizeToAvoidBottomPadding: false,
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              Container(
                padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 10.0),
                child: Text('تنظيم مناسبات', style: TextStyle(color: Colors.lightBlueAccent, fontSize: 40.0, fontWeight: FontWeight.bold, fontFamily: "Montserrat"),),
              ),

              SizedBox(height:10.0),

              SizedBox(height:10.0),
              Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SizedBox(
                          width: 130.0, height: 130.0,
                          child: RaisedButton(color: Colors.grey[400],
                            onPressed: () {},
                            child: Text("منسقة حفلات",  textAlign: TextAlign.center ,style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold,fontSize: 24.0, fontFamily: 'Montserrat', )),
                          )
                      ),
                      SizedBox(
                        width: 130.0, height: 130.0,
                        child: RaisedButton(
                          color: Colors.deepOrangeAccent,
                          onPressed: () {},
                          child: Text("صبابات" ,textAlign: TextAlign.center ,style: TextStyle(
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
                          color: Colors.lightGreenAccent,
                          onPressed: () {},
                          child: Text("تجهيز طعام", textAlign: TextAlign.center ,style: TextStyle(
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