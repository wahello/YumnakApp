import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:yumnak/screens/HomePage.dart';
import 'package:yumnak/screens/SP_details.dart';

class availableSP extends StatefulWidget {
  String _cat;
  dynamic _uid;
  availableSP(this._uid, this._cat);

  @override
  _availableSPState createState() => _availableSPState(_uid, _cat);
}

//----------------------------Available SP----------------------------------------

List<myData> allData = [];
List<myData> sortedData = [];
List<myData> dummyList = List<myData>();

class myData {
  String email,name, phoneNumber, service,qualifications,startTime,endTime;
  double raringPrice,ratingCooperation,ratingTime,ratingWork,ratingAvg,price;
  int ratingCounter;
  var uid,latitude,longitude;
  bool available;
  var loc='';

  myData(this.email,this.name, this.phoneNumber, this.service, this.uid,this.price,this.qualifications, this.latitude,this.longitude,
this.startTime,this.endTime,this.raringPrice,this.ratingAvg,this.ratingCooperation,this.ratingCounter,this.ratingTime,this.ratingWork,this.available);
}


//--------------------------------------------------------------------

class _availableSPState extends State<availableSP> {



  String c;
  String sortBy='distance';
  dynamic uid;
  String longSpinnerValue;

  _availableSPState(dynamic u, String cat){
    uid=u;
    c=cat;
   print("Test: $c");
    allData.clear();
  }

  static const List<String> longItems = const [
    'التقييم الأعلى أولًا',
    'السعر الأقل أولًا',
    'المسافة الأقرب أولًا',
  ];


  var dbReferenceSP;
  var _firebaseRefSP =FirebaseDatabase.instance.reference();
  var dbReferenceCust;
  var _firebaseRefCust =FirebaseDatabase.instance.reference();

  var Custlatitude , Custlongitude;

  var refreshKey = GlobalKey<RefreshIndicatorState>();


