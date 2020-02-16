import 'package:flutter/material.dart';

class beauty extends StatefulWidget {
  @override
  _beautyState createState() => _beautyState();
}

class _beautyState extends State<beauty> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          //automaticallyImplyLeading: false,     //عشان يروح سهم الرجوع
          backgroundColor: Colors.grey[200],
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

              SizedBox(height:10.0),
              Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SizedBox(
                          width: 130.0, height: 130.0,
                          child: RaisedButton(color: Colors.grey[400],
                            onPressed: () {},
                            child: Text("شعر",  textAlign: TextAlign.center ,style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold,fontSize: 24.0, fontFamily: 'Montserrat', )),
                          )
                      ),
                      SizedBox(
                        width: 130.0, height: 130.0,
                        child: RaisedButton(
                          color: Colors.tealAccent[100],
                          onPressed: () {},
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
                          onPressed: () {Navigator.push(context, new MaterialPageRoute(
                              builder: (context) => beauty()
                          ));},
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
