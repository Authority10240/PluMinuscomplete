import 'dart:collection';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:treva_shop_flutter/DataModels/BankModel.dart';
import 'package:treva_shop_flutter/DataModels/MemberModel.dart';
import 'package:treva_shop_flutter/DataModels/StaticValues.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:treva_shop_flutter/UI/AcountUIComponent/RequestName.dart';
import 'package:treva_shop_flutter/UI/CartUIComponent/InvitePage.dart';
import 'package:treva_shop_flutter/UI/CartUIComponent/QRView.dart';
import 'package:treva_shop_flutter/UI/HomeUIComponent/GroupMembers.dart';
import 'package:treva_shop_flutter/UI/AcountUIComponent/MakeRequest.dart';
import 'package:treva_shop_flutter/UI/CartUIComponent/GroupCreate.dart';
import 'add_QR_screen.dart';
import 'package:treva_shop_flutter/DataModels/GroupModel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:treva_shop_flutter/BackEnd/DBHelper.dart';
import 'package:treva_shop_flutter/DataModels/GROUP_INFORMATION.dart';
import 'package:fluttertoast/fluttertoast.dart';


class cart extends StatefulWidget {
  @override
  _cartState createState() => _cartState();
}

class _cartState extends State<cart> {

    List<GroupModel> items ;
  DatabaseReference ref , ref2;
  DBHelper db_helper = DBHelper();
  List<GROUP_INFORMATION> groups , groups2 ;
  HashMap hash = HashMap();
  /// Declare price and value for chart
  int value = 1;
  int pay = 950;
  String emailToSend ="";
    bool loop = true;

