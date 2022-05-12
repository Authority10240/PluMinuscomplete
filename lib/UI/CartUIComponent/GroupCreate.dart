import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:treva_shop_flutter/BackEnd/DBHelper.dart';
import 'package:treva_shop_flutter/DataModels/GroupModel.dart';
import 'package:credit_card_number_validator/credit_card_number_validator.dart';
import 'package:treva_shop_flutter/DataModels/MemberModel.dart';
import 'package:treva_shop_flutter/DataModels/StaticValues.dart';
import 'package:treva_shop_flutter/UI/CartUIComponent/CartLayout.dart';
import 'package:firebase_database/firebase_database.dart';
import 'QRView.dart';
import 'package:treva_shop_flutter/DataModels/GROUP_INFORMATION.dart';
import 'package:sqflite/sqflite.dart';
import 'package:treva_shop_flutter/UI/BottomNavigationBar.dart';
import 'BankCreate.dart';
class GroupCreate extends StatefulWidget {
  @override
  _GroupCreateState createState() => _GroupCreateState();
}

class _GroupCreateState extends State<GroupCreate> {
  @override
  GlobalKey _globalKey = new GlobalKey();
  String _dataString = "Create QR";
  GroupModel gm = new GroupModel.blank();
  DatabaseReference ref, refm ;
  String bank = '(BANK NAME)', password1 = '' , password2='';
  DBHelper db_helper = DBHelper();


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,backgroundColor: Colors.grey,
        title: Text('Create Group',style: TextStyle(color: Colors.white),),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 15,),
          Center(
            child:
            Text('Group Information',style:TextStyle(color: Colors.grey, fontSize: 20)
            ) ,),

          SizedBox(height: 10,),
          textFromField(
            icon: Icons.group,
            password: false,
            email: "Group Name*",
            inputType: TextInputType.emailAddress,
            textFieldNumber: 0,
            gm: gm,
          ),
          SizedBox(height: 10,),
          textFromField(
            icon: Icons.group_work,
            password: false,
            email: "Group Department*",
            inputType: TextInputType.emailAddress,
            textFieldNumber: 1,
            gm: gm,
          ),
          SizedBox(height: 10,),
          textFromField(
            icon: Icons.blur_on,
            password: false,
            email: "Group Password*",
            inputType: TextInputType.emailAddress,
            textFieldNumber: 3,
            gm: gm,
          ),
          SizedBox(height: 10,),
          textFromField(
            icon: Icons.blur_linear,
            password: false,
            email: "Confirm Password*",
            inputType: TextInputType.emailAddress,
            textFieldNumber: 4,
            gm: gm,
          ),
          SizedBox(height: 20,),
          Container( padding: EdgeInsets.all(20),child:FlatButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              padding: EdgeInsets.symmetric( horizontal:30.0),
              onPressed: () {
                validateValues();
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

      ),
    );
  }

  bool validateValues(){
    populateAdminDetails();
    if(validateFields()){
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => new BankCreate(gm)));

    }


  }

  bool validateCard(){
    bool isValid = false;
    if(gm.bankModel.cardNumber.toString().length < 12 || gm.bankModel.cardNumber> 8){
      isValid = true;
    }

    return
        isValid;
  }

  bool validateFields(){
    bool validinfo = false;
    if( gm.groupName.isEmpty){
      Confirm(context, 'Empty Group Name', 'Please Enter Group Name');
    }else if(gm.groupDepartment.isEmpty){
      Confirm(context, 'Empty Group Department', 'Please Enter Group Department ');
    }else if(gm.group_password.isEmpty) {
      Confirm(context, 'Empty or non-matching passwords entered', 'Please insert matching passwords before attempting to create group');
    }else {
      validinfo = true;
    }
    return validinfo;
  }

  populateAdminDetails(){
    gm.groupAdmin.memberEmployeeNumber = StaticValues.employeeNumber;
    gm.groupAdmin.memberName =  StaticValues.userName;
    gm.groupAdmin.memberOccupation = StaticValues.occupation;
    gm.groupAdmin.memberPictureAsset = StaticValues.userDisplayPicture;
    gm.groupAdmin.memberSurname =  StaticValues.userSurname;
  }

}

class textFromField extends StatelessWidget {
  bool password;
  String email, password1 , password2;
  IconData icon;
  TextInputType inputType;
  int textFieldNumber;
  GroupModel gm;

  textFromField({this.email, this.icon, this.inputType, this.password ,
    this.textFieldNumber, this.gm});

  @override
  Widget build(BuildContext context) {
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

                    letterSpacing: 0.3,
                    color: Colors.black38,
                    fontWeight: FontWeight.w600)),

            keyboardType: inputType,
            onChanged: (value){

                  if(textFieldNumber ==3 || textFieldNumber == 4){
                    switch (textFieldNumber){
                      case 3:  gm.cpassword2= value;
                      break;
                      case 4: gm.confirmpasswrod = value;
                      break;
                    }

                    if(gm.cpassword2 == gm.confirmpasswrod){
                      gm.group_password = value;
                    }
                  }
                  switch (textFieldNumber) {
                    case 0:
                      gm.groupName = value;
                      break;
                    case 1:
                      gm.groupDepartment = value;
                      break;
                    case 2:
                      gm.bankModel.cardNumber = value;
                      break;

                  }
            },
          ),
        ),
      ),
    );
  }
}
class BasicDateField extends StatelessWidget {
  final format = DateFormat("MM-yy");
  GroupModel gm;

  BasicDateField( this.gm);
  @override

  Widget build(BuildContext context) {
    return Padding( padding: EdgeInsets.symmetric(horizontal: 30.0),
      child:Column(children: <Widget>[
      Text('Expiration Date (${format.pattern})',style: TextStyle(
      fontSize: 15.0,
      
      letterSpacing: 0.3,
      color: Colors.black38,
      fontWeight: FontWeight.w600,),
      ),
      DateTimeField(
        onChanged: (value){
          gm.bankModel.expirationDate = value.month.toString() +'/'+ value.year.toString();
        },
        format: format,
        onShowPicker: (context, currentValue) {
          return showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
        },
      ),
    ]),
    ); }
}

Confirm(BuildContext context, String title,
    String description) {
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

GroupCreated(BuildContext context, String title,
    String description, GroupModel gm) {
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
              child: Text('Continue', style: TextStyle(color: Colors.black)),
              onPressed: () {

              },
            ),

          ],
        );
      }
  );




}

String generateQRString(GroupModel gm){
  return  gm.groupName.trim() +':'+ gm.groupDepartment.trim()+':'
      +gm.bankModel.cardNumber.trim()+':'+ gm.bankModel.BankName.trim() +':';// requires the user employee number here.

}



