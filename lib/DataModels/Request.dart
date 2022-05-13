import 'package:flutter/material.dart';
import 'package:treva_shop_flutter/DataModels/ItemsModel.dart';
import 'package:treva_shop_flutter/DataModels/StaticValues.dart';
class Request{
  String Title = "", Response ="Awaiting Response", proofOfPurchase = "" ,
      proofOfPaynent="", reason="Awaiting Response", date = "" , time=""
 , DEPARTMENT = "" , GROUP_NAME = "" , GROUP_ADMIN = "", STATUS="", ACTUAL_AMOUNT="0.00"
  ,DAY = "", MONTH ="", YEAR="", REQUEST_ID = "" , REQUESTER="", ACTUAL_AMOUNT_DATE="",
  ACCOUNT_NUMBER ="", REQUESTED_AMOUNT = "0.00", REQUEST_VAT="", AVAILABLE_BALANCE="0.00",
  TRANSACTION_TYPE = "", ACTUAL_AMOUNT_PAID="0.00";
  List<Items> items = [];
  Request();
  DateTime ORDER_DATE;

  Request.FromMap(String name,var map , String type){
    Map info ;
    Map object;
    if(type == 'T') {
      object = map?.values?.elementAt(0);
      info = object.values?.elementAt(0);
    }else{
     info = map?.values?.elementAt(0);
    }

    Title = name;
    REQUEST_ID=info["REQUEST_ID"];
    proofOfPurchase = info['PROOF_OF_PURCHASE'];
    proofOfPaynent = info['PROOF_OF_PAYMENT'];
    Response = info['RESPONSE'];
    reason = info['REASON'];
    date = info['DATE'];
    time = info['TIME'];
    STATUS = info['STATUS'];
    ACTUAL_AMOUNT = info['ACTUAL_AMOUNT'];
    ACTUAL_AMOUNT_DATE = info['ACTUAL_AMOUNT_DATE'];
    DAY = info["DAY"];
    MONTH = info["MONTH"];
    YEAR = info["YEAR"];
    ACCOUNT_NUMBER = info["ACCOUNT_NUMBER"];
    REQUESTER = info["REQUESTER"];
    REQUESTED_AMOUNT = info["REQUESTED_AMOUNT"];
    REQUEST_VAT = info['REQUEST_VAT'];
    AVAILABLE_BALANCE = info['ACCOUNT_BALANCE'];
    DEPARTMENT = info['DEPARTMENT'];
    GROUP_NAME = info['GROUP_NAME'];
    GROUP_ADMIN = info['GROUP_ADMIN'];
    TRANSACTION_TYPE = info['TRANSACTION_TYPE'];
    ACTUAL_AMOUNT_PAID = info['ACTUAL_AMOUNT_PAID'];
    Title = info['TITLE'];
    ORDER_DATE = info['ODER_DATE'];



    List<dynamic> check;
    if(type == 'T'){
      check = object.values.elementAt(1);
    }else{
      check = map.values.elementAt(1);
    }
    for( int i = 0 ; i < check.length; i++)
    items.add(Items.fromMap(check[i]));
  }

  Request.Statement(var info){
    Title = info['TITLE'];
    REQUEST_ID=info["REQUEST_ID"];
    proofOfPurchase = info['PROOF_OF_PURCHASE'];
    proofOfPaynent = info['PROOF_OF_PAYMENT'];
    Response = info['RESPONSE'];
    reason = info['REASON'];
    date = info['DATE'];
    time = info['TIME'];
    STATUS = info['STATUS'];
    ACTUAL_AMOUNT = info['ACTUAL_AMOUNT'];
    ACTUAL_AMOUNT_PAID = info['ACTUAL_AMOUNT_PAID'];
    ACTUAL_AMOUNT_DATE = info['ACTUAL_AMOUNT_DATE'];
    DAY = info["DAY"];
    MONTH = info["MONTH"];
    YEAR = info["YEAR"];
    REQUESTER = info["REQUESTER"];
    items = List();
    ACCOUNT_NUMBER = info["ACCOUNT_NUMBER"];
    REQUESTED_AMOUNT = info["REQUESTED_AMOUNT"];
    REQUEST_VAT = info['REQUEST_VAT'];
    AVAILABLE_BALANCE = info['ACCOUNT_BALANCE'];
    DEPARTMENT = info['DEPARTMENT'];
    GROUP_NAME = info['GROUP_NAME'];
    GROUP_ADMIN = info['GROUP_ADMIN'];
    TRANSACTION_TYPE = info['TRANSACTION_TYPE'];
    ORDER_DATE = info['ODER_DATE'];
  }

