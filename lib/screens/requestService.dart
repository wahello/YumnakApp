import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:yumnak/screens/HomePage.dart';
import 'package:yumnak/services/RequestLocation.dart';
import 'package:flutter/rendering.dart' as material;
import 'package:rflutter_alert/rflutter_alert.dart';

class requestService extends StatefulWidget {
  dynamic uid;
  dynamic spID;
  requestService(dynamic u,dynamic SPu){
    uid=u; spID=SPu;
  }

  @override
  _requestServiceState createState() => _requestServiceState(uid, spID);
}

List<orderData> allData = [];

class orderData {
  var cusUid, spUid;

  orderData(this.cusUid, this.spUid);
}

class _requestServiceState extends State<requestService> {

  static dynamic uid;
  static dynamic sp_uid;

  var reqDBReferenceSP;
  var _firebaseRefSP = FirebaseDatabase.instance.reference();
  var dbReferenceCust;
  var _firebaseRefCust =FirebaseDatabase.instance.reference();
  var dbReferenceOrders;
  var _firebaseRefOrders =FirebaseDatabase.instance.reference();

  String spName, spPN, spService, cusName, cusPN;
  LatLng l;

  TextEditingController _sdControlar= TextEditingController();

  _requestServiceState(dynamic u,dynamic SPu){
    uid=u; sp_uid=SPu;
    print('SP_details: $uid'); print('SP_details SPUID: $sp_uid');
  }

  initState() {
    super.initState();
    reqDBReferenceSP = _firebaseRefSP.child('Service Provider').orderByChild('uid').equalTo(sp_uid);
    dbReferenceCust=_firebaseRefCust.child('Customer').orderByChild('uid').equalTo(uid);
    dbReferenceOrders=_firebaseRefOrders.child('Order');
    _sdControlar.addListener(_setSD);
  }

  _setSD(){
    serviceDescription=_sdControlar.text;
    print(serviceDescription);
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
  String serviceDescription="zeft";
  String status='قيد الانتظار';

  final _formKey = GlobalKey<FormState>();

  var dt;
  var numOfHours;
  String dateAndTime;

  Map<String, dynamic> pickedLoc;
  LatLng loc;
  double lat, lng;
  String comment;
  bool picked=false;

  String error;
  int countOrders=0;
  var orderID;
  bool isCusRate= false;
  String zeft='';

  final DatabaseReference database = FirebaseDatabase.instance.reference().child("Order");

  sendData() {
    database.push().set({
      'uid_cus': uid,
      'uid_sp': sp_uid,
      'name_cus':cusName,
      'name_sp':spName,
      'pn_cus': cusPN,
      'pn_sp': spPN,
      'orderID': orderID,
      'requestDate': dt,
      'status': status,
      'service': spService,
      'serviceHours': numOfHours,
      'description': serviceDescription,
      'latitude':lat,
      'longitude': lng,
      'loc_locComment': comment,
      'is_cus_rate':isCusRate,
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

  Widget _buildWidget(){
    return Form(
      key: _formKey, //for validation
      child: Column(
        children: <Widget>[
          SizedBox(height: 40.0),
          Directionality(
            textDirection: material.TextDirection.rtl,
            child: Row(
              children: <Widget>[
                SizedBox(width:20.0),

                Expanded(
                    child: Container(
                        child: Text('أحتاج الخدمة خلال: ',
                          style: TextStyle(color: Colors.grey[600], fontSize: 18.0, fontWeight: FontWeight.bold, fontFamily: "Montserrat"),
                        ))
                ),

                SizedBox(width:20.0),
                Expanded(
                  child: Container(
                    child: DropdownButtonFormField<String>(
                      validator: (value) => value == null ? 'يجب اختيار وقت الخدمة' : null,
                      hint: new Text('أختر وقت الخدمة'),
                      onChanged: (String newValueSelected) {
                        setState(() {
                          if (newValueSelected=='-أختر -' ||  newValueSelected.isEmpty){
                            error = 'يجب أختيار الخدمة';}
                          else{
                            hoursValue = newValueSelected;
                            longSpinnerValue=newValueSelected;}
                        });
                      },
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
                  //onChanged: (val){ setState(() => serviceDescription =val);},
                  //expands:true,
                  controller: _sdControlar,
                  maxLines: 6,
                  minLines: 4,
                  decoration: InputDecoration(
                      icon: Icon(Icons.description),
                      labelText: 'وصف zeft الطلب',
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
                    orderID='#'+(countOrders+1).toString();
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
        ],
      )
    );
  }

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
          width: MediaQuery.of(context).size.width,
          child: StreamBuilder(
            stream: dbReferenceCust.onValue,
            builder: (context, snapshot){
              if (snapshot.connectionState == ConnectionState.waiting){return Center(child: CircularProgressIndicator(),);}
              Map custData = snapshot.data.snapshot.value;
              List CustItem = [];
              custData.forEach((index, data) => CustItem.add({"key": index, ...data}));
              cusName= CustItem[0]['name'];
              cusPN = CustItem[0]['phoneNumber'];
              lat=CustItem[0]['latitude'];
              lng=CustItem[0]['longitude'];

              return StreamBuilder(
                stream: reqDBReferenceSP.onValue,
                builder: (context, snapshot){
                  if (snapshot.connectionState == ConnectionState.waiting){return Center(child: CircularProgressIndicator(),);}
                  Map data = snapshot.data.snapshot.value;
                  List spItem = [];
                  data.forEach((index, data) => spItem.add({"key": index, ...data}));
                  spName= spItem[0]['name'];
                  spPN= spItem[0]['phoneNumber'];
                  spService= spItem[0]['service'];

                  return StreamBuilder(
                    stream: dbReferenceOrders.onValue,
                    builder: (context, snapshot){
                      if (snapshot.connectionState == ConnectionState.waiting){return Center(child: CircularProgressIndicator(),);}
                      Map data = snapshot.data.snapshot.value;
                      List orderItem = [];
                      data.forEach((index, data) => orderItem.add({"key": index, ...data}));
                      countOrders=orderItem.length;
                      print(countOrders);

                      return _buildWidget();
                    },
                  );
                },
              );
            },
          ),
      ),
    );
  }

  _pickLocation() async {
    loc= new LatLng(lat, lng);
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

      if(comment==null)
        comment='';
      picked=true;
      loc=new LatLng(lat, lng);
    }
  }
}