import 'package:countdown_flutter/countdown_flutter.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/rendering.dart' as material;
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:yumnak/screens/CustOrderDetails.dart';
class CustMyOrders extends StatefulWidget {
  dynamic uid;
  CustMyOrders(dynamic u){uid=u;}

  @override
  _CustMyOrdersState createState() => _CustMyOrdersState(uid);
}

//--------------------------ORDERS------------------------------------------

List<OrderData> allOrders = [];
List<OrderData> ordersForRating=[];

class OrderData {
  String status,
      dateAndTime,
      spService,
      cusName,
      spName,
      serviceDescription,
      locComment;
  var cusUid, spUid, orderID, latitude, longitude, numOfHours;
  //var key;
  bool rate;

  OrderData(
      this.cusUid,
      this.spUid,
      this.orderID,
      this.cusName,
      this.status,
      this.dateAndTime,
      this.spService,
      this.rate,
      this.numOfHours,
     // this.key,
      );
}

class _CustMyOrdersState extends State<CustMyOrders> {

  var dbReference;
  var _firebaseRef =FirebaseDatabase.instance.reference();
  var dbReferenceSP;
  var _firebaseRefSP =FirebaseDatabase.instance.reference();
  var _spKey;
  Map spData;
  List spItem=[];

  List<OrderData> dummyList = List<OrderData>();

  static dynamic uid;
  _CustMyOrdersState(dynamic u){uid=u; print('CustMyOrders: $uid');}

  bool isTimePassed;
  int _ratingCounter;
  double _ratingStarTime = 0.0, _ratingStarService = 0.0, _ratingStarWay = .0, _ratingStarPrice = 0.0;
  double _avgStarTime = 0.0, _avgStarService = 0.0, _avgStarWay = .0, _avgStarPrice = 0.0, _avgOverall;
  String _reviewComments="";


  var refreshKey = GlobalKey<RefreshIndicatorState>();

