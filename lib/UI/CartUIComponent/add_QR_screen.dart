import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:qrcode_reader/qrcode_reader.dart';
import 'package:flutter/services.dart';
import 'package:treva_shop_flutter/BackEnd/DBHelper.dart';

import 'package:flutter/scheduler.dart';
import 'package:treva_shop_flutter/DataModels/GROUP_INFORMATION.dart';
import 'package:treva_shop_flutter/DataModels/MemberModel.dart';
import 'package:treva_shop_flutter/DataModels/StaticValues.dart';
import 'package:treva_shop_flutter/UI/CartUIComponent/CartLayout.dart';
import 'package:treva_shop_flutter/UI/CartUIComponent/GroupCreate.dart';
import 'package:treva_shop_flutter/UI/CartUIComponent/ListGroups.dart';
import 'package:treva_shop_flutter/UI/OnBoarding.dart';





class QRCodeAddScreen extends StatefulWidget {


  @override
  State<StatefulWidget> createState() {

    // TODO: implement createState
    return new QRState();
  }
}

  class QRState extends State<QRCodeAddScreen> {


    int count = 0;
    String result = 'Click Scan and scan Group QR code from administrator',child= '*Select Student',
    employeeNumber ="";
    DBHelper dbHelper = DBHelper();
    DatabaseReference ref;
    Future _scanQR() async {
      try {
        String qrResult = await QRCodeReader().scan();
        //result = await AESCrypt().decryptString(qrResult);
        List<String> values = qrResult.split(':');
        GroupCreated(context, 'Add Group',
            'Department: ${values[1]} \n Group Name: ${values[0]} \n Admin: ${values[2]}',
            GROUP_INFORMATION(values[1], values[0], values[2],'PG'));
      } catch (e) {

      }
    }

      GroupCreated(BuildContext context, String title,
          String description, GROUP_INFORMATION gi) {
        return showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(

                title: Text(title,),
                elevation: 7.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text(description),

                    ],
                  ),
                ),
                actions: <Widget>[

                  FlatButton(
                    child: Text('Join Group', style: TextStyle(color: Colors.black)),
                    onPressed: () {
                      dbHelper.addNewGroup(gi);
                      writeToFirebase(gi);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) => cart()));

                    },
                  ),
                  FlatButton(
                    child: Text('Cancel', style: TextStyle(color: Colors.black)),
                    onPressed: () {
                      Navigator.pop(context);

                    },
                  ),
                ],
              );
            }
        );




      }




    @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return Scaffold(
        appBar: AppBar(centerTitle: true, title: Text('Add Group'),),
        body:Container(child:Column(
          children: <Widget>[
            SizedBox(height: 10,),
           Center( child: Text('Enter Administrator\'s Email address Number Below:',textAlign: TextAlign.center,style: TextStyle(fontSize: 15,color: Colors.grey),),),
            SizedBox(height: 5,),
            TextEditBox(false, 'Enter Admin Email', Icons.alternate_email, TextInputType.text),
            SizedBox(height: 20,),
            Container( padding: EdgeInsets.all(20),
              child:FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              padding: EdgeInsets.symmetric( horizontal:30.0),
              onPressed: () {
                checkValue(employeeNumber.trim());
              },
              child: Text(
                "Next",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              color: Colors.grey,),)
          ],
        ),),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _scanQR,
          icon: Icon(Icons.camera),
          elevation: 7.0,
          backgroundColor: Colors.grey,
          tooltip: 'Scan subject QR Code',
          label: Text('Scan'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      );
    }

    checkValue(String employeenumber){
      if(employeenumber == ""){
        Confirm(context, 'Invalid Value', 'Please enter a value before attempting to search');

      }else{
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => new ListGroups(employeenumber)));
      }
    }

    Confirm(BuildContext context,  String title,
        String description) {
      return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              
              title: Text(title,),
              elevation: 7.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(description),

                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok', style: TextStyle(color: Colors.black)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),

              ],
            );
          }
      );
    }

 /*   Widget _drop_input(String hint) {
      return new DropdownButtonHideUnderline(
        child: new DropdownButton(
          style: TextStyle(color: Colors.black),

          items:getNames().map((String value){
            return DropdownMenuItem(
                child: Text(value),
                value: value,
                key: Key(value));
          }).toList(),
            value: child,
          elevation: 7,
          hint: Text(hint),
          iconSize: 40,
          onChanged: (value) {
            setState(() {
              child = value;
              getStudent(value);
            });
          },
        ),
      );
    }

    prepareContact(String QRresult) {

    }




    decryptQRCode(){

    }

    /*
                String Device_ID = MainScreen.cEmployeeNumber;
                String User_Department = token.nextToken();
                String User_Course = token.nextToken();
                String User_Subject = token.nextToken();
                String User_ID = token.nextToken();
                String Institution = token.nextToken(); // School name
                sSubject = User_Subject;
     */*/
 
 writeToFirebase(GROUP_INFORMATION gi){
   ref = FirebaseDatabase.instance.reference().child('THIS_COMPANY').child('GROUPS')
       .child(StaticValues.splitEmailForFirebase(gi.GROUP_ADMIN)).child(gi.GROUP_NAME).child(gi.DEPARTMENT).child('MEMBERS')
       .child(StaticValues.splitEmailForFirebase(StaticValues.employeeNumber));

   ref.set(MemberModel(StaticValues.userName, StaticValues.userSurname, StaticValues.occupation, StaticValues.userDisplayPicture, StaticValues.employeeNumber).toMap());
 }


 Widget TextEditBox(bool password, String email, IconData icon, TextInputType inputType){

     return Padding(
       padding: EdgeInsets.symmetric(horizontal: 30.0),
       child: Container(
         height: 60.0,
         alignment: AlignmentDirectional.center,
         decoration: BoxDecoration(
             borderRadius: BorderRadius.circular(14.0),
             color: Colors.white,
             boxShadow: [BoxShadow(blurRadius: 10.0, color: Colors.black12)]),
         padding:
         EdgeInsets.only(left: 20.0, right: 30.0, top: 0.0, bottom: 0.0),
         child: Theme(
           data: ThemeData(
             hintColor: Colors.transparent,
           ),
           child: TextField(
             obscureText: password,
             decoration: InputDecoration(
                 border: InputBorder.none,
                 labelText: email,
                 icon: Icon(
                   icon,
                   color: Colors.black38,
                 ),
                 labelStyle: TextStyle(
                     fontSize: 15.0,
                     fontFamily: 'Gotik',
                     letterSpacing: 0.3,
                     color: Colors.black38,
                     fontWeight: FontWeight.w600)),

             keyboardType: inputType,
             onChanged: (value){

               employeeNumber = value;
             },
           ),
         ),
       ),
     );

 }

      }





