import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:treva_shop_flutter/BackEnd/DBHelper.dart';
import 'package:treva_shop_flutter/DataModels/GroupModel.dart';
import 'package:credit_card_number_validator/credit_card_number_validator.dart';
import 'package:treva_shop_flutter/DataModels/MemberModel.dart';
import 'package:treva_shop_flutter/DataModels/Request.dart';
import 'package:treva_shop_flutter/DataModels/StaticValues.dart';
import 'package:treva_shop_flutter/UI/CartUIComponent/CartLayout.dart';
import 'package:firebase_database/firebase_database.dart';
import 'QRView.dart';
import 'package:treva_shop_flutter/DataModels/GROUP_INFORMATION.dart';
import 'package:sqflite/sqflite.dart';
import 'package:treva_shop_flutter/UI/BottomNavigationBar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
class BankCreate extends StatefulWidget {
  @override
  _BankCreateState createState() => _BankCreateState(gm);
  GroupModel gm ;

  BankCreate(this.gm);
}

class _BankCreateState extends State<BankCreate> {
  @override
  GlobalKey _globalKey = new GlobalKey();
  String _dataString = "Create QR";
  GroupModel gm  ;
  DatabaseReference ref, refm ;
  String bank = '(BANK NAME)', password1 = '' , password2='';
  DBHelper db_helper = DBHelper();
  String month ="", year="", card="",feeAmount="", department ='', name='', date="";

  _BankCreateState(this.gm);

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
            Text('Banking Information',style:TextStyle(color: Colors.grey, fontSize: 20)
            ) ,),


          SizedBox(height: 10,),
          Center(
            child:
            Text('Bank Name*',style:TextStyle(color: Colors.grey, fontSize: 15)
            ) ,),
          new Padding(padding: EdgeInsets.symmetric(horizontal: 30.0),child: DropdownButton<String>(items: <String> ['(BANK NAME)','ABSA BANK ','AFRICAN BANK','ALBARAK BANK','BIDVEST BANK',
          'CAPITEC BANK','FIRSTRAND BANK','FNB','GRINDROD BANK','HBZ BANK','INVESTEC BANK',
          'MERCENTILE BANK','NEDBANK GROUP','RAND MERCHENT','RMB BANK','SABA BANK',
          'SASFIN BANK','TYME BANK','STANDARD BANK','WESBANK'].map((String value){
            return new DropdownMenuItem(child: new Text(value,style:
            TextStyle(color: Colors.grey),),value: value,);
          }).toList(), onChanged:(value){
            gm.bankModel.BankName = value.toString();
            bank = value;
            setState(() {

            });},value: bank,),
          ),
          SizedBox(height: 10,),
          textFromField(
            icon: Icons.credit_card,
            password: false,
            email: "Account Number*",
            inputType: TextInputType.number,
            textFieldNumber: 2,
            gm: gm,
          ),
          SizedBox(height: 10,),
          textFromField(
            icon: Icons.group_work,
            password: false,
            email: "Opening Balance",
            inputType: TextInputType.number,
            textFieldNumber: 5,
            gm: gm,
          ),
          SizedBox(height: 10,),

          SizedBox(height: 10,),

          SizedBox(height: 10,),
          Container(padding: EdgeInsets.all(20) , child:FlatButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
            ,padding: EdgeInsets.symmetric( horizontal:30.0),
            onPressed: () {
              validateValues();
            },
            child: Text(
              "Finish",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.0,
                  fontWeight: FontWeight.w600),
            ),
            color: Colors.grey,),)


        ],

      ),
    );
  }


