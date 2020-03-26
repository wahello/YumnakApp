import 'package:countdown_flutter/countdown_flutter.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/rendering.dart' as material;
import 'package:rating_bar/rating_bar.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:yumnak/services/ViewLocation.dart';
import 'package:url_launcher/url_launcher.dart';


class spOrderDetails extends StatefulWidget {
      String orderID,cusUID,spUID;
      spOrderDetails(this.cusUID,this.spUID,this.orderID,);

  @override
  _spOrderDetailsState createState() => _spOrderDetailsState(cusUID,spUID,orderID);
}

class _spOrderDetailsState extends State<spOrderDetails> {

  String orderID,cusUID,spUID;
  _spOrderDetailsState(this.cusUID,this.spUID,this.orderID);

  LatLng loc;

  var reqDBReference;
  var _firebaseRef = FirebaseDatabase.instance.reference();
  var dbReferenceCust;
  var _firebaseRefCust =FirebaseDatabase.instance.reference();
  var _cusKey;

  Future<void> _launched;
  double _ratingCus=0.0, _avgCus;
  int _ratingCounter;

  TextStyle uiTextStyle=TextStyle(fontSize: 18,fontWeight: FontWeight.bold);
  TextStyle buttonTextStyle= TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20.0,fontFamily: 'Montserrat',);
  TextStyle alertButtonsTextStyle=TextStyle(color: Colors.white, fontSize: 20);

  double _ratingStarTime = 0, _ratingStarService = 0, _ratingStarWay = 0, _ratingStarPrice = 0;
  String _reviewComments="";
  
  initState() {
    super.initState();
    print('order ID: $orderID');
    reqDBReference = _firebaseRef.child('Order').orderByChild("orderID").equalTo(orderID);
    dbReferenceCust=_firebaseRefCust.child('Customer').orderByChild('uid').equalTo(cusUID);
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  format(Duration d) => d.toString().split('.').first.padLeft(8, "0");

  Widget _buildWidget(item, key) {

    loc = new LatLng(item["latitude"], item["longitude"]);

    DateTime reqDate = DateTime.parse(item['requestDate']);
    var endDate = reqDate.add(new Duration(hours: item['serviceHours']));
    Duration remaining = Duration(minutes: endDate.difference(DateTime.now()).inMinutes);
    bool isWaiting = endDate.isAfter(DateTime.now());

    var cancelDate = endDate.subtract(new Duration(hours: 1));
    var now = DateTime.now();

    print("$cancelDate ::: $now");

    Widget c = new Countdown(
      duration: remaining,
      builder: (BuildContext context, Duration remaining) {
        return Row(
          children: <Widget>[
            Text("الوقت المتبقي: " , textAlign: TextAlign.right, style: uiTextStyle),
            Text(format(remaining)),
          ],
        );
      },
    );

    if(!isWaiting && item["status"] == "قيد الانتظار"){
      _firebaseRef.child('Order').child(key).update({"status": 'ملغي'});
    }

    Color col;
    String stat=item['status'];

    if(stat=="قيد الانتظار")
      col=Colors.black;
    else if(stat=="مقبول")
      col=Colors.green[800];
    else if(stat=="ملغي")
      col=Colors.red;
    else if (stat=="مرفوض")
      col=Colors.red[900];
    else if(stat=="مكتمل")
      col=Colors.blue;


    return Container(
        width: MediaQuery.of(context).size.width,
        child:Column(
        children: <Widget>[
          SizedBox(height:20.0),
          Container(
            child: Directionality(
                textDirection: material.TextDirection.rtl,
                child: Column(
                  children: <Widget>[
                    Card(
                      margin: new EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 5.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                      elevation: 4.0,
                      child: new Padding( padding: new EdgeInsets.all(10.0),
                        child: new Column(
                          children: <Widget>[
                            Align(
                                alignment: Alignment.topRight,
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text("الاسم: " , textAlign: TextAlign.right, style: uiTextStyle),
                                        Text(item['name_cus']),
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(0, 0, 45, 5),
                                          child: RatingBar.readOnly(
                                            initialRating: _avgCus,
                                            isHalfAllowed: true,
                                            halfFilledIcon: Icons.star_half,
                                            filledIcon: Icons.star,
                                            emptyIcon: Icons.star_border,
                                            filledColor: Colors.amber,
                                            size: 20,
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text("تصنيف الخدمة: " , textAlign: TextAlign.right, style: uiTextStyle),
                                        Text(item['service']),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text("حالة الطلب: " , textAlign: TextAlign.right, style: uiTextStyle),
                                        Text(item['status'], style: TextStyle(color: col, fontSize: 19, fontWeight: FontWeight.bold),),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text("وقت الطلب: " , textAlign: TextAlign.right, style: uiTextStyle),
                                        Text(reqDate.toString().substring(0,16) , style: TextStyle(fontSize: 14))
                                      ],
                                    ),

                                    if(isWaiting  &&  (item["status"] == "قيد الانتظار" || item["status"] == "مقبول") )
                                      c,

                                    Row(
                                      children: <Widget>[
                                        Text("وصف الخدمة: " , textAlign: TextAlign.right, style: uiTextStyle),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(item['description'] , overflow: TextOverflow.ellipsis, maxLines: 5,),
                                        )
                                      ],
                                    )
                                  ],
                                )
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 40.0),

                    Row(
                      children: <Widget>[
                        Container(
                          //padding: EdgeInsets.fromLTRB(62, 0, 62, 0),
                            margin: new EdgeInsets.only(left: 70.0, right: 70.0, top: 0, bottom: 0),
                            child: RaisedButton(
                                onPressed:(){
                                  Navigator.push(context, new MaterialPageRoute(
                                      builder: (context) => ViewLocation(item["uid_sp"], item["orderID"], loc, "SP",)));
                                  },
                                color: Colors.grey,
                                child: Row(
                                    children: <Widget>[
                                      Icon(Icons.location_on, color: Colors.white,),
                                      Text("الموقع للخدمة المقدمة", style: buttonTextStyle),
                                    ]
                                )
                            )
                        ),
                      ],
                    ),

                    SizedBox(height: 40.0),

                    if(stat=="قيد الانتظار")
                      Row(
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 60, 0),
                              child: RaisedButton(
                                onPressed:(){
                                  Alert(
                                    context: context,
                                    type: AlertType.none,
                                    title: "قبول الطلب",
                                    style: AlertStyle(isCloseButton: false,),
                                    desc: "يمكنك إلغاء الطلب إذا أردت بشرط أن لا يكون الوقت المتبقي أقل من ساعة",
                                    buttons: [
                                      DialogButton(
                                        child: Text(
                                          "رجوع", style: alertButtonsTextStyle,
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                        color: Colors.grey,
                                      ),
                                      DialogButton(
                                        child: Text("موافق", style: alertButtonsTextStyle,),
                                        onPressed: (){
                                          setState(() { _firebaseRef.child('Order').child(key).update({"status": 'مقبول'}); });
                                          Navigator.pop(context);
                                        },
                                        color: Colors.lightBlueAccent,
                                      ),
                                    ],
                                  ).show();
                                },
                                color: Colors.green[800],
                                child: Text("قبول", style: buttonTextStyle),
                              )
                          ),
                          Container(
                              padding: EdgeInsets.fromLTRB(60, 0, 60, 0),
                              child: RaisedButton(
                                onPressed:(){
                                  Alert(
                                    context: context,
                                    type: AlertType.none,
                                    title: "رفض الطلب",
                                    style: AlertStyle(isCloseButton: false,),
                                    buttons: [
                                      DialogButton(
                                        child: Text(
                                          "رجوع", style: alertButtonsTextStyle,
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                        color: Colors.grey,
                                      ),
                                      DialogButton(
                                        child: Text("موافق", style: alertButtonsTextStyle,),
                                        onPressed: (){
                                          setState(() { _firebaseRef.child('Order').child(key).update({"status": 'مرفوض'}); });
                                          Navigator.pop(context);
                                        },
                                        color: Colors.lightBlueAccent,
                                      ),
                                    ],
                                  ).show();
                                },
                                color: Colors.red,
                                child: Text("رفض", style: buttonTextStyle),
                              )
                          ),
                        ],
                      ),

                    if(stat=='مقبول')
                      Card(
                        margin: new EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0, bottom: 0.0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                        elevation: 4.0,

                        child: new Padding( padding: new EdgeInsets.all(10.0),
                            child: new Row(
                              children: <Widget>[
                                Text('للتواصل: ', textAlign: TextAlign.right, style: uiTextStyle),
                                RaisedButton(
                                    elevation: 0,
                                    onPressed:()=> setState(() {
                                      String phone=item['phone_cus'];
                                      _launched = _makePhoneCall('tel:$phone');
                                    }),
                                    color: Colors.white,
                                    child: Row(
                                        children: <Widget>[
                                          Icon(Icons.call, color: Colors.grey[600],),
                                          Text(" مكالمة ", style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.bold,fontSize: 20.0,fontFamily: 'Montserrat',)),
                                        ]
                                    )
                                ),
                                RaisedButton(
                                    elevation: 0,
                                    onPressed:(){},
                                    color: Colors.white,
                                    child: Row(
                                        children: <Widget>[
                                          Icon(Icons.chat_bubble, color: Colors.grey[600],),
                                          Text(" محادثة", style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.bold,fontSize: 20.0,fontFamily: 'Montserrat',)),
                                        ]
                                    )
                                ),
                              ],
                            )
                        ),
                      ),

                    SizedBox(height: 40.0),

                    if(stat=='مقبول' && now.isBefore(cancelDate))
                      Row(
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
                              child: RaisedButton(
                                onPressed:(){
                                  Alert(
                                      style: AlertStyle(isCloseButton: false,),
                                      context: context,
                                      type: AlertType.none,
                                      title: "اكتمال الطلب",
                                      desc: "شكرًا لك على اكمال الطلب! نرجو تقييم كيف كانت تجربتك مع العميل",
                                      buttons: [
                                        DialogButton(
                                          child: Text(
                                            "رجوع", style: alertButtonsTextStyle,
                                          ),
                                          onPressed: () => Navigator.pop(context),
                                          color: Colors.grey,
                                        ),
                                        DialogButton(
                                          child: Text("موافق", style: alertButtonsTextStyle,),
                                          onPressed: (){
                                            setState(() {
                                              calculateRating(key);
                                            });
                                            Navigator.pop(context);
                                          },
                                          color: Colors.lightBlueAccent,
                                        ),
                                      ],
                                      content: Column(
                                          children: <Widget>[
                                            Container(
                                                child:Column(
                                                    children: <Widget>[
                                                      RatingBar(
                                                          onRatingChanged: (rating) => setState(() => _ratingCus = rating),
                                                          filledIcon: Icons.star, emptyIcon: Icons.star_border, filledColor: Colors.amber, size: 25
                                                      ),
                                                    ]
                                                )
                                            )
                                          ]
                                      )
                                  ).show();
                                },
                                color: Colors.green[800],
                                child: Text("اكتمال الطلب", style: buttonTextStyle),
                              )
                          ),

                            Container(
                              padding: EdgeInsets.fromLTRB(30, 0, 50, 0),
                              child: RaisedButton(
                                onPressed:(){
                                  Alert(
                                    style: AlertStyle(isCloseButton: false,),
                                    context: context,
                                    type: AlertType.none,
                                    title: "إلغاء الطلب",
                                    desc: 'هل أنت متأكد من إلغاء الطلب؟',
                                    buttons: [
                                      DialogButton(
                                        child: Text(
                                          "رجوع", style: alertButtonsTextStyle,
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                        color: Colors.grey,
                                      ),
                                      DialogButton(
                                        child: Text("موافق", style: alertButtonsTextStyle,),
                                        onPressed: (){
                                          setState(() { _firebaseRef.child('Order').child(key).update({"status": 'ملغي'}); });
                                          Navigator.pop(context);
                                        },
                                        color: Colors.lightBlueAccent,
                                      ),
                                    ],
                                  ).show();
                                },
                                color: Colors.red,
                                child: Text("الغاء الطلب", style: buttonTextStyle),
                              )
                          ),
                        ],
                      ),

                    if(stat=='مقبول' && !now.isBefore(cancelDate))
                      Row(
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.fromLTRB(110, 0, 110, 0),
                              child: RaisedButton(
                                onPressed:(){
                                  Alert(
                                      style: AlertStyle(isCloseButton: false,),
                                      context: context,
                                      type: AlertType.none,
                                      title: "اكتمال الطلب",
                                      desc: "شكرًا لك على اكمال الطلب! نرجو تقييم كيف كانت تجربتك مع العميل",
                                      buttons: [
                                        DialogButton(
                                          child: Text(
                                            "رجوع", style: alertButtonsTextStyle,
                                          ),
                                          onPressed: () => Navigator.pop(context),
                                          color: Colors.grey,
                                        ),
                                        DialogButton(
                                          child: Text("موافق", style: alertButtonsTextStyle,),
                                          onPressed: (){
                                            setState(() {
                                              calculateRating(key);
                                            });
                                            Navigator.pop(context);
                                          },
                                          color: Colors.lightBlueAccent,
                                        ),
                                      ],
                                      content: Column(
                                          children: <Widget>[
                                            Container(
                                                child:Column(
                                                    children: <Widget>[
                                                      RatingBar(
                                                          onRatingChanged: (rating) => setState(() => _ratingCus = rating),
                                                          filledIcon: Icons.star, emptyIcon: Icons.star_border, filledColor: Colors.amber, size: 25
                                                      ),
                                                    ]
                                                )
                                            )
                                          ]
                                      )
                                  ).show();
                                },
                                color: Colors.green[800],
                                child: Text("اكتمال الطلب", style: buttonTextStyle),
                              )
                          ),
                        ],
                      ),
                  ],
                )
            ),
          )
        ],
      )
    );
  }

  calculateRating(key){
    double countAvg=_avgCus;
    print(_ratingCus);
    if(_ratingCounter==0)
      _avgCus=0.0;

    if(_ratingCus!=0.0){
      _ratingCounter=_ratingCounter+1;
      countAvg=(_avgCus+_ratingCus)/_ratingCounter;
      countAvg=countAvg.toDouble();
      _avgCus=countAvg+0.0001;
      print("_ratingCounter: $_ratingCounter    countAvg: $countAvg    _avgCus: $_avgCus  ");
    }

    print('$_ratingCounter: $_avgCus');
    _firebaseRef.child('Order').child(key).update({"status": 'مكتمل'});

    _firebaseRefCust.child('Customer').child(_cusKey).update({"ratingCounter": _ratingCounter});
    _firebaseRefCust.child('Customer').child(_cusKey).update({"ratingAvg": _avgCus});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Center(child: new Text("تفاصيل الطلب", textAlign: TextAlign.center, style: TextStyle(color: Colors.lightBlueAccent, fontSize: 30.0, fontWeight: FontWeight.bold, fontFamily: "Montserrat"),)),
          backgroundColor: Colors.grey[200],
          iconTheme: IconThemeData(color: Colors.black38),
          actions: <Widget>[IconButton(icon: Icon(Icons.home),onPressed: (){},color: Colors.grey[200],)], //اللهم إنا نسألك الستر والسلامة
        ),

        body: Container(
          width: MediaQuery.of(context).size.width,
          child: StreamBuilder(
            stream: dbReferenceCust.onValue,
            builder: (context, snapshot){
              if (snapshot.connectionState == ConnectionState.waiting){return Center(child: CircularProgressIndicator(),);}
              Map custData = snapshot.data.snapshot.value;
              List CustItem = [];
              _cusKey= custData.keys.toList()[0];
              custData.forEach((index, data) => CustItem.add({"key": index, ...data}));
              _avgCus= CustItem[0]['ratingAvg'];
              _ratingCounter = CustItem[0]['ratingCounter'];
              print('$_avgCus ::: $_ratingCounter');

              return StreamBuilder(
                stream: reqDBReference.onValue,
                builder: (context, snapshot){
                  if (snapshot.connectionState == ConnectionState.waiting){return Center(child: CircularProgressIndicator(),);}
                  Map data = snapshot.data.snapshot.value;
                  List item = [];
                  data.forEach((index, data) => item.add({"key": index, ...data}));
                  return ListView.builder(
                      itemCount: item.length,
                      itemBuilder: (context, index) {
                        return _buildWidget(item[index], data.keys.toList()[index]);
                      }
                  );
                },
              );
            },
          ),
        )
    );
  }
}
