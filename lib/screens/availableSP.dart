import 'package:flutter/material.dart';
import 'package:yumnak/screens/HomePage.dart';

class availableSP extends StatefulWidget {
  @override
  _availableSPState createState() => _availableSPState();
}

/*   SORTING
List<double> numbers = [1, 2, 3];
// Sort from shortest to longest.
numbers.sort((b, a) => a.compareTo(b));
print(numbers);  // [two, four, three]
*/



/*
Widget avaiable(BuildContext context, Record record){
  return Card(
    key: ValueKey(record.name),
    elevation: 8.0,
    margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
    child: Container(
      decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
      child: ListTile(
        contentPadding:
        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            decoration: new BoxDecoration(
                border: new Border(
                    right: new BorderSide(width: 1.0, color: Colors.white24))),
            child: Hero(
                tag: "avatar_" + record.name,
                child: CircleAvatar(
                  radius: 32,
                  backgroundImage: NetworkImage(record.photo),
                )
            )
        ),
        title: Text(
          record.name,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          children: <Widget>[
            new Flexible(
                child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          text: record.address,
                          style: TextStyle(color: Colors.white),
                        ),
                        maxLines: 3,
                        softWrap: true,
                      )
                    ]))
          ],
        ),
        trailing:
        Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
        onTap: () {},
      ),
    ),
  );

}*/

class _availableSPState extends State<availableSP> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
          title: new Center(child: new Text("موفري الخدمة المتاحين", textAlign: TextAlign.center, style: TextStyle(color: Colors.lightBlueAccent, fontSize: 25.0, fontFamily: "Montserrat"))),
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
        body:


    );
  }
}
