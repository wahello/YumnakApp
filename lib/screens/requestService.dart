import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:yumnak/screens/HomePage.dart';
import 'package:yumnak/services/RequestLocation.dart';
import 'package:intl/intl.dart';
import 'package:flutter/rendering.dart' as material;
import 'package:rflutter_alert/rflutter_alert.dart';

class requestService extends StatefulWidget {
  dynamic uid;
  dynamic spID;
  static var lat=24.727599, lng=46.708254;
  String spName, spService, cusName;
  requestService(dynamic u,dynamic SPu,String spN, String spSer, String cusN, var lt, var lg){
    uid=u; spID=SPu; spName=spN; spService=spSer; cusName=cusN; lat=lt; lng=lg;
  }

  @override
  _requestServiceState createState() => _requestServiceState(uid, spID, spName, spService, cusName, lat,lng);
}

List<orderData> allData = [];

class orderData {
  var cusUid, spUid;

  orderData(this.cusUid, this.spUid);
}

class _requestServiceState extends State<requestService> {

  static dynamic uid;
  static dynamic sp_uid;
  String spName, spService, cusName;
  static var lat=24.727599, lng=46.708254;
  LatLng l;

  _requestServiceState(dynamic u,dynamic SPu,String spN, String spSer, String cusN, var lt, var lg){
    uid=u; sp_uid=SPu; spName=spN; spService=spSer; cusName=cusN; lat=lt; lng=lg;
    l=new LatLng(lat, lng);
    print('SP_details: $uid'); print('SP_details SPUID: $sp_uid');
  }

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
  String serviceDescription;
  String status='قيد الانتظار';

  final _formKey = GlobalKey<FormState>();

  var dt;
  var numOfHours;
  String dateAndTime;

  Map<String, dynamic> pickedLoc;
  LatLng loc;
  String comment;
  bool picked=false;

  String error;
  int countOrders=0;
  var orderID;

  final DatabaseReference database = FirebaseDatabase.instance.reference().child("Order");

  sendData() {
    database.push().set({
      'uid_cus': uid,
      'uid_sp': sp_uid,
      'orderID': orderID,
      'requestDate': dt,
      'status': status,
      'service': spService,
      'name_cus':cusName,
      'name_sp':spName,
      'serviceHours': numOfHours,
      'description': serviceDescription,
      'loc_latitude':lat,
      'loc_longitude' : lng,
      'loc_locComment': comment,
    });
  }

  getData() async {
    await FirebaseDatabase.instance.reference().child('Order').once().then((DataSnapshot snap) async {
      var keys = snap.value.keys;
      countOrders=0;

      for (var key in keys)
        countOrders++;
    });
  }

  void _showDialog() {
    Alert(
      context: context,
      type: AlertType.success,
      title: "تم إنشاء الطلب بنجاح",
      desc: "حالة الطلب قيد الانتظار لمعرفة تحديثات الطلب الرجاء الذهاب إلى صفحة طلباتي",
      buttons: [
        DialogButton(
          child: Text(
            "موافق",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: (){
            Navigator.push(context, new MaterialPageRoute(
              builder: (context) => HomePage(uid)));
          },
          width: 120,
        )
      ],
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    getData();

    return Scaffold(
      appBar: new AppBar(
        title: new Center(child: new Text("طلب جديد", textAlign: TextAlign.center, style: TextStyle(color: Colors.lightBlueAccent, fontSize: 25.0, fontFamily: "Montserrat"))),
        backgroundColor: Colors.grey[200],
        iconTheme: IconThemeData(color: Colors.black38),
        actions: <Widget>[IconButton(icon: Icon(Icons.home),onPressed: (){},color: Colors.grey[200],)], //اللهم إنا نسألك الستر والسلامة
      ),
      body:Container(
          child: Form(
            key: _formKey, //for validation
            child: CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate([
                    SizedBox(height: 40.0),
                    Directionality(
                      textDirection: material.TextDirection.rtl,
                      child: Row(
                        children: <Widget>[
                          SizedBox(width:20.0),

                         Expanded(
                           child: Container(
                             // padding: EdgeInsets.fromLTRB(95.0, 20.0, 0.0, .0),
                               child: Text('أحتاج الخدمة خلال: ',
                                 style:
                                 TextStyle(color: Colors.grey[600], fontSize: 18.0, fontWeight: FontWeight.bold, fontFamily: "Montserrat"),
                               ))
                         ),

                          SizedBox(width:20.0),
                          Expanded(
                            child: Container(
                              child: DropdownButtonFormField<String>(
                                validator: (value) => value == null ? 'يجب اختيار وقت الخدمة' : null,
                                hint: new Text('أختر وقت الخدمة'),
                                //isExpanded: true,


                                onChanged: (String newValueSelected) {
                                  setState(() {
                                    if (newValueSelected=='-أختر -' ||  newValueSelected.isEmpty){
                                      error = 'يجب أختيار الخدمة';}
                                    else{
                                      hoursValue = newValueSelected;
                                    longSpinnerValue=newValueSelected;}
                                  });
                                },
                                // value: hoursValue,
                                value: longSpinnerValue,

                                items: hours_list.map<DropdownMenuItem<String>>((String text) {
                                  return DropdownMenuItem<String>(
                                    value: text,
                                    child: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize:14, color: Colors.grey[600],),),
                                  );
                                }).toList(),


                              ),
                            ),
                          ),
                          SizedBox(width:20.0),
                        ],

                      ),
                  ),

                    SizedBox(height: 30.0),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Directionality(
                          textDirection: material.TextDirection.rtl,
                          child: TextFormField(
                            validator: (val) => val.isEmpty ? "الرجاء كتابة وصف للطلب" : null,
                            onChanged: (val){ setState(() => serviceDescription =val);},
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
                          if(_formKey.currentState.validate())
                          if(picked){
                            for(var i=0; i<24; i++)
                              if(longSpinnerValue==hours_list[i])
                                numOfHours=i+1;

                            dt= new DateTime.now().toString();
                            //dateAndTime=dateFormat.format(dt);

                            orderID='#'+(countOrders++).toString();

                            sendData();
                            _showDialog();
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
                          }
                        },
                        label: Text('إرسال الطلب',
                            //textDirection: TextDirection.rtl,
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
        builder: (ctx) => RequestLocation(loc, comment),
        fullscreenDialog: true,
      ),
    );

    if (pickedLoc == null)
      return;

    else{
      lat=pickedLoc['latitude'];
      lng=pickedLoc['longitude'];
      comment=pickedLoc['comments'];
      picked=true;
      loc=new LatLng(lat, lng);
      l=loc;
    }
  }
}