  initState(){
    super.initState();
    dbReference=_firebaseRef.child('Order').orderByChild('uid_cus').equalTo(uid);
    dbReferenceSP=_firebaseRefSP.child('Service Provider');
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      build(context);
    });
    return null;
  }

  format(Duration d) => d.toString().split('.').first.padLeft(8, "0");

  Widget _buildListItem(OrderData order) {
    DateTime reqDate = DateTime.parse(order.dateAndTime);
    var endDate = reqDate.add(new Duration(hours: order.numOfHours));
    Duration remaining = Duration(minutes: endDate.difference(DateTime.now()).inMinutes);
    bool isWaiting = endDate.isAfter(DateTime.now());

    Widget c = new Countdown(
      duration: remaining,
      builder: (BuildContext context, Duration remaining) {
        return Row(
          children: <Widget>[
            Text("الوقت المتبقي: " , textAlign: TextAlign.right, style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
            Text(format(remaining)),
          ],
        );
      },
    );

    if(!isWaiting && order.status == "قيد الانتظار" ){
      updateStatus(order.orderID);
      //var k = (order.key).toString().substring(1,21);
      //_firebaseRef.child('Order').child(k).update({"status": 'ملغي'});
    }
    
    Color col;
    isTimePassed=false;
    String stat=order.status;

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

    return Directionality(
      textDirection: material.TextDirection.rtl,
      child: Card(
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
                          Text(reqDate.toString().substring(0,16)  , textAlign: TextAlign.right, style:TextStyle(fontSize: 14),)
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text("حالة الطلب: " , textAlign: TextAlign.right, style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                          Text(order.status, style: TextStyle(color: col, fontSize: 19, fontWeight: FontWeight.bold),),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text("نوع الخدمة: " , textAlign: TextAlign.right, style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                          Text(order.spService),
                        ],
                      ),
                      if(isWaiting && (order.status == "قيد الانتظار" || order.status == "مقبول"))
                        c,
                    ],
                  )
              ),

              new Padding(padding: new EdgeInsets.only(top: 10.0)),
              if(order.status!='مكتمل' || order.rate)
              new RaisedButton(
                color: Colors.green[300],
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0),),
                padding: new EdgeInsets.all(3.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text( 'تفاصيل الطلب',
                      style: new TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold,color: Colors.white),
                    ),
                  ],
                ),
                onPressed: () { Navigator.push(context, new MaterialPageRoute(builder: (context) => custOrderDetails(uid, order.orderID)));},
              ),

              if(order.status=='مكتمل' && !order.rate)
                Row(
                  //crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new RaisedButton(
                      color: Colors.green[300],
                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0),),
                      //padding: new EdgeInsets.all(3.0),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Text( 'تفاصيل الطلب',
                            style: new TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold,color: Colors.white),
                          ),
                        ],
                      ),
                      onPressed: () { Navigator.push(context, new MaterialPageRoute(builder: (context) => custOrderDetails(uid, order.orderID)));},
                    ),
                    new RaisedButton(
                      color: Colors.amber,
                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0),),
                      //padding: new EdgeInsets.all(3.0),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Text( 'تقييم الطلب',
                            style: new TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold,color: Colors.white),
                          ),
                        ],
                      ),
                      onPressed: () {showAlert(order); },
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }

  void showAlert(OrderData order){
    TextStyle alertButtonsTextStyle=TextStyle(color: Colors.white, fontSize: 20);
    TextStyle alerttextTextStyle=TextStyle(height: 1, fontSize: 18);

    _ratingStarTime = 0.0;
    _ratingStarService = 0.0;
    _ratingStarWay = 0.0;
    _ratingStarPrice = 0.0;

    Alert(
        style: AlertStyle(isCloseButton: false,),
        context: context,
        type: AlertType.none,
        title: "اكتمال الطلب",
        desc: "تم إكتمال الطلب الخاص بك من قبل مقدم الخدمة الرجاء التقييم",
        buttons: [
          DialogButton(
            child: Text(
              "رجوع", style: alertButtonsTextStyle,
            ),
            onPressed: () => Navigator.pop(context),
            color: Colors.grey,
          ),
          DialogButton(
            child: Text("حفظ", style: alertButtonsTextStyle,),
            onPressed: (){
              setState(() {
                calculateRating(order);
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
                        Row(
                            children: <Widget>[
                              RatingBar(
                                  onRatingChanged: (rating) => setState(() => _ratingStarTime = rating),
                                  filledIcon: Icons.star,
                                  emptyIcon: Icons.star_border,
                                  filledColor: Colors.amber,
                                  size: 25
                              ),

                              Flexible(fit: FlexFit.tight, child: SizedBox()),
                              Text(': الالتزام بالوقت ', style:alerttextTextStyle,) ,
                            ]
                        ),
                        Row(
                            children: <Widget>[
                              RatingBar(
                                onRatingChanged: (rating) => setState(() => _ratingStarService = rating),
                                filledIcon: Icons.star,
                                emptyIcon: Icons.star_border,
                                filledColor: Colors.amber,
                                size: 25,
                              ),

                              Flexible(fit: FlexFit.tight, child: SizedBox()),
                              Text(': جودة الخدمة ', style:alerttextTextStyle,) ,
                            ]
                        ),
                        Row(
                            children: <Widget>[
                              RatingBar(
                                  onRatingChanged: (rating) => setState(() => _ratingStarWay = rating),
                                  filledIcon: Icons.star,
                                  emptyIcon: Icons.star_border,
                                  filledColor: Colors.amber,
                                  size: 25
                              ),

                              Flexible(fit: FlexFit.tight, child: SizedBox()),
                              Text(':التعامل  ', style:alerttextTextStyle,) ,
                            ]
                        ),
                        // Spacer(),
                        Row(
                            children: <Widget>[
                              RatingBar(
                                  onRatingChanged: (rating) => setState(() => _ratingStarPrice = rating),
                                  filledIcon: Icons.star,
                                  emptyIcon: Icons.star_border,
                                  filledColor: Colors.amber,
                                  size: 25
                              ),
                              Spacer(),
                              Text(':السعر ', style:alerttextTextStyle,) ,
                            ]
                        ),

                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: FormBuilder(
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 20.0),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                  child: FormBuilderTextField(
                                    onChanged: (val){setState(() => _reviewComments=val);},
                                    attribute: 'comment',
                                    decoration: InputDecoration(
                                      labelText: 'إضافة تعليق',
                                      //filled: true,
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]
                  )
              )
            ]
        )
    ).show();
  }

  calculateRating(OrderData order){
    int spI;
    for(int i=0; i<spItem.length; i++){
      if(spItem[i]['uid']==order.spUid){
        _avgStarTime=spItem[i]['ratingTime'];
        _avgStarService=spItem[i]['ratingWork'];
        _avgStarWay=spItem[i]['ratingCooperation'];
        _avgStarPrice=spItem[i]['raringPrice'];
        _avgOverall=spItem[i]['ratingAvg'];
        _ratingCounter=spItem[i]['ratingCounter'];
        spI=i;
        _spKey=spData.keys.toList()[i];
        print('FB: $_spKey ::: $spI ::: $_avgStarTime ::: $_avgStarService ::: $_avgStarWay ::: $_avgStarPrice ::: $_avgOverall ::: $_ratingCounter');
      }
    }

    double countStarTime = _avgStarTime, countStarService = _avgStarService, countStarWay = _avgStarWay, countStarPrice = _avgStarPrice;
    print('USER Enter: $_ratingStarTime ::: $_ratingStarService ::: $_ratingStarWay ::: $_ratingStarPrice ::: $_reviewComments');
    if(_ratingCounter==0) {
      _avgStarTime = 0.0;
      _avgStarService = 0.0;
      _avgStarWay = 0.0;
      _avgStarPrice = 0.0;
      _avgOverall=0.0;
    }

    if(_ratingStarTime!=0.0 || _ratingStarService!=0.0 || _ratingStarWay!=0.0 || _ratingStarPrice!=0.0)
      _ratingCounter=_ratingCounter+1;

    if(_ratingStarTime!=0.0){
      countStarTime=((_avgStarTime*(_ratingCounter-1))+_ratingStarTime)/_ratingCounter;
      countStarTime=countStarTime.toDouble();
      _avgStarTime=countStarTime+0.0001;
      print("_ratingCounter: $_ratingCounter    countStarTime: $countStarTime    _avgStarTime: $_avgStarTime  ");
      _firebaseRefSP.child('Service Provider').child(_spKey).update({"ratingTime": _avgStarTime});
    }

    if(_ratingStarService!=0.0){
      countStarService=((_avgStarService*(_ratingCounter-1))+_ratingStarService)/_ratingCounter;
      countStarService=countStarService.toDouble();
      _avgStarService=countStarService+0.0001;
      print("_ratingCounter: $_ratingCounter    countStarService: $countStarService    _avgStarService: $_avgStarService  ");
      _firebaseRefSP.child('Service Provider').child(_spKey).update({"ratingWork": _avgStarService});
    }

    if(_ratingStarWay!=0.0){
      countStarWay=((_avgStarWay*(_ratingCounter-1))+_ratingStarWay)/_ratingCounter;
      countStarWay=countStarWay.toDouble();
      _avgStarWay=countStarWay+0.0001;
      print("_ratingCounter: $_ratingCounter    countStarWay: $countStarWay    _avgStarWay: $_avgStarWay  ");
      _firebaseRefSP.child('Service Provider').child(_spKey).update({"ratingCooperation": _avgStarWay});
    }

    if(_ratingStarPrice!=0.0){
      countStarPrice=((_avgStarPrice*(_ratingCounter-1))+_ratingStarPrice)/_ratingCounter;
      countStarPrice=countStarPrice.toDouble();
      _avgStarPrice=countStarPrice+0.0001;
      print("_ratingCounter: $_ratingCounter    countStarPrice: $countStarPrice    _avgStarPrice: $_avgStarPrice  ");
      _firebaseRefSP.child('Service Provider').child(_spKey).update({"raringPrice": _avgStarPrice});
    }

    _avgOverall=((_avgStarTime+_avgStarService+_avgStarWay+_avgStarPrice)/4)+0.0001;
    _firebaseRefSP.child('Service Provider').child(_spKey).update({"ratingAvg": _avgOverall});
    _firebaseRefSP.child('Service Provider').child(_spKey).update({"ratingCounter": _ratingCounter});
    print(_avgOverall);

    if(_reviewComments!="")
      sendData(order);
    //var k = (order.key).toString().substring(1,21);
    //_firebaseRef.child('Order').child(k).update({"is_cus_rate":true});
    updateRateStatus(order.orderID);

  }

  Future<void> updateStatus(String id) async {
    var _keys;
    var key;
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    ref.child('Order').orderByChild("orderID").equalTo(id).
    once().then((DataSnapshot snap) async {
      _keys = snap.value.keys;
      key = _keys.toString();
      key=key.substring(1,21);
      ref.child('Order').child(key).update({ "status": "ملغي"});
    } );
  }

  Future<void> updateRateStatus(String id) async {
    var _keys;
    var key;
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    ref.child('Order').orderByChild("orderID").equalTo(id).
    once().then((DataSnapshot snap) async {
          _keys = snap.value.keys;
          key = _keys.toString();
          key=key.substring(1,21);
            ref.child('Order').child(key).update({ "is_cus_rate": true});
        } );
  }


  final DatabaseReference database = FirebaseDatabase.instance.reference().child("Reviews");

  sendData(OrderData order) {
    DateTime dt=DateTime.now();

    database.push().set({
      'uid_cus': order.cusUid,
      'uid_sp': order.spUid,
      'dateTime':dt.toString(),
      'name_cus':order.cusName,
      'review':_reviewComments,
    });
  }

  void sortByNewest(){
    dummyList.clear();
    dummyList.addAll(allOrders);
    dummyList.sort((b, a) => a.dateAndTime.compareTo(b.dateAndTime));
    allOrders.clear();
    allOrders.addAll(dummyList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Center(child: new Text("طلباتي", textAlign: TextAlign.center, style: TextStyle(color: Colors.lightBlueAccent, fontSize: 30.0, fontWeight: FontWeight.bold, fontFamily: "Montserrat"),)),
          backgroundColor: Colors.grey[200],
          iconTheme: IconThemeData(color: Colors.black38),
          actions: <Widget>[IconButton(icon: Icon(Icons.home),onPressed: (){},color: Colors.grey[200],)], //اللهم إنا نسألك الستر والسلامة
        ),
        body: RefreshIndicator(
          key: refreshKey,
          onRefresh: refreshList,
          child: Container(
            child: StreamBuilder(
              stream: dbReferenceSP.onValue,
              builder: (context, snapshot){
                if (snapshot.connectionState == ConnectionState.waiting){return Center(child: CircularProgressIndicator(),);}
                spData = snapshot.data.snapshot.value;
                spItem = [];
                spData.forEach((index, data) => spItem.add({"key": index, ...data}));

                return StreamBuilder(
                  stream: dbReference.onValue,
                  builder: (context, snapshot){
                    if (snapshot.connectionState == ConnectionState.waiting){return Center(child: CircularProgressIndicator(),);}
                    if (snapshot.data.snapshot.value != null){
                      Map data = snapshot.data.snapshot.value;
                      var keys = snapshot.data.snapshot.value.keys;

                      allOrders.clear();
                      OrderData o;
                      for (var key in keys) {
                        o = new OrderData(
                          data[key]["uid_cus"],
                          data[key]["uid_sp"],
                          data[key]["orderID"],
                          data[key]["name_cus"],
                          data[key]["status"],
                          data[key]["requestDate"],
                          data[key]["service"],
                          data[key]["is_cus_rate"],
                          data[key]["serviceHours"],
                        //  data.keys.toList(),
                        );
                        allOrders.add(o);
                      }
                      sortByNewest();
                      return ListView.builder(
                          itemCount: allOrders.length,
                          itemBuilder: (context, index) {
                            return _buildListItem(allOrders[index]);
                          }
                      );
                    }else return Center(child: Text("لا يوجد طلبات"),);
                  },
                );
              },
            ),
          ),
        )
    );
  }
}
