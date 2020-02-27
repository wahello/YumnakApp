import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "dart:core";

class Addhours extends StatefulWidget {
  @override
  String email;
  Addhours(String email){this.email=email;}
  _AddhoursState createState() => _AddhoursState(email);



}



//--------------------------------------------------------------------
List<myData> allData = [];


//--------------------------------------------------------------------


class myData {
  String  available;

  myData(this.available);
}


class _AddhoursState extends State<Addhours> {

  String e;
  _AddhoursState(String email){e=email;}


  static const List<String> startTime = const [
    '8:00','9:00','10:00','11:00','12:00','13:00','14:00','15:00', '16:00','17:00','18:00','19:00','20:00','21:00','22:00','23:00','0:00' ,'1:00', '2:00', '3:00','4:00','5:00','6:00','7:00'];

  static const List<String> endTime = const [
    '8:00','9:00','10:00','11:00','12:00','13:00','14:00','15:00', '16:00','17:00','18:00','19:00','20:00','21:00','22:00','23:00','0:00' ,'1:00', '2:00', '3:00','4:00','5:00','6:00','7:00'];


  String startTimeValue = startTime[0];
  String endTimeValue = endTime[0];

   String state;


   Future checkState() async{

    DatabaseReference ref = FirebaseDatabase.instance.reference();
    ref.child('Service Provider').orderByChild("email").equalTo(e).
    once().then((DataSnapshot snap) async{
    var keys = snap.value.keys;
    var data = snap.value;

  allData.clear();
  myData d;
  for (var key1 in keys) {
  d = new myData(data[key1]['available']);
  await allData.add(d);
  }

    for (var i = 0; i < allData.length; i++) {
      state=allData[i].available.toString();
    }

   } );
    updateUserStatus();

   }

   Future<void> updateUserStatus() async {
     var _keys;
     var key;



     DatabaseReference ref = FirebaseDatabase.instance.reference();
     ref.child('Service Provider').orderByChild("email").equalTo(e).
     once().then(
             (DataSnapshot snap) async {
       _keys = snap.value.keys;
       key = _keys.toString();
       key=key.substring(1,21);


       if(state == "true"){
         ref.child('Service Provider').child(key).update(
             { "available": "false"});
       }if(state == "false"){
         ref.child('Service Provider').child(key).update({ "available": "true"});
       }


             } );

    }


  bool _lights=false;

  String start;
  String end;




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

      body:
      Column(
        children: <Widget>[
          SizedBox(height:30.0),

          Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              children: <Widget>[
               SizedBox(width:20.0),

                Container(
                   // padding: EdgeInsets.fromLTRB(95.0, 20.0, 0.0, .0),
                    child: Text('متوفر للخدمة من الساعة',
                      style:
                      TextStyle(color: Colors.grey[600], fontSize: 20.0, fontWeight: FontWeight.bold, fontFamily: "Montserrat"),
                    )),

                SizedBox(width:20.0),
                Container(
                   child: DropdownButton<String>(
                      //isExpanded: true,
                       items: startTime.map<DropdownMenuItem<String>>((String text) {
                       return DropdownMenuItem<String>(
                         value: text,
                         child: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis),
                       );
                     }).toList(),
                      value: startTimeValue,
                      onChanged: (String newValueSelected) {
                        setState(() {
                          startTimeValue = newValueSelected;
                          start=newValueSelected;});
                      },
                    ),


                ),

              ],
            ),
          ),

          SizedBox(height:20.0),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              children: <Widget>[
                SizedBox(width:20.0),
                Container(
                    child: Text('إلى الساعة',
                      style:
                      TextStyle(color: Colors.grey[600], fontSize: 20.0, fontWeight: FontWeight.bold, fontFamily: "Montserrat"),
                    )),
                SizedBox(width:120.0),
                Container(
                  child:

                  DropdownButton<String>(
                    items: endTime.map((String dropDownStringItem){
                      return DropdownMenuItem<String>(
                        value: dropDownStringItem ,
                        child: Text(dropDownStringItem),
                      );
                    }).toList(),
                    value: endTimeValue,
                    onChanged: (String newValueSelected){
                      setState(() {
                        endTimeValue = newValueSelected;
                        end=newValueSelected;});
                    },
                  ),

                ),
              ],
            ),
          ),

          SizedBox(height:20.0),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              children: <Widget>[
                SizedBox(width:20.0),
                Container(
                    child: Text('متاح',
                      style:
                      TextStyle(color: Colors.grey[600], fontSize: 20.0, fontWeight: FontWeight.bold, fontFamily: "Montserrat"),
                    )),
                SizedBox(width:120.0),
                Container(
                 child: CupertinoSwitch(
                    value: _lights,
                    onChanged: (bool value) {
                      setState(() {

                        int now = new DateTime.now().hour;
                        print(now);

                        int startTime = int.parse(start.substring(0,2));
                        int endTime = int.parse(end.substring(0,2));
                        print(startTime);
                        print(endTime);

                        if( startTime  <  endTime && startTime > now){
                          _lights = value;
                          checkState();
                        }

                        //int wait = endTime-startTime;
                        int wait = 20;


                        Future.delayed(Duration(seconds: wait), () async{
                         // dispose();
                          setState(() {
                           checkState();
                           _lights = false;
                          // activated = true;
                          });

                        });

                      });

                      },
                  ),
                )

              ],
            ),
          ),


          ],
      )

    );
  }

}
