import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:treva_shop_flutter/DataModels/StaticValues.dart';
import 'package:image_picker/image_picker.dart';
import "package:sqflite/sqflite.dart";
import 'dart:io';
import 'package:treva_shop_flutter/BackEnd/DBHelper.dart';
import 'package:treva_shop_flutter/DataModels/Request.dart';
import 'package:treva_shop_flutter/DataModels/GROUP_INFORMATION.dart';
class RequestPage extends StatefulWidget {
  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {

  List<Request> request;

  DatabaseReference ref, refUser, refUser2;
  DBHelper dbHelper = DBHelper();
  double total = 0.00;
  List<GROUP_INFORMATION> groups;

  @override
  Widget build(BuildContext context) {
    total = 0.00;
    if (request == null) {
      request = List();
      getGroupsFromSQL();
    }


    return Scaffold(
      appBar: AppBar(centerTitle: true,
        backgroundColor: Colors.white,
        title: Text("Requests (${request.length.toString()})", style: TextStyle(color: Colors.grey),),

      ),
      body: ListView.builder(itemCount: request.length,
          itemBuilder: (context, position) {
            return
              Card(
                elevation: 7,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Card(

                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: ListTile(
                          title: Text('Admin: ${request[position].GROUP_ADMIN}'
                              '\nGroup Name: ${request[position].GROUP_NAME}'
                              '\nTitle: ${request[position].Title}'
                              '\nDate: ${request[position].date}'
                              '\nTime: ${request[position].time}'
                              '\nResponse: ${request[position].Response}'
                              '\nReason: ${request[position].reason}'
                              '\nStatius: ${request[position].STATUS}',

                            style: TextStyle(),),

                        ),
                      ),


                     Card(
                     child:  Table(
                          children: [
                            TableRow(children: [
                              Text('Name'),
                              Text('Quantity'),
                              Text('Unit Price'),
                              Text('V.A.T (Excl)'),
                              Text('V.A.T'),
                              Text('Sub Total'),
                            ])
                          ],
                        ),
                     ),
                      Card(child:
                       Table(
                            children: getTableRows(position)
                        ),
                      ),

                      Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),child: ListTile(
                          title: Text('Total: R${total.toStringAsFixed(2)}\n'
                              'V.A.T (excl) R${(total - getVatTotal(request[position])).toStringAsFixed(2)}\n'
                              'V.A.T: R${getVatTotal(request[position]).toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 15),),
                          subtitle: checkStatus(position),
                        ),
                      )


                    ],
                  )
              );
          }
      ),
    );
  }

  Widget checkStatus(int i) {
    return GestureDetector(
    onTap:() {
    if (request[i].Response == "APPROVED") {
    uploadOption(i);
    }else if(request[i].Response == "DECLINED"){
      archiveRequest(request[i]);
      Fluttertoast.showToast(
          msg: "Request has not been Declined and will now be archived archived.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0
      );
    } else{
    Fluttertoast.showToast(
    msg: "Request has not been Approved yet, please wait for admin to Approve request",
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 3,
    backgroundColor: Colors.grey,
    textColor: Colors.white,
    fontSize: 16.0
    );
    }
    },child :Card(
        elevation: 7,
        color: Colors.grey,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)),child:Container(height: 40,child:Center(child:Text('Upload Receipt'),))
    )
    );

  }
