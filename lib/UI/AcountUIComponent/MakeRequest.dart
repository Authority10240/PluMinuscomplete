import 'package:flutter/material.dart';
import 'package:treva_shop_flutter/DataModels/GROUP_INFORMATION.dart';
import 'package:treva_shop_flutter/DataModels/GroupModel.dart';
import 'package:treva_shop_flutter/DataModels/ItemsModel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:treva_shop_flutter/DataModels/Request.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:treva_shop_flutter/DataModels/StaticValues.dart';
import 'package:treva_shop_flutter/UI/AcountUIComponent/CreateItem.dart';


class MakeRequest extends StatefulWidget {
  @override

   String listName = "";
  MakeRequest(this.gi, this.listName);

  MakeRequest.fromItemCreator( this.gi,this.items, this.listName);
  MakeRequest.blank();
 
  GROUP_INFORMATION gi;
  List<Items> items = [];

  _MakeRequestState createState() => _MakeRequestState(gi, items,listName);
}

class _MakeRequestState extends State<MakeRequest> {
  int icount = 1;

  GROUP_INFORMATION gi;
  List<Items> items = [];
  DatabaseReference ref;
  _MakeRequestState(this.gi, this.items, this.listName);
  String listName = '';
  Request request = Request();
  bool vatValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.grey,
        centerTitle: true,
        title: Text("${gi.groupModel.groupName}'s Request Page",
          style: TextStyle(color: Colors.white),),),
      body: Scrollbar(child: ListView(
        padding: EdgeInsets.all(0),
        children: <Widget>[
          Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[


               Container(padding: EdgeInsets.only(top: 10, bottom: 25),child: Text("${listName}('s) Item List",
                    style: TextStyle(color: Colors.black, fontSize: 25)),),

                SizedBox(height: 15,),

                Container(padding: EdgeInsets.only(top:10 , left:10 ,right: 10),height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.65,
                    width:MediaQuery.of(context).size.width*0.9,
                  color: Colors.white54,
                  child: ListView.builder(shrinkWrap: true,physics: AlwaysScrollableScrollPhysics() ,itemCount: items.length,
                      itemBuilder: (context, position) {
                        return Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),elevation: 7.0, child: ListTile(leading: Icon(Icons.add_box,color: Colors.grey,size: 50,),title: Text(
                            'Item: ' + items[position].Description),
                          subtitle: Text('Quantity: ${items[position].quantity} \nAmount: R${(
                              items[position].price).toStringAsFixed(2)}\n'
                              'V.A.T: R${items[position].vat.toStringAsFixed(2)}'
                              '\nSub-Total: R${(items[position].quantity * items[position].price).toStringAsFixed(2)}'),
                          trailing: GestureDetector(onTap: () {
                            items.removeAt(position);
                            setState(() {

                            });
                          },
                            child: Icon(Icons.delete, color: Colors.red,),),),);
                      }),
                ),
                ListTile(leading: Text('R', style:TextStyle(color: Colors.black),),
                subtitle: Text('Total Items:${items.length}' ,style: TextStyle(color: Colors.black), ),
                title: Text('Total Requested: R${getTotalAmount().toStringAsFixed(2)}'
                    '\nTotal V.A.T R${getTotalVAT().toStringAsFixed(2)}'),),

                Container(
                  child:
                  Row(children: <Widget>[
                    Container(width: MediaQuery.of(context).size.width/3 ,child:
                    FlatButton(
                      child: Row(children: <Widget>[ Icon(Icons.send),Text(' Request')],),
                      onPressed: (){
                        if(items.isEmpty){
                          Fluttertoast.showToast(
                              msg: "Items list is empty, Please add items before sending request",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 3,
                              backgroundColor: Colors.grey,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                        }else if (listName.isEmpty){
                          Fluttertoast.showToast(
                              msg: "List name is empty, Please enter list name before sending request",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 3,
                              backgroundColor: Colors.grey,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                        }else {
                          sendRequestToDatabase();
                        }
                      },
                    ),),
                    Container(width: MediaQuery.of(context).size.width/3,child:
                    FlatButton(
                      child: Row(children: <Widget>[ Icon(Icons.add),Text(' Add')],),

                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                new CreateItem(gi,items,listName)));
                      },
                    ),),
                    Container(child:
                    FlatButton(
                        child:
                        Row(children: <Widget>[ Icon(Icons.delete_forever),Text(' Clear')],),
                      onPressed: (){
                          if(items.length>0) {
                            EmptyList(gi);
                          }else{
                            Fluttertoast.showToast(
                                msg: "Request List has no items",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.grey,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );

                          }
                      },

                    ),)

                  ],),
                )


              ],
            ),
          )

        ],
      ),)
    );
  }


  double getTotalAmount(){
    double total = 0;

    for(int i = 0 ; i < items.length; i++){
      total = total + (items[i].price*items[i].quantity) ;

    }

    return total;
  }

  double getTotalVAT(){
    double vat = 0;

    for( int i = 0 ; i < items.length; i++){
      vat = vat+items[i].vat;
    }

    return vat;
  }
  
  sendRequestToDatabase(){
    ref = FirebaseDatabase.instance.reference();

  if(listName == ''){
    Fluttertoast.showToast(
        msg: "Please insert List name before sending request",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0
    );

  }else {
    request.Title = listName;
    request.items = items;
    request.ACCOUNT_NUMBER = gi.bankModel.cardNumber;
    request.AVAILABLE_BALANCE = gi.bankModel.accountBalance;
    request.REQUESTED_AMOUNT = getTotalAmount().toStringAsFixed(2);
    request.REQUEST_VAT = getTotalVAT().toStringAsFixed(2);
    request.DEPARTMENT = gi.groupModel.groupDepartment;
    request.GROUP_NAME = gi.groupModel.groupName;
    request.GROUP_ADMIN = gi.admin.memberEmployeeNumber;
    request.TRANSACTION_TYPE = 'R';
    request.REQUESTER = StaticValues.employeeNumber;

    ref.child('THIS_COMPANY').child('GROUP_REQUESTS').child(StaticValues.splitEmailForFirebase(
        gi.admin.memberEmployeeNumber))
        .child(gi.groupModel.groupName).child(gi.groupModel.groupDepartment)

        .child(StaticValues.splitEmailForFirebase(StaticValues.employeeNumber))
        .child(listName).child('INFORMATION')
        .set(request.toMap());
    //Adds Request Information to personal list
    ref.child('THIS_COMPANY').child('PERSONAL_REQUESTS').child(StaticValues.splitEmailForFirebase(
        StaticValues.employeeNumber))
        .child(gi.groupModel.groupName).child(gi.groupModel.groupDepartment)

        .child(StaticValues.splitEmailForFirebase(gi.admin.memberEmployeeNumber))
        .child(listName)
        .child('INFORMATION')
        .set(request.toMap());
    for (int i = 0; i < items.length; i++) {
      //Adds Request information to group request list
      ref.child('THIS_COMPANY').child('GROUP_REQUESTS').child(StaticValues.splitEmailForFirebase(
          gi.admin.memberEmployeeNumber))
          .child(gi.groupModel.groupName).child(gi.groupModel.groupDepartment)

          .child(StaticValues.splitEmailForFirebase(StaticValues.employeeNumber))
          .child(listName ).child('LIST').child(i.toString())
          .set(items[i].toMap());
      //Adds Request Information to personal list
      ref.child('THIS_COMPANY').child('PERSONAL_REQUESTS').child(StaticValues.splitEmailForFirebase(
          StaticValues.employeeNumber))
          .child(gi.groupModel.groupName).child(gi.groupModel.groupDepartment)
          .child(StaticValues.splitEmailForFirebase(gi.admin.memberEmployeeNumber))
          .child(listName)
          .child('LIST').child(i.toString())
          .set(items[i].toMap());
    }


    Fluttertoast.showToast(
        msg: "Request ${listName} sent. Awaiting response from group administrator",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0
    );
    items.clear();
    listName = "";
    Navigator.pop(context);
  }

  }


  getDateTime(){
    return DateTime.now().year.toString()+'-'+
        DateTime.now().month.toString()+'-'+ DateTime.now().day.toString() + '_' + DateTime.now().hour.toString() + ':' + DateTime.now().second.toString();
  }
  EmptyList(GROUP_INFORMATION gm) {
    Items item = Items();
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(

            title: Text('Empty Request List'),
            elevation: 7.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('List currently has ${items.length.toString()} item(s). Are you sure you want to empty the list'),
                ],
              ),
            ),
            actions: <Widget>[

              FlatButton(
                child: Text('Clear', style: TextStyle(color: Colors.black)),
                onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        items.clear();
                      });
                     


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

  UploadRequest(){

  }



  Widget textFormField(String name, Items item, int pos, TextInputType type){
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
            decoration: InputDecoration(
                border: InputBorder.none,
                labelText: name,
                labelStyle: TextStyle(
                    fontSize: 15.0,
                    fontFamily: 'Gotik',
                    letterSpacing: 0.3,
                    color: Colors.black38,
                    fontWeight: FontWeight.w600)),
            keyboardType: type,
            onChanged: (value){
              if(pos==1){
                item.quantity = int.parse(value);
              }else if(pos==3) {
                request.Title = value;
              }else if(pos ==2){
                item.price = double.parse(value);
              }
            },
          ),
        ),
      ),
    );
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

}

class Dialog extends StatefulWidget {
  @override
  _DialogState createState() => _DialogState();
}

class _DialogState extends State<Dialog> {
  @override
  Widget build(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(

            title: Text('Add Item'),
            elevation: 7.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Enter Item Description'),

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
}

