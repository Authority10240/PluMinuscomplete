import 'package:flutter/material.dart';
import 'package:treva_shop_flutter/DataModels/Cards.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:treva_shop_flutter/DataModels/StaticValues.dart';
import 'package:treva_shop_flutter/UI/HomeUIComponent/BalanceTable.dart';

class BalanceCard extends StatefulWidget {
  @override
  _BalanceCardState createState() => _BalanceCardState(year , month);
  String year="", month="";
  BalanceCard(this.year,  this.month);
}

class _BalanceCardState extends State<BalanceCard> {
  @override
  String year= "" , month="", Department="" , name='';
  DatabaseReference ref;
  _BalanceCardState(this.year, this.month);
  List<String> cards, names , departments;

  Widget build(BuildContext context) {
    if(cards == null){
      cards = List();
      names = List();
      departments = List();
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white ,centerTitle: true, title:Text("Select Account", style: TextStyle(color: Colors.grey),),),
      body: ListView.builder(itemBuilder: (BuildContext context, int i){
        return Card(elevation: 7,
          child:ListTile(leading: CircleAvatar(backgroundColor: Colors.grey,
            child: Text(names[i][0], style: TextStyle(color: Colors.white),),),title: Text(names[i], style: TextStyle(),),subtitle:Text(cards[i], style: TextStyle()) ,
              onTap:(){
              Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => new BalanceSheet(year,month,cards[i],names[i],departments[i])) );
            },) );
      }, itemCount: cards.length,),  
    );
    
  }


  updateListView(){
    ref = FirebaseDatabase.instance.reference()
        .child('THIS_COMPANY').child('STATEMENTS')
        .child(StaticValues.splitEmailForFirebase(StaticValues.employeeNumber))
        .child(year).child(month);
    ref.onChildAdded.listen((data){
        List<String> info = data.snapshot.key.split('_');
        cards.add(info[0]);
        names.add(info[2]);
        departments.add(info[1]);
        Department = info[1];
        name = info[2];

        setState(() {

        });
    });

  }
}
