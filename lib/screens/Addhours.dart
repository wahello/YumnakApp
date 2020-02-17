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



class _AddhoursState extends State<Addhours> {

   String e;
  _AddhoursState(String email){e=email;}


  static const List<String> startTime = const [
    '13:00','14:00','15:00', '16:00','17:00','18:00','19:00','20:00','21:00','22:00','23:00','0:00' ,'1:00', '2:00', '3:00','4:00','5:00','6:00','7:00','8:00','9:00','10:00','11:00','12:00'];

  static const List<String> endTime = const [
    '13:00','14:00','15:00', '16:00','17:00','18:00','19:00','20:00','21:00','22:00','23:00','0:00' ,'1:00', '2:00', '3:00','4:00','5:00','6:00','7:00','8:00','9:00','10:00','11:00','12:00'];


  String startTimeValue = startTime[0];
  String endTimeValue = endTime[0];




   Future<void> updateUserStatus() async {
     var keys;

     DatabaseReference ref = FirebaseDatabase.instance.reference();
     ref.child('Service Provider').orderByChild("email").equalTo(e).
     once().then(
             (DataSnapshot snap) async {
       print(e);
       keys = snap.value.keys;
       print(keys);
       keys=keys.subString(1,21);
       print(keys);


             } );

     //keys= keys.substring(1);
     //print(keys);
     //keys2=keys2.substring(keys2.length-1);
    // print(keys2);
     ref.child('Service Provider').child("").child('name').update({
       "name": "shahad12"
     });

     ref.child('Service Provider').child("-M0J3Ma6dZpQWfd-NaDB").update({ "name": "shahad12"});

    }


  bool _lights=false;

  String start;
  String end;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
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
                        _lights = value;
                        if(int.parse(end.substring(0,2))  > int.parse(start.substring(0,2)) ){
                          updateUserStatus();
                          print(end);print(start);

                        }
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
