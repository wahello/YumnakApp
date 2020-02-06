
class User {

  final String uid;

  User({this.uid});

  String _phoneNumber;
  String _name;
  String _email;
  String _password;
  var _location;
  String _userType;

  //User(this._phoneNumber, this._name, this._email, this._password, this._location, this._userType);

  set phoneNumber(String pNum){
    phoneNumber=pNum;
  }
  set name(String n){
    name=n;
  }
  set email(String e){
    email=e;
  }
  set password(String p){
    password=p;
  }
  set location(var l){
    location=l;
  }
  set userType(String uType){
    userType=uType;
  }

  String get phoneNumber => phoneNumber;
  String get name => name;
  String get email => email;
  String get password => password;
  //var get location => location;
  String get userType => userType;
}