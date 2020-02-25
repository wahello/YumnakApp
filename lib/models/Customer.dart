import 'package:yumnak/models/user.dart';

class Customer extends User{

  String name;
  String email;
  String password;
  var uid;
  String phoneNumber;
  var lat;
  var lng;
  String locComment;

  Customer();

}

/*
class CustomerRate {
  String _id;
  DateTime _dateTime;
  double _stars;

  CustomerRate(this._id, this._dateTime, this._stars);

  set id (String i){
    id=i;
  }
  set dateTime(DateTime dt){
    dateTime=dt;
  }
  set stars(double s){
    stars=s;
  }

  String get id => id;
  DateTime get dateTime => dateTime;
  double get stars => stars;
}*/
