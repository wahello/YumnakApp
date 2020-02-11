class Order {
  String _cusName;
  String _SPName;
  String _orderNumber;
  String _orderDate;
  String _status;
  String _customerDescription;
  var _location;
  int _serviceTime;

  Order(this._cusName,this._SPName,this._orderNumber, this._orderDate, this._status, this._customerDescription, this._location, this._serviceTime);

  set orderNumber(String oNum){
    orderNumber=oNum;
  }
  set orderDate(var oDate){
    orderDate=oDate;
  }
  set status(String s){
    status=s;
  }
  set customerDescription(String cDes){
    customerDescription=cDes;
  }
  set location(var l){
    location=l;
  }
  set serviceTime(String sTime){
    serviceTime=sTime;
  }

  String get cusName => _cusName;
  String get SPName => _SPName;
  String get orderNumber => orderNumber;
 String get orderDate => orderDate;
  String get status => status;
  String get customerDescription => customerDescription;
  //var get location => location;
  String get serviceTime => serviceTime;
}