  @override
  initState(){
    super.initState();
    dbReferenceSP=_firebaseRefSP.child('Service Provider');
    dbReferenceCust=_firebaseRefCust.child('Customer').orderByChild('uid').equalTo(uid);
    //refreshList();
  }
  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      build(context);
    });
    return null;
  }


  Future Sort() async {

    for(var i=0; i< allData.length; i++ ) {
      double ddd = await Geolocator().distanceBetween(Custlatitude, Custlongitude, allData[i].latitude, allData[i].longitude)/1000;
      allData[i].loc=ddd.toStringAsFixed(2);
    }

     return allData;
  }

  void sortByDistance(){
    dummyList.clear();
    dummyList.addAll(allData);
    dummyList.sort((a, b) => double.parse(a.loc).compareTo(double.parse(b.loc)));

      allData.clear();
      allData.addAll(dummyList);
  }

  void sortByPrice(){
    dummyList.clear();
    dummyList.addAll(allData);
    dummyList.sort((a, b) => a.price.compareTo(b.price));

      allData.clear();
      allData.addAll(dummyList);
  }

  void sortByRating(){
    dummyList.clear();
    dummyList.addAll(allData);
    dummyList.sort((a, b) => b.ratingAvg.compareTo(a.ratingAvg));

    allData.clear();
    allData.addAll(dummyList);
  }


  Widget _buildList() {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(height: 20.0),
          Row(
            children: <Widget>[
              Padding(padding: EdgeInsets.all(10.0), ),
              DropdownButton<String>(
                items: longItems.map<DropdownMenuItem<String>>((String text) {
                  return DropdownMenuItem<String>(
                    value: text,
                    child: Text(text,
                        style: TextStyle(fontSize:14, color: Colors.grey[600],),
                        overflow: TextOverflow.fade),
                  );
                }).toList(),

                selectedItemBuilder: (BuildContext context) {
                  return longItems.map<Widget>((String text) {
                    return Text(text, overflow: TextOverflow.fade);
                  }).toList();
                },

                value: longSpinnerValue,
                hint: new Text('  ...تـرتيـب بـحسب  '),
                onChanged: (String text) {
                  setState(() {
                    longSpinnerValue = text;
                    print(text);
                    if(text=='السعر الأقل أولًا')
                      sortBy='price';
                    if(text=='المسافة الأقرب أولًا')
                      sortBy='distance';
                    if(text== 'التقييم الأعلى أولًا')
                      sortBy='rating';
                  });
                },

                style: TextStyle(fontSize:18, fontWeight: FontWeight.bold, color: Colors.grey[600]),
                underline: Container(height: 2, color: Colors.black12,),
                icon: Icon(Icons.sort),
              ),
            ],
          ),
          new Expanded(
            child:ListView.builder(
                    itemCount: allData.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return _buildListItem(allData[index]);
                    }

            )
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(myData d) {

    return GestureDetector(
      onTap: () => Navigator.push(context, new MaterialPageRoute(builder: (context) => SP_details(uid,d.uid,d.loc))),
      child: Card(
        margin: new EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0, bottom: 5.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 4.0,

        child: new Padding( padding: new EdgeInsets.all(10.0),
          child: new Column(
            children: <Widget>[
              new Directionality(
                textDirection: TextDirection.rtl,

                child: new ListTile(
                  leading: Icon(Icons.account_circle , color:Colors.green[400], size:60),
                  title: Text(d.name,style: TextStyle(fontSize:18,fontWeight: FontWeight.bold)),
                  subtitle: Text(d.qualifications,overflow: TextOverflow.ellipsis,),
                ),

              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      if(d.service=='تصوير' || d.service=='إصلاح أجهزة ذكية' || d.service=='عناية واسترخاء'|| d.service== 'شعر'||
                          d.service== 'مكياج'|| d.service=='صبابات'|| d.service=='تنسيق حفلات'|| d.service=='تجهيز طعام')
                        Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(15, 0, 10, 5),
                              child: Text("السعر كحد أدنى",style: TextStyle(fontSize:18,fontWeight: FontWeight.bold)),
                            ),
                            Text(d.price.toString()), ]
                      )
                      else
                        Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.fromLTRB(15, 0, 10, 5),
                                child: Text("السعر بالساعة",style: TextStyle(fontSize:18,fontWeight: FontWeight.bold)),
                              ),
                              Text(d.price.toString()),
                            ]
                        ),

                      Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(15, 0, 10, 5),
                              child: Text("المسافة",style: TextStyle(fontSize:18,fontWeight: FontWeight.bold)),
                            ),
                            Text(d.loc+' كم')
                          ]
                      ),
                      Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(15, 0, 10, 5),
                              child: Text("التقييم",style: TextStyle(fontSize:18,fontWeight: FontWeight.bold)),
                            ),
                            RatingBar.readOnly(
                              initialRating: d.ratingAvg,
                              isHalfAllowed: true,
                              halfFilledIcon: Icons.star_half,
                              filledIcon: Icons.star,
                              emptyIcon: Icons.star_border,
                              filledColor: Colors.amber,
                              size: 20,
                            ),
                          ]
                      ),
                    ]
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: new AppBar(
          title: new Center(child: new Text(c, textAlign: TextAlign.center,
              style: TextStyle(color: Colors.lightBlueAccent, fontSize: 25.0, fontFamily: "Montserrat"))),
          backgroundColor: Colors.grey[200],
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () { Navigator.push(context, new MaterialPageRoute(builder: (context) => HomePage(uid)));},
                  child: Icon(
                    Icons.home,
                    color: Colors.black26,
                    size: 26.0,),
                )
            ),
          ]
      ),

      body: RefreshIndicator(
        key: refreshKey,
        onRefresh: refreshList,
        child: Container(
            child: StreamBuilder(
              stream: dbReferenceCust.onValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting){return Center(child: CircularProgressIndicator(),);}
                Map custData = snapshot.data.snapshot.value;
                List Custitem = [];
                custData.forEach((index, data) => Custitem.add({"key": index, ...data}));
                Custlatitude = Custitem[0]['latitude'];
                Custlongitude = Custitem[0]['longitude'];

                return StreamBuilder(
                  stream: dbReferenceSP.onValue,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting){return Center(child: CircularProgressIndicator(),);}
                    Map SPData = snapshot.data.snapshot.value;
                    var keys = snapshot.data.snapshot.value.keys;

                    allData.clear();
                    myData d;
                    for (var key in keys) {
                      d = new myData(
                        SPData[key]['email'],
                        SPData[key]['name'],
                        SPData[key]['phoneNumber'],
                        SPData[key]['service'],
                        SPData[key]['uid'],
                        SPData[key]['price'].toDouble(),
                        SPData[key]['qualifications'],
                        SPData[key]['latitude'],
                        SPData[key]['longitude'],
                        SPData[key]['startTime'],
                        SPData[key]['endTime'],
                        SPData[key]['raringPrice'],
                        SPData[key]['ratingAvg'],
                        SPData[key]['ratingCooperation'],
                        SPData[key]['ratingCounter'],
                        SPData[key]['ratingTime'],
                        SPData[key]['ratingWork'],
                        SPData[key]['available'],
                      );
                      allData.add(d);
                    }


                    return Container(
                      child: FutureBuilder(
                        future: Sort(),
                        builder: (context,snapshot){
                          if(snapshot.connectionState == ConnectionState.waiting){return Center(child: CircularProgressIndicator(),);}

                          sortedData.clear();
                          for(var i=0 ; i < allData.length ; i++){
                            if(allData[i].service == c)
                              sortedData.add(allData[i]);
                          }
                          allData.clear();
                          allData.addAll(sortedData);

                          /////////////check if available/////////////
                          sortedData.clear();
                          for(var i=0 ; i < allData.length ; i++){
                            if(allData[i].endTime != "" && allData[i].startTime != ""){
                              DateTime end;
                              DateTime start;
                              var e = allData[i].endTime;
                              var s = allData[i].startTime;

                              if (e.length > 27){e = e.substring(0, 26) + e[e.length - 1]; }
                              if (s.length > 27){s = s.substring(0, 26) + s[s.length - 1]; }

                              end = DateTime.parse(e);
                              start = DateTime.parse(s);

                              if((!(end.isBefore(DateTime.now()))) && (allData[i].available != false) && !(start.isAfter(DateTime.now())))
                                sortedData.add(allData[i]);
                            }
                          }
                          allData.clear();
                          allData.addAll(sortedData);
                          /////////////check if available/////////////

                          if(sortBy=='distance')
                            sortByDistance();
                          if(sortBy=='price')
                            sortByPrice();
                          if(sortBy=='rating')
                            sortByRating();
                          return Container(child: _buildList());
                        },
                      ),
                    );
                  },
                );
              },
            )
        ),
      )
    );
  }
}