  @override
  Widget build(BuildContext context) {

    // TODO Implementation

    if(groups2 == null){

      groups2 = List();
      getGroupListOnline();
      getGroupsFromSQL();

      try{

      }catch(e){
        e.toString();
      }

    }

      return Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Color(0xFF6991C7)),
            centerTitle: false,
            backgroundColor: Colors.grey,
             actions: <Widget>[
               GestureDetector(

                 onTap: (){
                   Navigator.of(context).push(MaterialPageRoute(
                       builder: (BuildContext context) => new GroupCreate()));

                 },
                 child: Row(
                   children: <Widget>[
                     Icon(Icons.create,size: 40, color: Colors.white,),
                     Text('Create Group   ',style: TextStyle(color: Colors.white),)
                   ],
                 ),

               ),
               GestureDetector(
                 onTap: (){
                   Navigator.of(context).push(MaterialPageRoute(
                       builder: (BuildContext context) => new QRCodeAddScreen()));

                 },
                 child: Row(
                   children: <Widget>[
                     Icon(Icons.add,size: 40, color: Colors.white,),
                     Text('Join Group   ',style: TextStyle(color: Colors.white),)
                   ],
                 ),

               ),


             ],
            title: Text(
              "",
              style: TextStyle(
                  fontFamily: "Gotik",
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w700),
            ),
            elevation: 0.0,
          ),


          ///
          ///
          /// Checking item value of cart
          ///
          ///
          body:

          groups2.length>0?

          ListView.builder(

            itemCount: groups2.length,
            itemBuilder: (context,position){
              ///
              /// Widget for list view slide delete
              ///
              return GestureDetector(
                onLongPress: (){
                  Fluttertoast.showToast(
                      msg: 'Group Password is: ${groups2[position].groupModel.group_password}',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.blueGrey,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                },
                child: Card(elevation: 7,child: Slidable(
                actionPane: SlidableDrawerActionPane(),
                actionExtentRatio: 0.25,
                actions: <Widget>[
                  new IconSlideAction(
                    key: Key('Key'),
                    caption: 'Delete',
                    color: Colors.grey,
                    icon: Icons.email,
                    onTap: () async {
                      return showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(

                              title: Text('Delete Group ${groups2[position].groupModel.groupName}'),
                              elevation: 7.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10))),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text('Are you sure you want to delete the following group: '
                                        '${groups2[position].groupModel.groupName} \n'
                                        'You will have to '
                                        '${groups[position].GROUP_ADMIN == StaticValues.splitEmailForFirebase(StaticValues.employeeNumber)
                                ? "recreate" : "rejoin"}'
                                         "the group to gain access again. "),
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

                    },
                  ),
                ],
                secondaryActions: <Widget>[
                  new IconSlideAction(
                    key: Key('Key'),
                    caption: 'QR Code',
                    color: Colors.grey,
                    icon: Icons.code,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => new QRView(groups2[position]),),);
                      ///
                      /// SnackBar show if cart delet
                      ///
                    /*  Scaffold.of(context)
                          .showSnackBar(SnackBar(content: Text("Items Cart Deleted"),duration: Duration(seconds: 2),backgroundColor: Colors.redAccent,));
                  */  },
                  ),
                ],
                child: Padding(
                  padding: const EdgeInsets.only(top: 1.0, left: 13.0, right: 13.0),
                  /// Background Constructor for card
                  child: Container(
                    height: 230.0,
                    decoration: BoxDecoration(
                      color: getGroupColor(groups2[position].admin.memberEmployeeNumber),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12.withOpacity(0.1),
                          blurRadius: 3.5,
                          spreadRadius: 0.4,
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.all(10.0),

                                /// Image item
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.1),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black12.withOpacity(0.1),
                                              blurRadius: 0.5,
                                              spreadRadius: 0.1)
                                        ]),
                                    child:CircleAvatar(backgroundImage:NetworkImage('${groups2[position].admin.memberPictureAsset}')
                                      ,radius: 50,backgroundColor: Colors.transparent,)
                                //CircleAvatar(backgroundColor: Colors.white,child: Icon(Icons.group , size: 50, color: Colors.grey,),radius: 50,)
                                )),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 25.0, left: 10.0, right: 5.0),
                                child: Column(

                                  /// Text Information Item
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(

                                          '${groups2[position].admin.memberName } ${groups2[position].admin.memberSurname}\n'
                                              '${groups2[position].admin.memberEmployeeNumber}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontFamily: "Gotik",
                                        color: Colors.black87,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Padding(padding: EdgeInsets.only(top: 10.0)),
                                    Text(
                                      '${groups2[position].groupModel.groupName}',
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                    Padding(padding: EdgeInsets.only(top: 10.0)),
                                    Text('${groups2[position].groupModel.groupDepartment}'),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 18.0, left: 0.0),
                                      child: Container(
                                        width: 112.0,
                                        decoration: BoxDecoration(
                                            color: Colors.white70,
                                            border: Border.all(
                                                color: Colors.black12.withOpacity(0.1))),

                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 8.0)),

                        Padding(
                          padding: const EdgeInsets.only(
                              top: 9.0, left: 10.0, right: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[

                              InkWell(
                                onTap:(){ Navigator.push(context, MaterialPageRoute(builder: (context)
                                => new GroupMembers(
                                    GROUP_INFORMATION(
                                        groups2[position].groupModel.groupDepartment, groups2[position].groupModel.groupName,
                                        groups2[position].admin.memberEmployeeNumber, groups2[position].GROUP_TYPE)),),);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Container(
                                    height: 40.0,
                                    width: 120.0,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "List & Requests",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: "Gotik",
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              checkGroupType(groups2[position].admin.memberEmployeeNumber, context ,groups2[position]),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),) ,);
            },
            scrollDirection: Axis.vertical,
          ): noItemCart()
      );
    }

    showProgressIndicator(BuildContext context){
      return showDialog(context: context, barrierDismissible: false, builder: (BuildContext contect){
        return Container(width: 50 , child: Column(children: <Widget>[
          SizedBox(height: MediaQuery.of(context).size.height/2,),
          CircularProgressIndicator(),

        ],),);
      });
    }

    String sendEmailinvitation(int position){
    String email= "";
     showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(

            title: Text('Enter Email Address',),
            elevation: 7.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Please enter recipient email address'),

                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok', style: TextStyle(color: Colors.black)),
                onPressed: () {


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

    /*
     if(email == ""){
                    final Email email = Email(
                      body: "${StaticValues.userName} ${StaticValues.userSurname} has invited you to joi this Plus Minu Group"
                          "\n Employee Number: ${StaticValues.employeeNumber}"
                          "\m Password ${groups2[position].GROUPPASSWORD}",
                      subject: "Invitation to Join Group",
                      recipients: email,
                      attachmentPaths: '',
                      isHTML: false,
                    );

                    String platformResponse;

                    try {
                      await FlutterEmailSender.send(email);
                      platformResponse = 'success';
                    } catch (error) {
                      platformResponse = error.toString();
                    }

                  }
     */



    getGroupsFromSQL()async{
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showProgressIndicator(context);
        startTime();
      });
    groups = await db_helper.getGroupList('GR');

    for(int i = 0; i< groups.length; i++){
      updateListView(groups[i]);
    }

    }

    Color getGroupColor(String empNumb){
    Color color = Colors.white;

    if (empNumb == StaticValues.employeeNumber){
      color = Colors.white10;
    }

    return color;
    }

    getGroupListOnline(){
      ref = FirebaseDatabase.instance.reference().child('THIS_COMPANY')
          .child('GROUPS').child(StaticValues.splitEmailForFirebase(StaticValues.employeeNumber));




      ref.onChildAdded.listen((event) {

        ref2 = FirebaseDatabase.instance.reference().child('THIS_COMPANY')
            .child('GROUPS').child(StaticValues.splitEmailForFirebase(StaticValues.employeeNumber))
        .child(event.snapshot.key);


        ref2.onChildAdded.listen((event) {

          var data = event.snapshot.value;


            BankModel bank = BankModel.fromMapObject(data['BANK_MODEL']);
            MemberModel admin = MemberModel.fromMapObjectI(data['ADMIN_MODEL']);
            GroupModel group = GroupModel.fromMapObject(data['GROUP_MODEL']);
            if (groups2.contains(
                GROUP_INFORMATION.fullGroup(group, bank, admin))) {

            } else {
              groups2.add(GROUP_INFORMATION.fullGroup(group, bank, admin));
            }

          setState(() {
            if(loop == true) {
              Navigator.pop(context);
              loop = false;
            }
          });
        });
      });

    }

    updateListView(GROUP_INFORMATION group){
      ref = FirebaseDatabase.instance.reference().child('THIS_COMPANY')
          .child('GROUPS').child(StaticValues.splitEmailForFirebase(group.GROUP_ADMIN))
          .child(group.GROUP_NAME);



      ref.onChildAdded.listen((event) {
        var data = event.snapshot.value;
        BankModel bank = BankModel.fromMapObject(data['BANK_MODEL']);
        MemberModel admin = MemberModel.fromMapObjectI(data['ADMIN_MODEL']);
        GroupModel group = GroupModel.fromMapObject(data['GROUP_MODEL']);
        if(groups2.contains(GROUP_INFORMATION.fullGroup(group, bank, admin))) {

        }else{
        groups2.add(GROUP_INFORMATION.fullGroup(group, bank, admin));
        }
      setState(() {
        if(loop == true) {
          Navigator.pop(context);
          loop = false;
        }
      });
     });}

    startTime() async {
      return new Timer(Duration(milliseconds: 4500), checkGroupList);
    }



    checkGroupList(){
      if (groups2.isEmpty){
       Navigator.pop(context);

      }
    }


  }

  getGroups(name){
  DatabaseReference ref2;
    ref2 = FirebaseDatabase.instance.reference().child('THIS_COMPANY').child('GROUPS').child(StaticValues.splitEmailForFirebase(StaticValues.employeeNumber))
        .child(name);

    ref2.onChildAdded.listen((event){
      var data = event.snapshot.value;

    });
  }


