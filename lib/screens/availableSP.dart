import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:yumnak/screens/HomePage.dart';

class availableSP extends StatefulWidget {
  String _cat;
  availableSP(this._cat);
  @override
  _availableSPState createState() => _availableSPState(_cat);
}
int countSP;
List<myData> allData = [];
List<myData> _SPData = [];


//--------------------------------------------------------------------


class myData {
  String email,name, phoneNumber, service,subService;
  var uid;

  myData(this.email,this.name, this.phoneNumber,this.service, this.subService,this.uid);
}


Widget _buildList() {
  return ListView(
    padding: const EdgeInsets.only(top: 20.0),
    //  children: this._filteredRecords.records.map((data) => _buildListItem(context, data)).toList(),
    children: <Widget>[
      for (var i=0 ;i<_SPData.length;i++)
        _buildListItem(_SPData[i])
    ],
  );
}


Widget _buildListItem(myData d) {
  return Card(
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
              subtitle: Text(d.phoneNumber),
                onTap: () { /* react to the tile being tapped */ }
            ),

          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                   children: <Widget>[
                     Padding(
                     padding: EdgeInsets.fromLTRB(15, 0, 10, 5),
                     child: Text("السعر",style: TextStyle(fontSize:18,fontWeight: FontWeight.bold)),
                   ),
                   Text("100")]
                  ),
                  Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 10, 5),
                          child: Text("المسافة",style: TextStyle(fontSize:18,fontWeight: FontWeight.bold)),
                        ),
                        Text("xxxxx")]
                  ),
                  Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 10, 5),
                          child: Text("التقييم",style: TextStyle(fontSize:18,fontWeight: FontWeight.bold)),
                        ),
                        Text("★ 5")]
                  ),
                ]
            ),
          ),

        ],
      ),
    ),

  );
}

/*   SORTING
List<double> numbers = [1, 2, 3];
// Sort from shortest to longest.
numbers.sort((b, a) => a.compareTo(b));
print(numbers);  // [two, four, three]
*/


class _availableSPState extends State<availableSP> {
  String c;
  _availableSPState(String cat){
    c=cat;
    print(c);
  }


  void initState() {
    super.initState();
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    ref.child('Service Provider').once().then((DataSnapshot snap) async {
      var keys = snap.value.keys;
      var data = snap.value;

      allData.clear();
      myData d;
      for (var key in keys) {
        d = new myData(
          data[key]['email'],
          data[key]['name'],
          data[key]['phoneNumber'],
          data[key]['service'],
          data[key]['subService'],
          data[key]['uid'],
        );
       await allData.add(d);
      }

      for (var i = 0; i < allData.length; i++) {
        if(allData[i].service == c){
          _SPData.add(allData[i]);
          print(allData[i].name);
          print(allData[i].phoneNumber);
          print(allData[i].service);
          print(allData[i].subService);}
      }


    }
    );

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Center(child: new Text(c, textAlign: TextAlign.center, style: TextStyle(color: Colors.lightBlueAccent, fontSize: 25.0, fontFamily: "Montserrat"))),
       // title: new Center(child: new Text("موفري الخدمة المتاحين", textAlign: TextAlign.center, style: TextStyle(color: Colors.lightBlueAccent, fontSize: 25.0, fontFamily: "Montserrat"))),
       //automaticallyImplyLeading: false,     //عشان يروح سهم الرجوع
        backgroundColor: Colors.grey[200],

          actions: <Widget>[
      Padding(
      padding: EdgeInsets.only(right: 20.0),
        child: GestureDetector(
          onTap: () { Navigator.push(context, new MaterialPageRoute(builder: (context) => HomePage()));},
          child: Icon(Icons.home,
            color: Colors.black26,
            size: 26.0,),
        )
    ),
          ]
      ),


        body:_buildList()

    );
  }
}