  Request.FromFirebaseMap(var map){
    Map info = map.values.elementAt(0);
    Title = info['TITLE'];
    REQUEST_ID=info["REQUEST_ID"];
    proofOfPurchase = info['PROOF_OF_PURCHASE'];
    proofOfPaynent = info['PROOF_OF_PAYMENT'];
    Response = info['RESPONSE'];
    reason = info['REASON'];
    date = info['DATE'];
    time = info['TIME'];
    STATUS = info['STATUS'];
    ACTUAL_AMOUNT = info['ACTUAL_AMOUNT'];
    ACTUAL_AMOUNT_DATE = info['ACTUAL_AMOUNT_DATE'];
    DAY = info["DAY"];
    MONTH = info["MONTH"];
    YEAR = info["YEAR"];
    REQUESTER = info["REQUESTER"];
    ACCOUNT_NUMBER = info["ACCOUNT_NUMBER"];
    REQUESTED_AMOUNT = info["REQUESTED_AMOUNT"];
    REQUEST_VAT = info['REQUEST_VAT'];
    AVAILABLE_BALANCE = info['ACCOUNT_BALANCE'];
    TRANSACTION_TYPE = info['TRANSACTION_TYPE'];
    DEPARTMENT = info['DEPARTMENT'];
    GROUP_NAME = info['GROUP_NAME'];
    GROUP_ADMIN = info['GROUP_ADMIN'];
    ORDER_DATE = info['ODER_DATE'];
    List<dynamic> check = map.values.elementAt(1);

    for( int i = 0 ; i < check.length; i++)
      items.add(Items.fromMap(check[i]));
  }

  Map toMap(){
    Map map = Map();

    map['TITLE'] = Title;
    map['RESPONSE'] = Response;
    map['PROOF_OF_PAYMENT'] = proofOfPaynent;
    map['PROOF_OF_PURCHASE'] = proofOfPurchase;
    map['REASON'] = reason;
    map['DATE'] = "${DateTime.now().year.toString()}/${DateTime.now().month.toString()}/${DateTime.now().day.toString()}";
    map['TIME'] = "${getTime()}";
    map['STATUS'] = 'ACTIVE';
    map['ACTUAL_AMOUNT'] =ACTUAL_AMOUNT;
    map["DAY"] = DateTime.now().day.toString();
    map["MONTH"]=DateTime.now().month.toString();
    map["YEAR"] = DateTime.now().year.toString();
    map["REQUEST_ID"] = Title+DateTime.now().day.toString()+DateTime.now().month.toString()+ DateTime.now().year.toString();
    map["REQUESTER"] = StaticValues.employeeNumber;
    map["ACTUAL_AMOUNT_DATE"] = ACTUAL_AMOUNT_DATE;
    map["ACCOUNT_NUMBER"] = ACCOUNT_NUMBER;
    map['REQUESTED_AMOUNT'] = REQUESTED_AMOUNT;
    map['REQUEST_VAT'] = REQUEST_VAT;
    map['ACCOUNT_BALANCE'] = AVAILABLE_BALANCE;
    map['DEPARTMENT'] = DEPARTMENT;
    map['GROUP_NAME'] = GROUP_NAME;
    map['GROUP_ADMIN'] = GROUP_ADMIN;
    map['TRANSACTION_TYPE']  = TRANSACTION_TYPE;
    map['ACTUAL_AMOUNT_PAID']= ACTUAL_AMOUNT_PAID  ;
    map['ORDER_DATE'] = DateTime.now();

    return map;
  }

  Map setRequestURLToMap(String url){
    Map map = Map();
    map['PROOF_OF_PAYMENT'] = url;

    return map;
  }

  getTime(){
    return  addZero(DateTime.now().hour) + ':' + addZero(DateTime.now().minute);
  }
  
  String addZero(int number){
    if(number<10){
      return '0$number';
    }else{
      return '$number';
    }
  }
}