Widget checkGroupType(String employeeNumber, BuildContext context,GROUP_INFORMATION gm) {
  Widget inkwel;
  if (employeeNumber == StaticValues.employeeNumber) {
    inkwel = Column(children: <Widget>[
      Text('Available Balance:  R${double.parse(gm.bankModel.accountBalance).toStringAsFixed(2).toString()}')
    ],);
  } else {


        inkwel = InkWell(
          onTap: () {
           Navigator.push(context,
              MaterialPageRoute(builder: (context) => new RequestName(gm),),);
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Container(
              height: 40.0,
              width: 120.0,
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
              child: Center(
                child: Text(
                  "Make Request",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Gotik",
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        );

  }

  return inkwel;
}



  ///
///
/// If no item cart this class showing
///
class noItemCart extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return  Container(
      width: 500.0,
      color: Colors.white,
      height: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding:
                EdgeInsets.only(top: mediaQueryData.padding.top + 50.0)),
            Image.asset(
              "assets/imgIllustration/IlustrasiCart.png",
              height: 300.0,
            ),
            Padding(padding: EdgeInsets.only(bottom: 10.0, left: 20 , right: 20)),
            Center(child:Text(
              "No Groups Created,\nSelect 'Create Group' to get started",textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 18.5,
                  color: Colors.black26.withOpacity(0.2),
                  fontFamily: "Popins"),
            ) ,)

          ],
        ),
      ),
    );
  }
}
