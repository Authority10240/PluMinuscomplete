import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:treva_shop_flutter/BackEnd/DBHelper.dart';
import 'package:treva_shop_flutter/DataModels/GROUP_INFORMATION.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:treva_shop_flutter/DataModels/MemberModel.dart';
import 'package:treva_shop_flutter/DataModels/StaticValues.dart';
import 'package:treva_shop_flutter/DataModels/Request.dart';
import 'package:treva_shop_flutter/ListItem/BrandDataList.dart';
import 'package:share/share.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:treva_shop_flutter/DataModels/StaticValues.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/local_auth.dart';
class Group_requests extends StatefulWidget {
  @override
  _Group_requestsState createState() => _Group_requestsState(gi,mm );
  GROUP_INFORMATION gi;
  MemberModel mm;
  Group_requests(this.gi,this.mm);
}

class _Group_requestsState extends State<Group_requests> {
  DatabaseReference ref, refUser;
  GROUP_INFORMATION gi;
  List<Request> members;
  MemberModel mm;
  String number, pin = "";

  _Group_requestsState(this.gi, this.mm);

  @override
  Widget build(BuildContext context) {
    if (members == null) {
      members = List();
      UpdateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${mm.memberEmployeeNumber}: ${members.length} Request(s)'),
        centerTitle: true,
      ),
      body: ListView.builder(itemCount: members.length,
          itemBuilder: (BuildContext context, int i) {
            return GestureDetector(

              child: Card(child: Column(children: <Widget>[ListTile(
                title: Text(
                    '${mm.memberName } ${mm.memberSurname} \n${mm.memberEmployeeNumber}'),

                leading: CircleAvatar(
                  backgroundImage: NetworkImage(mm.memberPictureAsset),),
              subtitle: Text('Request: ${members[i].Title}\n ${members[i].time} \nDate: ${members[i].date}'),

              ),
                Padding(padding: EdgeInsets.all(10),
                    child: Column(children: <Widget>[
                      Table(
                        children: [
                          TableRow(children: [
                            Text('Name'),
                            Text('Quantity'),
                            Text('Unit price'),
                            Text('V.A.T (excl)'),
                            Text('V.A.T'),
                            Text('Sub Total'),
                          ]
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Table(
                        children: generateList(members[i]),
                      ),
                      SizedBox(height: 40,),
                      Text('V.A.T:R${getVatTotla(members[i]).toStringAsFixed(2)}'),
                      Text('V.A.T (excl.):R${(getTotal(members[i]) - getVatTotla(members[i])).toStringAsFixed(2)}'),
                      Text('Grand Total:R${getTotal(members[i]).toStringAsFixed(2)}'),
                      SizedBox(height: 20,),
                      Text('Download:',style: TextStyle(fontWeight: FontWeight.bold),),
                      Row(
                        children: <Widget>[
                          FlatButton(
                            color: Colors.grey,
                            child: Row(
                                children: <Widget>[Text('R',style: TextStyle(color: Colors.white),),
                                  SizedBox(width: 10,),
                                  Text('Deposit Slip')]),
                            onPressed: () {
                              if(members[i].proofOfPaynent == ''){
                                ShowToast('No Deposit Slip Uploaded.');
                              }else{
                                Share.share(members[i].proofOfPaynent,
                                    subject: 'Plus Minus: ${members[i].Title}\'s Deposit Slip');
                              }
                            },
                          ),
                          SizedBox(width: 10,),
                          FlatButton(
                            color: Colors.grey,
                            child: Row(
                                children: <Widget>[Text('R',style: TextStyle(color: Colors.white),),
                                SizedBox(width: 10,),
                                  Text('Receipt Slip')]),
                            onPressed: () {
                              if(members[i].proofOfPurchase == ''){
                                ShowToast('No Receipt uploaded.');
                              }
                            },
                          ),
                        ],
                      )
                    ]
                      ,))
              ],),),
              onTap: () {
                if (members[i].STATUS != 'COMPLETE') {
                  if (members[i].Response == 'APPROVED') {
                    ShowToast(
                        'This request has already been approved. Awaiting proof of receipt/invoice.');
                  } else if (members[i].Response == 'DECLINED') {
                    ShowToast(
                        'This request has already been declined, awaiting requester reciept.');
                  } else {
                    RequestResponse(context, members[i]);
                  }
                }else{
                  setActualAmount(members[i]);
                }
              }


              ,);
          }),
    );
  }

// object order on listener
  /*gi.groupModel.groupName*/
  /*gi.groupModel.groupDepartment*/
  UpdateListView() {

    refUser = FirebaseDatabase.instance.reference().child('THIS_COMPANY').child(
        'PERSONAL_REQUESTS').child(StaticValues.splitEmailForFirebase(mm.memberEmployeeNumber))
        .child(gi.GROUP_NAME).child(gi.DEPARTMENT).child(
        StaticValues.splitEmailForFirebase(gi.GROUP_ADMIN));

    ref = FirebaseDatabase.instance.reference().child('THIS_COMPANY').child(
        'GROUP_REQUESTS').child(StaticValues.splitEmailForFirebase(gi.GROUP_ADMIN))
        .child(gi.GROUP_NAME).child(gi.DEPARTMENT).child(
        StaticValues.splitEmailForFirebase(mm.memberEmployeeNumber));

    ref.onChildAdded.listen((evt) {
      var data = evt.snapshot.value;
      Request req = Request.FromMap(evt.snapshot.key, evt.snapshot.value, 'R');

      if (req.STATUS == "COMPLETE" ||  req.STATUS=="ACTIVE") {
        members.add(Request.FromMap(evt.snapshot.key, evt.snapshot.value, 'R'));
        setState(() {
        });
      }else{

      }
    });
  }


  setActualAmount(Request req){
    showDialog(context: context,
        barrierDismissible: false,
    builder: (BuildContext context){
      return AlertDialog(
        title: Text('Insert Actual Amount Printed On Invoice'),
        elevation: 7.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Please enter the actual amount printed on the invoice uploaded by group member.'),
              TextField(

                onChanged:(value){
                  req.ACTUAL_AMOUNT = value;
                  ref.child(req.Title).child('INFORMATION').update({'ACTUAL_AMOUNT':value,
                  'ACTUAL_AMOUNT_DATE': getDate()});
                  refUser.child(req.Title).child('INFORMATION').update({'ACTUAL_AMOUNT':value,
                    'ACTUAL_AMOUNT_DATE': getDate()});
                },
              ),
            FlatButton(onPressed: (){

              saveInHistory(req,"F");
              UpdateStatus(req);
              updateActualAmount(req);
              updateBalance(req, "${double.parse(req.AVAILABLE_BALANCE) - double.parse(req.ACTUAL_AMOUNT)}",minus: true);
              Navigator.pop(context);
              setState(() {
              });
            }, child: Text('Save', style: TextStyle(color: Colors.black),))
            ],),),);

        });
  }

  String getDateTime(){
    return "${DateTime.now().year}_${DateTime.now().month}_${DateTime.now().day} ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}";
  }

  String getDate(){
    return "${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}}";
  }

  saveInHistory(Request req,String TT){
    String refernce = '${req.ACCOUNT_NUMBER}_${req.DEPARTMENT}_${req.GROUP_NAME}';
    req.TRANSACTION_TYPE = TT;
    DatabaseReference backup = FirebaseDatabase.instance.reference()
        .child('THIS_COMPANY').child('STATEMENTS').child(StaticValues.splitEmailForFirebase(StaticValues.employeeNumber))
        .child(req.YEAR).child(req.MONTH).child(refernce).child(StaticValues.splitEmailForFirebase(getDateTime()+req.REQUEST_ID));
    backup.set(req.toMap());

   /* backup = FirebaseDatabase.instance.reference()
        .child('THIS_COMPANY').child('STATEMENTS').child(StaticValues.splitEmailForFirebase(req.REQUESTER))
        .child(req.YEAR).child(req.MONTH).child(refernce).child(StaticValues.splitEmailForFirebase(req.REQUEST_ID));

    backup.set(req.toMap());*/
  }



  UpdateStatus(Request req){
    ref.child(req.Title).child('INFORMATION').update({'STATUS':'ARCHIVED',
    'ACTUAL_AMOUNT': req.ACTUAL_AMOUNT,
      'ACTUAL_AMOUNT_DATE': getDate()});
    refUser.child(req.Title).child('INFORMATION').update({'STATUS':"ARCHIVED",
    'ACTUAL_AMOUNT':req.ACTUAL_AMOUNT,
    'ACTUAL_AMOUNT_DATE': getDate()});
  }
  String getItems(int posistion) {
    String items = "";
    for (int i = 0; i < members[posistion].items.length; i++) {
      items = items + '${members[posistion].items[i]
          .Description} \t\t\t ${members[posistion].items[i]
          .quantity} \t\t\t\ ${members[posistion].items[i].price
          .toStringAsFixed(2)}\t\t\t${members[posistion].items[i].vat}\n';
    }
    return items;
  }

  RequestResponse(BuildContext context,
      Request list) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Approve On The Following Request?'),
            elevation: 7.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Item List: ${list.Title}'),
                  SizedBox(height: 25,),
                  Table(
                    children: [
                      TableRow(
                          children: [
                            Text('Name',style: TextStyle(fontSize: 14)),
                            Text('Quantity',style: TextStyle(fontSize: 14)),
                            Text('Total Cost',style: TextStyle(fontSize: 14)),
                          ]
                      )
                    ],
                  ),
                  SizedBox(height: 10,),
                  Table(
                    children: generateShortList(list),
                  ),
                SizedBox(height: 40,),
                  Text('Grand Total: R${getTotal(list).toStringAsFixed(2)}'),
                  Text('Available Balance: R${list.AVAILABLE_BALANCE}'  )
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Row(
                    children: <Widget>[Icon(Icons.done, color: Colors.green,),
                      Text('Approve')]),
                onPressed: () async {

                  var localAuth = LocalAuthentication();
                  List<BiometricType> availableBiometrics =
                      await localAuth.getAvailableBiometrics();

                  if (Platform.isIOS) {
                    if (availableBiometrics.contains(BiometricType.fingerprint)) {
                      // Touch ID.
                      bool didAuthenticate =
                          await localAuth.authenticateWithBiometrics(
                          localizedReason: 'Please authenticate to approve request',
                          useErrorDialogs: false);
                      if(await didAuthenticate){
                        if(double.parse(list.AVAILABLE_BALANCE) > getTotal(list)){
                          Navigator.pop(context);

                          ShowToast("Request Approved");
                          updateResponse('APPROVED', list);

                        }else{
                          Navigator.pop(context);
                          addMoreMoney(list);

                        }
                      }else{
                        loadKeyPad(context,list);
                      }
                    }else{
                      //use pin code method
                      loadKeyPad(context,list);
                    }
                  }else if(Platform.isAndroid){
                    if(availableBiometrics.contains(BiometricType.fingerprint)){
                      bool didAuthenticate =
                          await localAuth.authenticateWithBiometrics(
                          localizedReason: 'Please authenticate to approve request',
                          useErrorDialogs: false);
                      if(await didAuthenticate){
                        if(double.parse(list.AVAILABLE_BALANCE) > getTotal(list)){
                          Navigator.pop(context);
                          ShowToast("Request Approved");
                          updateResponse('APPROVED', list);


                        }else{
                          Navigator.pop(context);
                          addMoreMoney(list);

                        }
                      }else{
                        loadKeyPad(context,list);
                      }
                    }else{
                      //use pin code method
                      loadKeyPad(context,list);
                    }
                  }

                },
              ),

              FlatButton(

                child: Row(
                    children: <Widget>[Icon(Icons.clear, color: Colors.red,),
                      Text('Decline')]),
                onPressed: () {
                  declineReason(list);

                },
              ),

            ],
          );
        }
    );
  }

  loadKeyPad(BuildContext context ,Request list){
    return showDialog(context: context, barrierDismissible:true, builder: (BuildContext context){
      return AlertDialog(
        title: Text('Enter Pin'),
        content: TextField(obscureText: true,keyboardType: TextInputType.number, maxLength: 5, onChanged: (value){
          pin = value;
        },),
        actions: [
          FlatButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text('Cancel')),
          FlatButton(onPressed: (){
            SharedPreferences.getInstance().then((value)  {
              if(value.getString('PIN') == pin){
                if(double.parse(list.AVAILABLE_BALANCE) > getTotal(list)){
                  Navigator.pop(context);
                  Navigator.pop(context);
                  ShowToast("Request Approved");
                  updateResponse('APPROVED', list);
                }else{
                  Navigator.pop(context);
                  addMoreMoney(list);
                }
              }else{
                Fluttertoast.showToast(msg: 'Invalid Pin, Please check your pin and try again');
              }
            });
          }, child: Text('Submit')),
        ],
      );
    });
  }

  addMoreMoney(Request list){
    String amount='';
    return showDialog(context: context,
      barrierDismissible: true,
    builder: (BuildContext context){
      return AlertDialog(
        title: Text('Insufficient Funds.'),
        content: Column(
          children: <Widget>[
            Text('The Selected account has insufficient funds to approve the requested items(s) \n'
                'Therefore to continue with the transaction, kindly refurbish the account with atleast the minimum amount required below:'
                '\n'
                'Minimum amount Required: \nR${(double.parse(list.AVAILABLE_BALANCE) - getTotal(list)).toStringAsFixed(2) }'),
            TextField(
              keyboardType: TextInputType.number,
              onChanged:(value){
                amount = value;
              },
            ),
          ],
        ),
        actions: <Widget>[
          FlatButton(onPressed: (){
            if((double.parse(amount) + double.parse(list.AVAILABLE_BALANCE)) > getTotal(list) ){
              list.ACTUAL_AMOUNT = amount;
              updateBalance(list, amount);

            }else{
              Fluttertoast.showToast(
                  msg: "Amount entered is not sufficient to complete transaction.\n"
                      "Please ensure that the amount you are adding and you available balance exceed the requested amount.",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 3,
                  backgroundColor: Colors.grey,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            }
            // check if entered amount plus amount in company are more than or equal to the required amount.
            //add the amount put into the textfield
          }, child: Text('Add Amount')),
          FlatButton(onPressed: (){
            updateBalance(list, getTotal(list).toString());
            //add the requested amount
          }, child: Text('Add Requested Amount')),


        ],
      );
    });
  }

  updateActualAmount(Request req){
    DatabaseReference refMain = FirebaseDatabase.instance.reference().child('THIS_COMPANY')
        .child('GROUPS').child(StaticValues.splitEmailForFirebase(req.GROUP_ADMIN)).child(req.GROUP_NAME).child(req.DEPARTMENT).child('BANK_MODEL');
    refMain.update({
      'ACCOUNT_BALANCE': (double.parse(req.AVAILABLE_BALANCE) - double.parse(req.ACTUAL_AMOUNT)).toStringAsFixed(2)
    });

    setState(() {

    });
  }

    updateBalance(Request list, String entered, {bool minus : false}){
    DatabaseReference refMain = FirebaseDatabase.instance.reference().child('THIS_COMPANY')
        .child('GROUPS').child(StaticValues.splitEmailForFirebase(list.GROUP_ADMIN)).child(list.GROUP_NAME).child(list.DEPARTMENT).child('BANK_MODEL');
      refMain.update({
        'ACCOUNT_BALANCE': minus?
        (double.parse(entered) - double.parse(list.AVAILABLE_BALANCE)).toStringAsFixed(2)
            :
        (double.parse(entered) + double.parse(list.AVAILABLE_BALANCE)).toStringAsFixed(2)
      });
      ref.child(list.Title).child('INFORMATION').update({
        'ACCOUNT_BALANCE': minus?
        (double.parse(entered) - double.parse(list.AVAILABLE_BALANCE)).toStringAsFixed(2)
            :
        (double.parse(entered) + double.parse(list.AVAILABLE_BALANCE)).toStringAsFixed(2)
        ,'ACTUAL_AMOUNT_PAID':double.parse(entered).toStringAsFixed(2)});
      refUser.child(list.Title).child('INFORMATION').update({
        'ACCOUNT_BALANCE': minus ?
        (double.parse(entered) - double.parse(list.AVAILABLE_BALANCE)).toStringAsFixed(2)
          :(double.parse(entered) + double.parse(list.AVAILABLE_BALANCE)).toStringAsFixed(2)
        ,'ACTUAL_AMOUNT_PAID':double.parse(entered).toStringAsFixed(2)});
        list.ACTUAL_AMOUNT_PAID = double.parse(entered).toStringAsFixed(2);
        list.AVAILABLE_BALANCE = minus?
        (double.parse(entered) - double.parse(list.AVAILABLE_BALANCE)).toStringAsFixed(2)
          :
        (double.parse(entered) + double.parse(list.AVAILABLE_BALANCE)).toStringAsFixed(2);
      saveInHistory(list,"A");
      setState(() {
        Navigator.pop(context);
        uploadOption(list);

      });
    }


    updateDeduction(Request list, String entered){
      DatabaseReference refMain = FirebaseDatabase.instance.reference().child('THIS_COMPANY')
          .child('GROUPS').child(StaticValues.splitEmailForFirebase(list.GROUP_ADMIN)).child(list.GROUP_NAME).child(list.DEPARTMENT).child('BANK_MODEL');
      refMain.update({
        'ACCOUNT_BALANCE': (double.parse(list.AVAILABLE_BALANCE) - double.parse(entered)).toStringAsFixed(2)
        ,'ACTUAL_AMOUNT_PAID':double.parse(entered).toStringAsFixed(2)});
      ref.child(list.Title).child('INFORMATION').update({
        'ACCOUNT_BALANCE': (double.parse(list.AVAILABLE_BALANCE) - double.parse(entered)).toStringAsFixed(2)
        ,'ACTUAL_AMOUNT_PAID':double.parse(entered).toStringAsFixed(2)});
      refUser.child(list.Title).child('INFORMATION').update({
        'ACCOUNT_BALANCE': (double.parse(list.AVAILABLE_BALANCE) - double.parse(entered)).toStringAsFixed(2)
        ,'ACTUAL_AMOUNT_PAID':double.parse(entered).toStringAsFixed(2)});
      Fluttertoast.showToast(
          msg: "Request Approved",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0
      );

      Navigator.pop(context);
      Navigator.pop(context);
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

  Future<String> saveImageOnline(File file, Request rq) async {
    final StorageReference storageRefrence = FirebaseStorage().ref().child(
        'THIS_COMPANY').child(
        'GROUP_REQUESTS').child(StaticValues.splitEmailForFirebase(gi.GROUP_ADMIN))
        .child(gi.DEPARTMENT).child(gi.GROUP_NAME).child(StaticValues.splitEmailForFirebase(
        mm.memberEmployeeNumber)).child(rq.Title).child('PROOFS').child(
        'PROOF_OF_PAYMENT');
    showProgressIndicator(context);
    final StorageUploadTask uploadTask = storageRefrence.putFile(file);



    var downURL = await(await uploadTask.onComplete).ref.getDownloadURL();
    await uploadTask.onComplete.then((data){
      Fluttertoast.showToast(
          msg: "Upload Successful, Request Approved and awaiting response.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0
      );
    });
    String url = downURL.toString();
    UpdatePOP(url,rq);
    setState(() {
      Navigator.pop(context);
    });
    Navigator.pop(context);
    setState(() {

    });
    return url;
  }

  insertActualAmountPaid(String amount , Request rq){
    refUser.child(rq.Title).child('INFORMATION').update({"ACTUAL_AMOUNT_PAID":amount
      });
    ref.child(rq.Title).child('INFORMATION').update({"ACTUAL_AMOUNT_PAID":amount
      });
  }

UpdatePOP(String directory, Request rq){
    refUser.child(rq.Title).child('INFORMATION').update({"PROOF_OF_PAYMENT": directory,
    "RESPONSE" : "APPROVED"});
    ref.child(rq.Title).child('INFORMATION').update({"PROOF_OF_PAYMENT": directory,
                                                      "RESPONSE" : "APPROVED"});
    setState(() {
      Navigator.pop(context);
    });
}

updateResponse(String response, Request rq){
  ref.child(rq.Title).child('INFORMATION').update({
    "RESPONSE" : "APPROVED"});
  refUser.child(rq.Title).child('INFORMATION').update({
    "RESPONSE" : "APPROVED"});
}
  uploadOption(Request curr){
    return showDialog(context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Upload Deposit Slip", style: TextStyle(color: Colors.grey),),
            backgroundColor: Colors.white,
            elevation: 7,
            contentPadding: EdgeInsets.all(10),
            content:Container(
              child: Text("Before approving the request, you are "
                  "required to provide a proof of payment.\n "
                  "1.) Upload the notice of payment received via email. "
                  "\n"
                  "2.) Take a picture of bank deposit slip."
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

    declineReason(Request req){
    return showDialog(context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Reason for decline.", style: TextStyle(color: Colors.grey),),
            backgroundColor: Colors.white,
            elevation: 7,
            contentPadding: EdgeInsets.all(10),
            content:Container(
              child: Column(

            children: <Widget>[
              Text('Please provide reasons for declining this request.', textAlign:  TextAlign.center,),

              TextField(maxLines: 4,
                decoration: InputDecoration.collapsed(hintText: 'Enter reason here.'), onChanged: (val){
                    req.reason = val;

                },),
            ],),),

            actions: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    FlatButton(onPressed: () {
                      if(req.reason != '' || req.reason != null) {
                        updateStatus(req);
                        Navigator.pop(context);
                      }else{

                      }
                    }, child:Row(
                      children: <Widget>[

                        Icon(Icons.clear_all,size: 50,color: Colors.grey,),
                        Text("Decline",style: TextStyle(color: Colors.grey),),

                      ],
                    ) )
                    ,
                    FlatButton(onPressed: (){
                     Navigator.pop(context);
                    }, child: Row(
                      children: <Widget>[
                        Icon(Icons.cancel,size: 50,color: Colors.grey,),
                        Text("Cancel",style: TextStyle(color: Colors.grey),)
                      ],
                    ))
                  ],
                ),
              ),
            ],
          );
        });
  }

  updateStatus(Request rq){
    refUser.child(rq.Title).child('INFORMATION').update({'REASON': rq.reason,
      "RESPONSE" : "DECLINED"
      });
    ref.child(rq.Title).child('INFORMATION').update({'REASON': rq.reason,
      "RESPONSE" : "DECLINED"});
    Navigator.pop(context);
    setState(() {

    });
  }
  List<TableRow> generateList(Request request) {
    List<TableRow> rows = [];
    for (int i = 0; i < request.items.length; i++) {
      rows.add(TableRow(children: [
        Text(request.items[i].Description),
        Text(request.items[i].quantity.toStringAsFixed(0)),
        Text('R${request.items[i].price.toStringAsFixed(2)}'),
        Text('R${((request.items[i].price * request.items[i].quantity)- request.items[i].vat).toStringAsFixed(2)}'),
        Text('R${request.items[i].vat.toStringAsFixed(2)}'),
        Text('R${(request.items[i].price * request.items[i].quantity)
            .toStringAsFixed(2)}'),

      ]));


    }
    return rows;
  }

  List<TableRow> generateShortList(Request request) {
    List<TableRow> rows = [];
    for (int i = 0; i < request.items.length; i++) {
      rows.add(TableRow(children: [
        Text(request.items[i].Description , style: TextStyle(fontSize: 12),),
        Text(request.items[i].quantity.toStringAsFixed(0),style: TextStyle(fontSize: 12)),

        Text(
            ('R ${(request.items[i].price * request.items[i].quantity)
                .toStringAsFixed(
                2)}'),style: TextStyle(fontSize: 12))

      ]));
    }
    return rows;
  }

  double getTotal(Request request){

    double total = 0.00;

    for(int i = 0; i < request.items.length; i++){
      total = total + (request.items[i].price * request.items[i].quantity);
    }

    return total;
  }

  double getVatTotla(Request request){
    double total = 0.00;

    for(int i = 0; i < request.items.length; i++){
      total = total +(request.items[i].vat);
    }
    return total;
  }

  Future<File>  getCameraImage() async{
    File picture = await ImagePicker.pickImage(source: ImageSource.camera);

    return  picture;
  }


  Future<File> getGalleryImage() async{

    File picture = await ImagePicker.pickImage(source: ImageSource.gallery);

    return  picture;
  }

  ShowToast(String text ){
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0);
  }



}