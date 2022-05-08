import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:treva_shop_flutter/DataModels/Request.dart';
import 'package:treva_shop_flutter/DataModels/StaticValues.dart';
import 'package:treva_shop_flutter/UI/HomeUIComponent/BalanceCard.dart';

import 'BalanceTable.dart';

class BalanceMonth extends StatefulWidget {
  @override
  _BalanceMonthState createState() => _BalanceMonthState(year, transaction: this.transaction );
  bool transaction;
  int type;
  BalanceMonth(this.year , {this.transaction, this.type});
  String year ="";
}

class _BalanceMonthState extends State<BalanceMonth> {
  List<String> months;
  String year = "";
  int type;
bool transaction ;
  _BalanceMonthState(this.year , {this.transaction, this.type} );
  @override
  Widget build(BuildContext context) {
    if(months == null){
      months = List();
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(centerTitle: true,
      title: Text('$year Statement Months',style: TextStyle(color: Colors.grey),),
      backgroundColor: Colors.white,),
      body: ListView.builder(itemCount: months.length,itemBuilder: (BuildContext context , int pos){
        return Card(elevation: 7,
        child: ListTile(
          leading: CircleAvatar(child: Text(months[pos],style: TextStyle(color: Colors.white),),backgroundColor: Colors.grey,),
          title: Text(getMonthName(months[pos])) ,
          onTap: (){
            Navigator.push(context,  MaterialPageRoute(builder: (context) => new BalanceCard(year,months[pos], transaction: this.transaction,)));
          },
        ),);
      },),
    );
  }



  String getMonthName(String month){
    String newMonth = "";
    switch(month){
      case '1': newMonth = "January";
      break;
      case '2': newMonth = "February";
      break;
      case '3': newMonth = "March";
      break;
      case '4': newMonth = "April";
      break;
      case '5': newMonth = "May";
      break;
      case '6': newMonth = "June";
      break;
      case '7': newMonth = "July";
      break;
      case '8': newMonth = "August";
      break;
      case '9': newMonth = "September";
      break;
      case '10': newMonth = "October";
      break;
      case '11': newMonth = "November";
      break;
      case '12': newMonth = "December";
      break;


    }
    return newMonth;
  }

  updateListView(){
    DatabaseReference backup = FirebaseDatabase.instance.reference()
        .child('THIS_COMPANY').child('STATEMENTS').child(StaticValues.splitEmailForFirebase(StaticValues.employeeNumber))
        .child(year);

    backup.onChildAdded.listen((data){
      months.add(data.snapshot.key);
      setState(() {

      });
    });
  }
}
