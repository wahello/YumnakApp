import 'package:flutter/material.dart';
import 'package:yumnak/models/user.dart';

class Customer extends User{
  List<CustomerRate> _rateArray;
  double _avgRate;

  //Customer(String phoneNumber, String name, String email, String password, var location, String userType, this._rateArray, this._avgRate)
    //  :super(phoneNumber, name, email, password, location, userType);


  set rateArray(List<CustomerRate> rate){
    location=rate;
  }
  
  set avgRate(double avg){
    avgRate=avg;
  }

  List<CustomerRate> get rateArray => rateArray;
  double get avgRate => avgRate;

}

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
}