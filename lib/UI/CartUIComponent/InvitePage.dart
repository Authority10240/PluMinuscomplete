import 'package:flutter/material.dart';
import 'package:treva_shop_flutter/DataModels/GROUP_INFORMATION.dart';
import 'package:treva_shop_flutter/DataModels/GroupModel.dart';
import 'package:treva_shop_flutter/DataModels/MemberModel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:treva_shop_flutter/DataModels/InviteModel.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:treva_shop_flutter/DataModels/StaticValues.dart';
class InvitePage extends StatefulWidget {
  @override
  _InvitePageState createState() => _InvitePageState(gi);

  InvitePage(this.gi);
  InvitePage.blank();

  GROUP_INFORMATION gi;
}

class _InvitePageState extends State<InvitePage> {
  int icount = 1;

  GROUP_INFORMATION gi;
  List<InviteMode> items = [];
  DatabaseReference ref;

  _InvitePageState(this.gi);

  List<String> emails = [];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.grey,
        centerTitle: true,
        title: Text("${gi.groupModel.groupName}'s Invite Page",
          style: TextStyle(color: Colors.white),),),
      body: ListView(
        padding: EdgeInsets.all(0),
        children: <Widget>[
          Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[

                SizedBox(height: 5,),
                Text("Invitation List",
                    style: TextStyle(
                        color: Colors.grey, fontSize: 25)),

                SizedBox(height: 5,),
                Container(height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.7,
                  child: ListView.builder(itemCount: items.length,
                      itemBuilder: (context, position) {
                        return Card(
                          elevation: 7.0, child: ListTile(leading: Icon(
                          Icons.add_box, color: Colors.grey, size: 50,),
                          title: Text(
                              'Name: ' +
                                  items[position].name + ' ${items[position].surname}'),
                          subtitle: Text('Email Address: ${items[position]
                              .email}'),
                          trailing: GestureDetector(onTap: () {
                            items.removeAt(position);
                            setState(() {

                            });
                          },
                            child: Icon(Icons.delete, color: Colors.red,),),),);
                      }),
                ),
                ListTile(leading: Icon(Icons.assignment_ind, color: Colors.grey,),
                  title: Text('Member Count :${items.length}'),
                  ),

                Container(
                  child:
                  Row(children: <Widget>[
                    FlatButton(
                      child: Row(children: <Widget>[ Icon(Icons.send), Text(
                          '  Send Invites')
                      ],),
                      onPressed: () {
                        if(emails.length ==0){
                          Fluttertoast.showToast(
                              msg: "No members have been added, Please press <Add> to add members.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.grey,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                        }else {
                          sendEmail(emails);
                        }
                      },
                    ),
                    FlatButton(
                      child: Row(children: <Widget>[ Icon(Icons.add), Text(
                          '  Add ')
                      ],),

                      onPressed: () {
                        CreateItem(
                            context, 'Add Member', 'Enter Member Information', gi);
                      },
                    ),
                    FlatButton(
                      child:
                      Row(children: <Widget>[ Icon(Icons.delete_forever), Text(
                          '  Clear List')
                      ],),
                      onPressed: () {
                        if (items.length > 0) {
                          EmptyList(gi,context);
                        } else {
                          Fluttertoast.showToast(
                              msg: "Request List has no Members",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.grey,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                        }
                      },

                    ),

                  ],),
                )


              ],
            ),
          )

        ],
      ),
    );
  }

  sendEmail(List<String> emails)async{
    final Email email = Email(
      body:
          "${StaticValues.userName} ${StaticValues.userSurname} has invited you to join his Plus Minus Group ${gi.groupModel.groupName}."
          "\n Employee Number: ${StaticValues.employeeNumber}"
          "\nPassword: ${gi.groupModel.group_password}",
      subject: "Plus Minus Invitation to Join ${gi.groupModel.groupName}",
      recipients: emails,
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
      Fluttertoast.showToast(
          msg: "Invitations Sent Succesfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.grey,
          fontSize: 16.0
      );
      setState(() {
        items.clear();
      });

    } catch (error) {
      Fluttertoast.showToast(
          msg: "Some invitations were not sent",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.grey,
          fontSize: 16.0
      );
      platformResponse = error.toString();
    }

  }
  getDateTime(){
    return DateTime.now().year.toString()+'-'+
        DateTime.now().month.toString()+'-'+ DateTime.now().day.toString() + '_' + DateTime.now().hour.toString() + ':' + DateTime.now().second.toString();
  }

  EmptyList(GROUP_INFORMATION gm,BuildContext context) {

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

                  items.clear();
                  setState(() {

                  });

                  Navigator.pop(context);

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

  CreateItem(BuildContext context, String title,
      String description, GROUP_INFORMATION gm) {

    InviteMode item = InviteMode.blank();
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
                  Text('Enter Member Details'),
                  SizedBox(height: 5,),
                  textFormField('Email Address', item,3,TextInputType.emailAddress),
                  SizedBox(height: 10,),
                  textFormField('Name',item, 1,TextInputType.text),
                  SizedBox(height: 10,),
                  textFormField('Surname', item,2,TextInputType.text),

                ],
              ),
            ),
            actions: <Widget>[

              FlatButton(
                child: Text('Add Member', style: TextStyle(color: Colors.black)),
                onPressed: () {
                  if(item.name == "" || item.surname =="" || item.email ==''){
                    Fluttertoast.showToast(
                        msg: "One or more fields are empty, please fill in all fields before attempting to add a member.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.grey,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  }else{
                    if(items.contains(item)){
                      Fluttertoast.showToast(
                          msg: "Member already inserted.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.grey,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                    }else {
                      this.items.add(item);
                      this.emails.add(item.email);
                      setState(() {

                      });
                      setState(() {

                      });
                      Navigator.pop(context);
                    }
                  }
                },
              ),
              FlatButton(
                child: Text('Finished', style: TextStyle(color: Colors.black)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
    );
  }
  Widget textFormField(String name, InviteMode invite, int pos, TextInputType type){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal:0),
      child: Container(
        height: 60.0,
        alignment: AlignmentDirectional.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.0),
            color: Colors.white,
            boxShadow: [BoxShadow(blurRadius: 10.0, color: Colors.black12)]),
        padding:
        EdgeInsets.only(left: 10,right:10, top: 0.0, bottom: 0.0),
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
                invite.name = value;
              }else if(pos==3) {
                invite.email = value;
              }else if(pos ==2){
                invite.surname = value;
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



