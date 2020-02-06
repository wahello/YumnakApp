import 'package:yumnak/models/user.dart';

class ServiceProvider extends User{
  String _gender;
  String _experience;
  bool _available;
  List<ServiceProviderRate> _rateArray;
  String _priceType; //??
  double _price;
  var _attachement;
  String _service;
  double _avgRate;
  DateTime _startHour;
  DateTime _endHour;

  //ServiceProvider(String phoneNumber, String name, String email, String password, var location, String userType, this._gender, this._experience, this._available, this._rateArray, this._priceType, this._price, this._attachement, this._service, this._avgRate, this._startHour, this._endHour)
    //  :super(phoneNumber, name, email, password, location, userType);

  set gender (String g){
    gender=g;
  }
  set experience (String ex){
    experience=ex;
  }
  set available (bool av){
    available=av;
  }
 /* set rateArray(List<CustomerRate> rate){
    location=rate;
  }*/
  set priceType (String pType){
    priceType=pType;
  }
  set price(double p){
    price=p;
  }
  set attachement (var att){
    attachement=att;
  }
  set service (String s){
    service=s;
  }
  set avgRate(double avg){
    avgRate=avg;
  }
  set startHour(DateTime sHour){
    startHour=sHour;
  }
  set endHour(DateTime eHour){
    endHour=eHour;
  }

  String get gender => gender;
  String get experience => experience;
  bool get available => available;
/*
  List<CustomerRate> get rateArray => rateArray;
*/
  String get priceType => priceType;
  double get price => price;
  //var get attachement => attachement;
  String get service => service;
  double get avgRate => avgRate;
  DateTime get startHour => startHour;
  DateTime get endHour => endHour;
}

class ServiceProviderRate {
  String _id;
  int _time;
  int _quality;
  int _price;
  int _cooperation;
  DateTime _dateTime;
  String _review;

  ServiceProviderRate(this._id, this._time, this._quality, this._price, this._cooperation, this._dateTime, this._review);

  set id (String i){
    id=i;
  }
  set time(int t){
    time=t;
  }
  set quality(int q){
    quality=q;
  }
  set price(int p){
    price=p;
  }
  set cooperation(int coop){
    cooperation=coop;
  }
  set dateTime(DateTime dt){
    dateTime=dt;
  }
  set review(String rev){
    review=rev;
  }

  String get id => id;
  int get time => time;
  int get quality => quality;
  int get price => price;
  int get cooperation => cooperation;
  DateTime get dateTime => dateTime;
  String get review => review;
}