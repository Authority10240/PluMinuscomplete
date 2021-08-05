import 'package:flutter/material.dart';
import 'package:treva_shop_flutter/DataModels/GROUP_INFORMATION.dart';
import 'package:treva_shop_flutter/DataModels/MemberModel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:treva_shop_flutter/UI/CartUIComponent/GroupRequests.dart';
import 'package:treva_shop_flutter/DataModels/StaticValues.dart';
    
    class GroupMembers extends StatefulWidget {
      @override
      _GroupMembersState createState() => _GroupMembersState(gi);
      GROUP_INFORMATION gi;
      GroupMembers(this.gi);

    }
    
    class _GroupMembersState extends State<GroupMembers> {
      GROUP_INFORMATION gi;
      _GroupMembersState(this.gi);
      List<MemberModel> members;
      DatabaseReference ref;

      @override
      Widget build(BuildContext context) {

        if(members == null){
          members = List();
          updateListView();
        }

        return
          Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.grey,
              title: Text(gi.GROUP_NAME+': ${members.length.toString()} Member(s)', style: TextStyle(color: Colors.white) ),
              centerTitle: true,


            ),
          body:ListView.builder(

              itemCount : members.length,
              itemBuilder: (BuildContext context , int i){

        return Card(
        color: Colors.white,
        elevation: 2.0,
        child: ListTile(
        onTap: (){
        //TO DO Code Here
          if(gi.GROUP_ADMIN == StaticValues.employeeNumber)
          Navigator.push(context, MaterialPageRoute(builder: (context){
              return Group_requests(gi, members[i]);}),);
        },
        leading: CircleAvatar(
        backgroundImage: NetworkImage(members[i].memberPictureAsset), backgroundColor: Colors.white,),
        title: Text(members[i].memberName + ' ' + members[i].memberSurname, style: TextStyle(color: Colors.grey),),
        subtitle: Text(members[i].memberOccupation +' :'+ members[i].memberEmployeeNumber  , style: TextStyle(color: Colors.grey) ),
        ),
        );
        } ),);


      }

      updateListView(){
        ref = FirebaseDatabase.instance.reference().child('THIS_COMPANY')
            .child('GROUPS').child(StaticValues.splitEmailForFirebase(gi.GROUP_ADMIN)).child(gi.GROUP_NAME)
            .child(gi.DEPARTMENT).child('MEMBERS');
        ref.onChildAdded.listen((data){
          this.members.add(MemberModel.fromMapObjectI(data.snapshot.value));
          setState(() {

            });
        });
      }
    }
    