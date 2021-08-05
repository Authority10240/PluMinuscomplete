import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:treva_shop_flutter/UI/HomeUIComponent/HelpPages.dart';

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( leading:GestureDetector(onTap: (){
        Navigator.pop(context);
      },child: Icon(Icons.arrow_back, color: Colors.grey,),),title:Text('Help',style: TextStyle(fontFamily: "Gotik",color: Colors.grey,fontSize: 35)),centerTitle: true,backgroundColor:Colors.white ,),
      body: ListView(
        children: [
          Container(child: ListTile(title:Text('Tutorial',style: TextStyle(fontFamily: "Gotik",color: Colors.white,fontSize: 35),textAlign: TextAlign.center,),),margin: EdgeInsets.all(20), decoration: BoxDecoration(gradient:LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color.fromRGBO(150, 150, 150, 100),
              const Color.fromRGBO(100, 100, 100, 100),
            ],),
            borderRadius: BorderRadius.circular(100),
          ),),
          Container(padding: EdgeInsets.all(20),
            child: Text('Plus Minus is intended to be used '
                'along with actual bank account that is designated for petty cash purposes. This help '
                'document is derived to assist users in setting up groups as either an administrator or '
                'joining an existing groups as a member of that particular department. The next step '
                'consist of group members making request for items, pending the approval of the '
                'request by the designated group admin. Followed by the transaction taking '
                'place,admin receiving the proof of purchase and recording the correct amount into the '
                'Balances tab and generating financial document for internal and external reporting. View receipts and invoices under the Transactions tab. The overall aim of the '
                'application is to make sure that the traditional petty cash system is conceptualized and '
                'digital for improved bookkeeping and administrative output to ease the load for '
                'accountants and auditors in the end.',style: _fontDescriptionStyle,textAlign: TextAlign.center,),
          ),
          Container(padding: EdgeInsets.only(top :50) ,child: FlatButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => new Help() ,),);
          },child: Text('Begin Tutorial', style: _fontDescriptionStyle,),height: 50,shape:new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0),)),)
        ],
      ),
    );
  }
  var _fontDescriptionStyle = TextStyle(
      fontFamily: "Gotik",
      fontSize: 20.0,
      color: Colors.black26,
      fontWeight: FontWeight.w400

  );
}