// code used to upload proof of payment
  Future<File> getCameraImage() async {
    return await ImagePicker.pickImage(source: ImageSource.camera);
  }

  Future<File> getGalleryImage() async {
    return await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  Future<String> saveImageOnline(File file, Request rq) async {
    final StorageReference storageRefrence = FirebaseStorage().ref().child(
        'THIS_COMPANY').child(
        'GROUP_REQUESTS').child(StaticValues.splitEmailForFirebase(rq.GROUP_ADMIN))
        .child(rq.DEPARTMENT).child(rq.GROUP_NAME).child(rq.ACCOUNT_NUMBER).child(
        StaticValues.splitEmailForFirebase(StaticValues.employeeNumber)).child(rq.Title).child('PROOFS').child(
        'PROOF_OF_RECIEPT');
    final StorageUploadTask uploadTask = storageRefrence.putFile(file);
    showProgressIndicator(context);
    var downURL = await(await uploadTask.onComplete).ref.getDownloadURL();
    await uploadTask.onComplete.then((data){
      Navigator.pop(context);
      setState(() {

      });
    });
    String url = downURL.toString();
    rq.proofOfPaynent = url;
    UpdatePOP(url, rq);
    addBankingFee(rq);

    return url;
  }
  uploadOption(Request curr){
    return showDialog(context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Upload Bank Statement", style: TextStyle(color: Colors.grey),),
            backgroundColor: Colors.white,
            elevation: 7,
            contentPadding: EdgeInsets.all(10),
            content:Container(
              child: Text("Before creating your account, you are "
                  "required to provide a proof of funds.\n "
                  "1.) Upload notification of payment/Deposit. "
                  "\n"
                  "2.) Take a picture of the notification of payment/Deposit."
                , textAlign: TextAlign.center,),),

            actions: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    Container(width: (MediaQuery.of(context).size.width/2) - 50,child:
                    FlatButton(onPressed: () async{
                      File file = await getGalleryImage();
                      if (file != null){
                        saveImageOnline(file, curr );
                      }
                    }, child:Row(
                      children: <Widget>[

                        Icon(Icons.file_upload,size: 25,color: Colors.grey,),
                        Text("Upload File",style: TextStyle(color: Colors.grey),),
                      ],
                    ) ))
                    ,
                    Container(width:(MediaQuery.of(context).size.width/2) - 50, child:
                    FlatButton(onPressed: ()async{
                      File file = await getCameraImage();
                      if (file != null){
                        saveImageOnline(file, curr );

                      }
                    }, child: Row(
                      children: <Widget>[
                        Icon(Icons.camera_alt,size: 25,color: Colors.grey,),
                        Text("Camera",style: TextStyle(color: Colors.grey),)
                      ],
                    )))
                  ],
                ),
              ),
            ],
          );
        });
  }

  showProgressIndicator(BuildContext context){
    return showDialog(context: context, barrierDismissible: false, builder: (BuildContext contect){
      return Container(width: 50 , child: Column(children: <Widget>[
        SizedBox(height: MediaQuery.of(context).size.height/2,),
        CircularProgressIndicator(),

      ],),);
    });
  }

  UpdatePOP(String directory, Request rq){
    ref.child(rq.Title).child('INFORMATION').update({"PROOF_OF_PAYMENT": directory,
      "RESPONSE" : "APPROVED"});
    ref.child(rq.Title).child('INFORMATION').update({"PROOF_OF_PAYMENT": directory,
      "RESPONSE" : "APPROVED"});
    setState(() {
      Navigator.pop(context);
    });
  }


  // additional code


  String getDate(){
    return DateTime.now().year.toString()+'/'+
        DateTime.now().month.toString()+'/'+ DateTime.now().day.toString();
  }

  createInitial(){
    Request req = Request();
    req.TRANSACTION_TYPE = 'A';
    req.AVAILABLE_BALANCE = gm.bankModel.accountBalance;
    req.REQUESTED_AMOUNT = gm.bankModel.accountBalance;
    req.GROUP_ADMIN = StaticValues.employeeNumber;
    req.REQUESTER = "BANK";
    req.ACTUAL_AMOUNT_DATE = getDate();
    req.Title = "Opening Balance";
    req.ACTUAL_AMOUNT = gm.bankModel.accountBalance;
    req.date = getDate();
    uploadOption(req);

  }

  bool validateValues(){

    populateAdminDetails();
    if(validateFields()){
      /// Group Information - writes the group object to firebase fr other users to have access to it
      ref = FirebaseDatabase.instance.reference().child('THIS_COMPANY')
          .child('GROUPS').child(StaticValues.splitEmailForFirebase(gm.groupAdmin.memberEmployeeNumber)).child(gm.groupName).child(gm.groupDepartment).child('GROUP_MODEL');
      ref.set(gm.toMap(gm));

      ///banking information - writes the banking object to firebase for users to have access to it
      ref = FirebaseDatabase.instance.reference().child('THIS_COMPANY')
          .child('GROUPS').child(StaticValues.splitEmailForFirebase(gm.groupAdmin.memberEmployeeNumber)).child(gm.groupName).child(gm.groupDepartment).child('BANK_MODEL');
      ref.set(gm.toBankMap(gm));



      ///admin information - writes the admin infomation on to firebase.
      ref = FirebaseDatabase.instance.reference().child('THIS_COMPANY')
          .child('GROUPS').child(StaticValues.splitEmailForFirebase(gm.groupAdmin.memberEmployeeNumber)).child(gm.groupName).child(gm.groupDepartment).child('ADMIN_MODEL');
      ref.set(gm.toAdminMap(gm));

     // db_helper.addNewGroup(GROUP_INFORMATION(gm.groupDepartment, gm.groupName, StaticValues.splitEmailForFirebase(gm.groupAdmin.memberEmployeeNumber),'GR'));
      ///adds the creator of the group as a member of the group.
      ref = FirebaseDatabase.instance.reference().child('THIS_COMPANY').child('GROUPS').child(StaticValues.splitEmailForFirebase(gm.groupAdmin.memberEmployeeNumber))
          .child(gm.groupName).child(gm.groupDepartment).child('MEMBERS').child(StaticValues.splitEmailForFirebase(StaticValues.employeeNumber));


      ref.set(MemberModel(StaticValues.userName, StaticValues.userSurname, StaticValues.occupation, StaticValues.userDisplayPicture, StaticValues.employeeNumber).toMap());

      //create manual logging options
      refm = FirebaseDatabase.instance.reference().child('THIS_COMPANY').child('MANUAL').child(StaticValues.splitEmailForFirebase(gm.groupAdmin.memberEmployeeNumber))
          .child('GROUPS').child(gm.groupName+ ":" +gm.groupDepartment);

      refm.child('ADMIN_MODEL').set(gm.toAdminMap(gm));
      refm.child('GROUP_MODEL').set(gm.toMap(gm));

      createInitial();


    }


  }

  addBankingFee(Request req){

      DatabaseReference refFee = FirebaseDatabase.instance.reference().child(
          "THIS_COMPANY").child("STATEMENTS").child(
          StaticValues.splitEmailForFirebase(StaticValues.employeeNumber))
          .child(DateTime.now().year.toString()).child(DateTime.now().month.toString()).child('${gm.bankModel.cardNumber}_${gm.groupDepartment}_${gm.groupName}');
      refFee.child(getDateTime()+req.Title).set(req.toMap());

      BankCreated(context, 'Group Creation','Group Creation Successful' ,gm);

  }

  String getDateTime(){
    return "${DateTime.now().year}_${DateTime.now().month}_${DateTime.now().day} ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}";
  }

  bool validateCard(){
    bool isValid = false;
    if(gm.bankModel.cardNumber.toString().length < 12 || gm.bankModel.cardNumber.toString().length> 8){
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
    }else if(gm.bankModel.BankName.isEmpty){
      Confirm(context, 'No Bank Name', 'Please Select a bank from the list provided');
    }else if(gm.bankModel.cardNumber.isEmpty){
      Confirm(context, 'Empty Card Number', 'Please Enter Card Number');
    }else if (!validateCard()){
      Confirm(context, 'Incorrect Card Information', 'Please confirm the card information entered');
    }else {
      validinfo = true;
    }
    return validinfo;
  }

  populateAdminDetails(){
    gm.groupAdmin = MemberModel.Blank();
    gm.groupAdmin.memberEmployeeNumber = StaticValues.employeeNumber;
    gm.groupAdmin.memberName =  StaticValues.userName;
    gm.groupAdmin.memberOccupation = StaticValues.occupation;
    gm.groupAdmin.memberPictureAsset = StaticValues.userDisplayPicture;
    gm.groupAdmin.memberSurname =     StaticValues.userSurname;
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
                    fontFamily: 'Gotik',
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

                case 5:
                  gm.bankModel.accountBalance = value;



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
          fontFamily: 'Gotik',
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
BankCreated(BuildContext context, String title,
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
              child: Text('Finished', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);

                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (
                        BuildContext context) => new bottomNavigationBar()));

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