double getVatTotal(Request request){
    double total =0;

    for (int j = 0; j < request.items.length;j++){
      total = total + request.items[j].vat;
    }
    return total;
}
  List<TableRow> getTableRows(int i) {
    List<TableRow> rows = List();
    for (int j = 0; j < request[i].items.length; j++) {
      rows.add(TableRow(children: [
        Text(request[i].items[j].Description),
        Text(request[i].items[j].quantity.toString()),
        Text('R${request[i].items[j].price.toStringAsFixed(2)}'),
        Text('R${((request[i].items[j].price * request[i].items[j].quantity)-request[i].items[j].vat).toStringAsFixed(2)}'),
        Text('R${(request[i].items[j].vat.toStringAsFixed(2))}'),
        Text('R${(request[i].items[j].price * request[i].items[j].quantity)
            .toStringAsFixed(2)}'),

      ]
      )


      );
      total =
          total + (request[i].items[j].price * request[i].items[j].quantity);
    }
    return rows;
  }

  getGroupsFromSQL() async {
    groups = await dbHelper.getGroupList('GR');

    for (int i = 0; i < groups.length; i++)
      updateListView(groups[i], i);
  }

  uploadOption(int i) {
    return showDialog(context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Upload Receipt from", style: TextStyle(color: Colors.grey),),
            backgroundColor: Colors.white,
            elevation: 7,
            actions: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(width: (MediaQuery.of(context).size.width/2) - 50,child:
                        FlatButton(onPressed: () async {
                          File file = await getGalleryImage();
                          if (file != null) {
                            saveImageOnline(file, request[i]);

                          }
                        }, child: Row(
                          children: <Widget>[

                            Icon(Icons.file_upload, size: 25, color: Colors.grey,),
                            Text(
                              "Upload File", style: TextStyle(color: Colors.grey),),
                          ],
                        ),),)
                        ,
                        Container(child:
                        FlatButton(onPressed: ()async {
                          File file = await getCameraImage();
                          if(file != null){
                            saveImageOnline(file, request[i]);

                          }
                        }, child: Row(
                          children: <Widget>[
                            Icon(Icons.camera_alt, size: 25, color: Colors.grey,),
                            Text("Camera", style: TextStyle(color: Colors.grey),)
                          ],
                        ),),)
                        ,
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }



  updateListView(GROUP_INFORMATION gi, int pos) {
    ref = FirebaseDatabase.instance.reference().child('THIS_COMPANY').child(
        'PERSONAL_REQUESTS')
        .child(StaticValues.splitEmailForFirebase(StaticValues.employeeNumber)).child(gi.GROUP_NAME).child(
        gi.DEPARTMENT)
        .child(StaticValues.splitEmailForFirebase(gi.GROUP_ADMIN));

    refUser = FirebaseDatabase.instance.reference().child('THIS_COMPANY').child(
        'PERSONAL_REQUESTS').child(StaticValues.splitEmailForFirebase(StaticValues.employeeNumber))
        .child(gi.GROUP_NAME).child(gi.DEPARTMENT).child(
        StaticValues.splitEmailForFirebase(gi.GROUP_ADMIN));
    refUser2 =
        FirebaseDatabase.instance.reference().child('THIS_COMPANY').child(
            'GROUP_REQUESTS').child(StaticValues.splitEmailForFirebase(gi.GROUP_ADMIN))
            .child(gi.GROUP_NAME).child(gi.DEPARTMENT).child(
            StaticValues.splitEmailForFirebase(StaticValues.employeeNumber));


    ref.onChildAdded.listen((group) {
      if(Request.FromFirebaseMap(group.snapshot.value).STATUS != "ARCHIVED") {
        request.add(Request.FromFirebaseMap(group.snapshot.value));
        request.last.DEPARTMENT = gi.DEPARTMENT;
        request.last.GROUP_NAME = gi.GROUP_NAME;
        request.last.GROUP_ADMIN = gi.GROUP_ADMIN;
        request.last.ACCOUNT_NUMBER = gi.bankModel.accountNumber;
      }
      setState(() {

        });
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
    });
    String url = downURL.toString();
    UpdatePOP(url, rq);
    ShowToast('Upload Successful');
    setState(() {

    });
    Navigator.pop(context);
    return url;
  }

  UpdatePOP(String directory, Request rq) {
    refUser.child(rq.Title).child('INFORMATION').update(
        {"PROOF_OF_PURCHASE": directory,
          "RESPONSE": "APPROVED"});
    refUser2.child(rq.Title).child('INFORMATION').update(
        {"PROOF_OF_PURCHASE": directory,
          "RESPONSE": "APPROVED"});
    setState(() {

    });

    completeRequest(rq);
  }

  completeRequest(Request rq) {
    refUser.child(rq.Title).child('INFORMATION').update({"STATUS": "COMPLETE"});
    refUser2.child(rq.Title).child('INFORMATION').update(
        {"STATUS": "COMPLETE"});
    setState(() {});
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

  archiveRequest(Request rq){
    refUser.child(rq.Title).child('INFORMATION').update({
      "STATUS" : "ARCHIVED"
    });
    ref.child(rq.Title).child('INFORMATION').update({
      "RESPONSE" : "ARCHIVED"});
    Navigator.pop(context);
    setState(() {

    });
  }
}
