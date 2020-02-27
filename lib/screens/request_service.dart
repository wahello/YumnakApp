import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yumnak/services/RequestLocation.dart';

class request_service extends StatefulWidget {
  @override
  _request_serviceState createState() => _request_serviceState();
}

class _request_serviceState extends State<request_service> {


  static const List<String> hours_list = const [
    'ساعة واحدة', 'ساعتين', 'ثلاث ساعات',
    'أربع ساعات', 'خمس ساعات', 'ست ساعات',
    'سبع ساعات', 'ثمان ساعات', 'تسع ساعات',
    'عشر ساعات', 'أحدى عشرة ساعة', 'إثنا عشرة ساعة',
    'ثلاثة عشرة ساعة', 'أربع عشرة ساعة', 'خمس عشرة ساعة',
    'ست عشرة ساعة', 'سبع عشرة ساعة', 'ثمان عشرة ساعة',
    'تسع عشر ساعة', 'عشرين ساعة', 'واحد وعشرين ساعة',
    'اثنان وعشرين ساعة', 'ثلاث وعشرين ساعة', 'أربع وعشرين ساعة',
  ];
  String hoursValue = hours_list[0];
  String longSpinnerValue;
  String serviceDes;

  Map<String, dynamic> pickedLoc;
  LatLng loc;
  LatLng l=new LatLng(24.745532, 46.790632);

  var lat;
  var lng;
  String comment;
  bool picked=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Center(child: new Text("طلب جديد", textAlign: TextAlign.center, style: TextStyle(color: Colors.lightBlueAccent, fontSize: 25.0, fontFamily: "Montserrat"))),
        backgroundColor: Colors.grey[200],
        iconTheme: IconThemeData(color: Colors.black38),
        actions: <Widget>[IconButton(icon: Icon(Icons.home),onPressed: (){},color: Colors.grey[200],)], //اللهم إنا نسألك الستر والسلامة
      ),

      body:Container(
          child: Form(
            child: CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate([
                    SizedBox(height: 40.0),
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: Row(
                        children: <Widget>[
                          SizedBox(width:20.0),

                          Container(
                            // padding: EdgeInsets.fromLTRB(95.0, 20.0, 0.0, .0),
                              child: Text('أحتاج الخدمة خلال: ',
                                style:
                                TextStyle(color: Colors.grey[600], fontSize: 20.0, fontWeight: FontWeight.bold, fontFamily: "Montserrat"),
                              )),

                          SizedBox(width:20.0),
                          Container(
                            child: DropdownButton<String>(
                              //isExpanded: true,
                              items: hours_list.map<DropdownMenuItem<String>>((String text) {
                                return DropdownMenuItem<String>(
                                  value: text,
                                  child: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize:14, color: Colors.grey[600],),),
                                );
                              }).toList(),

                              value: hoursValue,

                              onChanged: (String newValueSelected) {
                                setState(() {
                                  hoursValue = newValueSelected;
                                  longSpinnerValue=newValueSelected;});
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 30.0),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Directionality(
                          textDirection: TextDirection.rtl,
                          child:TextFormField(
                            validator: (val) => val.isEmpty ? "الرجاء كتابة وصف للطلب" : null,
                            onChanged: (val){ setState(() => serviceDes =val);},
                            //expands:true,
                            maxLines: 6,
                            minLines: 4,
                            decoration: InputDecoration(
                                icon: Icon(Icons.description),
                                labelText: 'وصف الطلب',
                                labelStyle: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.bold,color: Colors.grey),
                                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.lightBlueAccent))),
                          )
                      ),
                    ),

                    SizedBox(height: 40.0),
                    Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(60, 0, 60, 0),
                            child: RaisedButton(
                                onPressed: _pickLocation,
                                color: Colors.green[100],
                                child: Row(
                                    children: <Widget>[
                                      Text("الموقع للخدمة المقدمة",
                                          style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.bold,fontSize: 20.0,fontFamily: 'Montserrat',)
                                      ),
                                      Icon(
                                        Icons.edit_location,
                                        color: Colors.grey[600],
                                      ),
                                    ]
                                )
                            )
                        ),
                      ],
                    ),

                    SizedBox(height: 70.0),
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: FloatingActionButton.extended(
                        onPressed: () {
                          if(picked){
                            print(longSpinnerValue);
                            print(serviceDes);
                            print(lat);
                            print(lng);
                            print(comment);
                            print(picked);
                          }

                          else {
                            Fluttertoast.showToast(
                                msg: ("الرجاء التأكد من صحة الموقع"),
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIos: 20,
                                backgroundColor: Colors.red[100],
                                textColor: Colors.red[800]
                            );
                            print("ZEFT Picked: $picked");
                          }
                        },
                        label: Text('إرسال الطلب',
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0,
                              fontFamily: 'Montserrat',)
                        ),
                        backgroundColor: Colors.green[300],
                      ),
                    )
                  ],),
                ),
              ]
            ),
          ),
      ),
    );
  }

  _pickLocation() async {
    loc=l;
    pickedLoc = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => ModifyLocation(loc),
        fullscreenDialog: true,
      ),
    );

    print("Zeft: $pickedLoc");

    if (pickedLoc == null) {
      return;
    }
    else{

      lat=pickedLoc['latitude'];
      lng=pickedLoc['longitude'];
      comment=pickedLoc['comments'];
      picked=pickedLoc['prickedLocation'];

      print("Zeft: PickLocation latitude: $lat");
      print("Zeft: PickLocation longitude: $lng");
      print("Zeft: PickLocation comments: $comment");
      print("Zeft: PickLocation comments: $picked");


      loc=new LatLng(lat, lng);
      l=loc;
    }
  }
}