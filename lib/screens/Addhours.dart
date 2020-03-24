import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "dart:core";
import 'dart:async';

import 'package:fluttertoast/fluttertoast.dart';

class Addhours extends StatefulWidget {
  @override
  String spID;
  Addhours(String uid){this.spID=uid;}
  _AddhoursState createState() => _AddhoursState(spID);
}
//--------------------------------------------------------------------
List<myData> allData = [];

//--------------------------------------------------------------------


class myData {
  String  available;
  myData(this.available);
}


class _AddhoursState extends State<Addhours> {

  String spID;
  _AddhoursState(String uid){spID=uid;}


  DateTime startDB,endDB;


  bool _lights=false;

  bool state;
  String start;
  String end;

  TimeOfDay _startTimeDB;
  TimeOfDay _endTimeDB;

  DateTime startDT;
  DateTime endDT;

  bool free =false;



////////////////////////
  var dbReference;
  var _firebaseRef =FirebaseDatabase.instance.reference();
////////////////////////

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  initState(){
    super.initState();
    dbReference = _firebaseRef.child('Service Provider').orderByChild("uid").equalTo(spID);
    print(dbReference);
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      build(context);
    });
    return null;
  }

////////////////////////
  Future<void> updateAvaHours() async{
    var _keys;
    var key;

    DatabaseReference ref = await FirebaseDatabase.instance.reference();
    await ref.child('Service Provider').orderByChild("uid").equalTo(spID).
    once().then(
            (DataSnapshot snap) async {
          _keys = snap.value.keys;
          key = _keys.toString();
          key=key.substring(1,21);
          print(end.toString());
          ref.child('Service Provider').child(key).update({"startTime":(startDB.toString())});
          ref.child('Service Provider').child(key).update({"endTime":(endDB.toString())});
              } );

    updateUserStatus();}

////////////////////////

  Future<void> updateUserStatus() async {
    var _keys;
    var key;


    DatabaseReference ref = FirebaseDatabase.instance.reference();
    ref.child('Service Provider').orderByChild("uid").equalTo(spID).
    once().then(
            (DataSnapshot snap) async {
          _keys = snap.value.keys;
          key = _keys.toString();
          key=key.substring(1,21);

          if(state == true){
            ref.child('Service Provider').child(key).update({ "available": true});
          }if(state == false){
            ref.child('Service Provider').child(key).update({ "available": false});
          }

        } );
  }
////////////////////////

  TimeOfDay _time = new TimeOfDay.now();
  TimeOfDay _endtime ;


  Future<Null> _selectedTime(BuildContext context) async{
    final TimeOfDay picked = await showTimePicker(context: context, initialTime: _time);

    if (picked != null && picked != _time){
      print('Selected Time: ${_time.toString()}');
      setState(() {
        _time = picked;
        print(_time);
      });
    }
  }
  Future<Null> _selectedEndTime(BuildContext context) async{
    final TimeOfDay picked = await showTimePicker(context: context, initialTime: _time);

    if (picked != null && picked != _time){
      print('Selected end Time: ${_time.toString()}');
      setState(() {
        _endtime = picked;
        print(_endtime);
      });
    }
  }

