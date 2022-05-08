import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:treva_shop_flutter/DataModels/StaticValues.dart';
import 'package:treva_shop_flutter/UI/HomeUIComponent/BalanceMonth.dart';
import 'dart:async';
class BalanceYear extends StatefulWidget {
  @override
  _BalanceYearState createState() => _BalanceYearState(transaction: this.transaction);

  bool transaction;
  int type;
  BalanceYear( {this.transaction = false, this.type} );


}

class _BalanceYearState extends State<BalanceYear> {
  List<String> year ;
  bool transaction;
  int type;
  _BalanceYearState({this.transaction = false, this.type });
  @override
  Widget build(BuildContext context) {



    if(year == null){
      year = List();
      updateListView();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        showProgressIndicator(context);
        startTime();
      });
    }
    return Scaffold(appBar: AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Text('Statement Year',style: TextStyle(color: Colors.grey),),
    ),
    body: ListView.builder(itemCount: year.length,itemBuilder: (BuildContext context, int pos){
      return Card(
        elevation: 7,
        child: ListTile(
          leading: CircleAvatar(child: Text(year[pos][2]+year[pos][3], style: TextStyle(color: Colors.white),),backgroundColor: Colors.grey,),
          title: Text(year[pos]),
          onTap: (){
            Navigator.push(context,  MaterialPageRoute(builder: (context) => new BalanceMonth(year[pos], transaction: this.transaction,),));
          },
        ),
      );


    },),);
  }
  startTime() async {
    return new Timer(Duration(milliseconds: 2500), checkGroupList);
  }

  checkGroupList(){
  Navigator.pop(context);
  }



  showProgressIndicator(BuildContext context){
    return showDialog(context: context, barrierDismissible: false, builder: (BuildContext contect){
      return Container(width: 50 , child: Column(children: <Widget>[
        SizedBox(height: MediaQuery.of(context).size.height/2,),
        CircularProgressIndicator(),

      ],),);
    });
  }




  updateListView(){
    DatabaseReference backup = FirebaseDatabase.instance.reference()
        .child('THIS_COMPANY').child('STATEMENTS').child(StaticValues.splitEmailForFirebase(StaticValues.employeeNumber));
    backup.onChildAdded.listen((onData){

      year.add(onData.snapshot.key);
      setState(() {

      });

    });

  }
}
