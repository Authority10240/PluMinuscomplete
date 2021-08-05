import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:treva_shop_flutter/DataModels/GROUP_INFORMATION.dart';
import 'package:treva_shop_flutter/DataModels/GroupModel.dart';
import 'package:treva_shop_flutter/DataModels/MemberModel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:treva_shop_flutter/BackEnd/DBHelper.dart';
import 'package:treva_shop_flutter/DataModels/StaticValues.dart';
import 'package:treva_shop_flutter/UI/BottomNavigationBar.dart';

class ListGroups extends StatefulWidget {
  @override
  _ListGroupsState createState() => _ListGroupsState(employeenumber);
  String employeenumber="";
  ListGroups(this.employeenumber);
}

class _ListGroupsState extends State<ListGroups> {
  
  _ListGroupsState(this.employeeNumber);  
  DatabaseReference refm, ref;
  List<GroupModel> groups;
  List<MemberModel> admin;
  String employeeNumber = "", password="";
   String passwErrMess="";
   DBHelper dbHelper;
  @override
  
  
  Widget build(BuildContext context) {
    if(groups==null){
      groups = new List();
      admin = new List();
      updateListView(employeeNumber);
    }
    dbHelper= DBHelper();
    return Scaffold(
      appBar: AppBar(centerTitle: true,
      title: Text("$employeeNumber\'s Groups"),),
      body: ListView.builder(itemCount: admin.length, itemBuilder: (context, pos){
        return Card(
          child: Column(children: <Widget>[
          ListTile(leading: CircleAvatar(child:Text('${groups[pos].groupName[0]} ${groups[pos].groupDepartment[0]}',style: TextStyle(color: Colors.white),)
          ,backgroundColor: Colors.grey,),
        title: Text('Group Name: ${groups[pos].groupName} \n'
        'Group Department: ${groups[pos].groupDepartment}', style: TextStyle(color: Colors.grey),),),
        FlatButton(
          color: Colors.grey,
        child: Text('Join Group', style: TextStyle(color: Colors.white)),
        onPressed: () {
          Confirm(context, 'Group Password','Please enter group password provided by group admin',pos);
        },)
          ],),
        );
      })
    );
  }
  
  updateListView(String employeenumber){
    refm = FirebaseDatabase.instance.reference().child('THIS_COMPANY').child('MANUAL').child(StaticValues.splitEmailForFirebase(employeenumber))
        .child('GROUPS');
    
    refm.onChildAdded.listen((data){
      var group = data.snapshot.value;
      groups.add(GroupModel.fromMapObject(group['GROUP_MODEL']));
      admin.add(MemberModel.fromMapObjectI(group["ADMIN_MODEL"]));
      
      setState(() {
        
      });
    });
  }





  Confirm(BuildContext context,  String title,
      String description, int pos) {
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
                  SizedBox(height: 20,),
                  textFromField('Group Password:'),

                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Join group', style: TextStyle(color: Colors.black)),
                onPressed: () {
                  if(password == groups[pos].group_password){
                    try {
                      //add to SQL DATABASE
                      dbHelper.addNewGroup(
                          GROUP_INFORMATION(groups[pos].groupDepartment,
                              groups[pos].groupName,
                              admin[pos].memberEmployeeNumber, 'GR'));

                      //Make member on Firebase

                      ref = FirebaseDatabase.instance.reference().child('THIS_COMPANY').child('GROUPS').child(StaticValues.splitEmailForFirebase(admin[pos].memberEmployeeNumber))
                          .child(groups[pos].groupName).child(groups[pos].groupDepartment).child('MEMBERS').child(StaticValues.splitEmailForFirebase(StaticValues.employeeNumber));


                      ref.set(MemberModel(StaticValues.userName, StaticValues.userSurname, StaticValues.occupation, StaticValues.userDisplayPicture, StaticValues.employeeNumber).toMap());
                      Fluttertoast.showToast(
                          msg: "'${groups[pos].groupName} Added to group list.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.grey,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );


                    }catch(e){
                      Fluttertoast.showToast(
                          msg: "Group Already Exisits",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.grey,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                    }

                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (BuildContext context) => new bottomNavigationBar.from(2)));
                  }else{
                    Fluttertoast.showToast(
                        msg: "Invalid Password",
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



  textFromField( String email){
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
            obscureText: true,
            decoration: InputDecoration(
                border: InputBorder.none,
                labelText: email,
                icon: Icon(
                  Icons.blur_on,
                  color: Colors.black38,
                ),
                labelStyle: TextStyle(
                    fontSize: 15.0,
                    fontFamily: 'Gotik',
                    letterSpacing: 0.3,
                    color: Colors.black38,
                    fontWeight: FontWeight.w600)),

            keyboardType: TextInputType.text,
            onChanged: (value){
              password = value;
            },
          ),
        ),
      ),
    );
  }

}