////////////////////////



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          iconTheme: IconThemeData(
            color: Colors.black38, //change your color here
          ),
          title: new Center(child: new Text("أوقات عملي المتاحة", textAlign: TextAlign.center, style: TextStyle(color: Colors.lightBlueAccent, fontSize: 25.0, fontFamily: "Montserrat",fontWeight: FontWeight.bold))),
          backgroundColor: Colors.grey[200],
        ),

        body: RefreshIndicator(
          key: refreshKey,
          onRefresh: refreshList,
          child:ListView(
            children: <Widget>[
              Container(
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder(
                    stream: dbReference.onValue,
                    builder: (context,snapshot){
                      if (snapshot.connectionState == ConnectionState.waiting){return Center(child: CircularProgressIndicator(),);}
                      Map data = snapshot.data.snapshot.value;
                      List item = [];
                      data.forEach((index, data) => item.add({"key": index, ...data}));
                      state = item[0]["available"];
                      start = item[0]["startTime"];
                      end = item[0]["endTime"];



                      if (start != "" && end != ""){
                        print('hello');

                        startDT = DateTime.parse(start);
                        print(startDT);
                        endDT = DateTime.parse(end);
                        print(endDT);


                        if(endDT.isBefore(DateTime.now()) || state == false ){
                          print("almost there");
                          _lights=false;
                          state=false;
                          updateUserStatus();
                        }
                        else{
                          print("somthing");
                          free = true;
                          state = true;
                          _lights=true;
                          updateUserStatus();
                        }
                      }

                      if (state == false ){free = false; }






                      return
                        Column(
                          children: <Widget>[
                            SizedBox(height:30.0),

                            Directionality(
                              textDirection: TextDirection.rtl,
                              child:
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  children:<Widget> [
                                    Row(
                                      children: <Widget>[
                                        SizedBox(width:10.0),
                                        Text('متوفر للخدمة من الساعة',
                                          style:TextStyle(color: Colors.grey[600], fontSize: 18.0, fontWeight: FontWeight.bold, fontFamily: "Montserrat", ),
                                        ),
                                        SizedBox(width:10.0),
                                      ],
                                    ),
                                    Container(
                                      child: Column(
                                        children: <Widget>[
                                          //new Text('إبتداءاً من :${_time.toString().substring(10,15)}'),
                                          new RaisedButton(child: Text ("  أختر ساعة البدء  "), onPressed:(){_selectedTime(context);}),
                                        ],
                                      ),)
                                  ],
                                ),
                              ),
                            ),



                            SizedBox(height:20.0),
                            Directionality(
                                textDirection: TextDirection.rtl,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    children: <Widget>[
                                      SizedBox(width:10.0),
                                      Container(
                                          child: Text('إلى الساعة',
                                            style: TextStyle(color: Colors.grey[600], fontSize: 18.0, fontWeight: FontWeight.bold, fontFamily: "Montserrat"),
                                          )),
                                      SizedBox(width:103.0),
                                      Container(
                                        child: Column(
                                          children: <Widget>[
                                            /* if (_endtime != null)
                                    new Text('إلى : ${_endtime.toString().substring(10,15)}'),*/
                                            new RaisedButton(child: Text (" أختر ساعة الانتهاء"), onPressed:(){_selectedEndTime(context);}),
                                          ],
                                        ),)
                                    ],
                                  ),
                                )
                            ),


                            SizedBox(height:20.0),
                            Directionality(
                                textDirection: TextDirection.rtl,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    children: <Widget>[
                                      SizedBox(width:110.0),
                                      Container(
                                          child: Text('متاح',
                                            style:TextStyle(color: Colors.grey[600], fontSize: 20.0, fontWeight: FontWeight.bold, fontFamily: "Montserrat"),
                                          )),
                                      SizedBox(width:10.0),
                                      Container(
                                        child: CupertinoSwitch(
                                          value: _lights,
                                          onChanged: (bool value) {

                                            setState(() {

                                              DateTime now = new DateTime.now();
                                              print(now);

                                              if (!free){
                                                if((_time == null || _endtime == null)){
                                                  Fluttertoast.showToast(
                                                      msg: ("الرجاء أخيار وقت الاتاحة"),
                                                      toastLength: Toast.LENGTH_LONG,
                                                      gravity: ToastGravity.CENTER,
                                                      timeInSecForIos: 20,
                                                      backgroundColor: Colors.red[100],
                                                      textColor: Colors.red[800]
                                                  );}
                                                else{
                                                  print("Hi from else");
                                                  DateTime now = new DateTime.now();
                                                  print(now);

                                                  if (_time != null){
                                                    startDB = new DateTime(now.year, now.month, now.day, _time.hour, _time.minute);
                                                    print(startDB);
                                                    print(_time.period );

                                                  }

                                                  if (_endtime != null){
                                                    if(_endtime.hour < _time.hour && (_endtime.period ==  DayPeriod.am && _time.period ==  DayPeriod.pm)){
                                                      endDB = new DateTime(now.year, now.month, now.day, _endtime.hour, _endtime.minute);
                                                      endDB = endDB.add(new Duration(days: 1));
                                                    }
                                                    else
                                                      endDB = new DateTime(now.year, now.month, now.day, _endtime.hour, _endtime.minute);

                                                    print(endDB);
                                                    print(_endtime.period );
                                                  }

                                                  if (startDB.isAfter(now) && endDB.isAfter(startDB) ){
                                                    print('hi from iff');
                                                    _lights = value;
                                                    state = true;
                                                    updateAvaHours();

                                                  }else{
                                                    Fluttertoast.showToast(
                                                        msg: ("الرجاء أخيار وقت صحيح"),
                                                        toastLength: Toast.LENGTH_LONG,
                                                        gravity: ToastGravity.CENTER,
                                                        timeInSecForIos: 20,
                                                        backgroundColor: Colors.red[100],
                                                        textColor: Colors.red[800]
                                                    ); }
                                                } }

                                              if(free){
                                                _lights = value;
                                                state = false;
                                                updateUserStatus();
                                                print(_lights);
                                                print("hi from off");
                                              }
                                            });

                                          },


                                        ),
                                      ),
                                    ],
                                  ),
                                )
                            ),
                            SizedBox(height: 20,),
                            if (state == true)
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 10.0),
                                      child: Text(start.substring(0,16)+'متاح من الساعة ', style: TextStyle(color: Colors.grey[600], fontSize: 20.0, fontFamily: "Montserrat"),),
                                    ),

                                    Container(
                                      padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                                      child: Text(end.substring(0,16)+'إلى الساعة ', style: TextStyle(color: Colors.grey[600], fontSize: 20.0, fontFamily: "Montserrat"),),
                                    ),
                                  ],
                                ),
                              ),
                          ], );
                    },
                  )
              ),
            ],
          )
        )
    );
  }

}

//start.substring(10,12)
//start.substring(13,15)
