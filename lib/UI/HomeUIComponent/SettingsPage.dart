import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:treva_shop_flutter/DataModels/StaticValues.dart';
import 'package:fluttertoast/fluttertoast.dart';
class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  bool useBio = true;
  String answer1 = '' , answer2 ='' , answer3='';
  String password1 = '' , password2 = '';
  String  currentPassword ='';
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('Settings',
          style:TextStyle(color: Colors.grey),), ),
    body: ListView(
      children: [
        Card(child: Column(
        children: [ListTile(title: Text('Security', style: TextStyle(fontSize: 30, color: Colors.grey),),leading: Icon(Icons.security),),
          Card(
            child: ListTile(title: Text('Reset Password',style:TextStyle(color: Colors.grey)),onTap: (){
              resetPassword(context);
            },),),
    Card(
    child: ListTile(title: Text('Change Password',style:TextStyle(color: Colors.grey)),onTap: (){
    changePassword(context);
    },),),
    Card(
    child: ListTile(title: Text('Use biometrics:',style:TextStyle(color: Colors.grey)),trailing: Checkbox(activeColor: Colors.grey,value: StaticValues.bio,onChanged: (changeBio)=>{
    setState((){
    useBio = changeBio;
    setBioPreference(changeBio);
    }),

    },),),)],
    ),),

      ],
    ),);
  }

  setBioPreference(bool bio) async{
    SharedPreferences biopref = await SharedPreferences.getInstance();
    biopref.setBool('BIO', bio);
    StaticValues.bio = bio;

  }

  resetPassword(BuildContext context){
    String currentPassword ='', password1='' ,password2='';
    showDialog(barrierDismissible: false,context: context ,builder: (context) => new
    AlertDialog(title: Text('Reset Password'),content:Column(mainAxisSize: MainAxisSize.min,
      children: [
        textFromField('Word 1', Icons.looks_one, 1),
        textFromField('Word 2', Icons.looks_one, 2),
        textFromField('Word 3', Icons.looks_one, 3),
      ],

    ),actions: [
      FlatButton(onPressed: ()=> Navigator.pop(context), child:Text('Cancel', style: TextStyle(color: Colors.grey),)),
      FlatButton(onPressed: ()=> validateAnswers(),child:Text('Submit', style: TextStyle(color: Colors.grey))),
    ],)
    );
  }

  validateAnswers() async{
    SharedPreferences  answers = await SharedPreferences.getInstance();
    if(answer1 == StaticValues.answer1 && answer2 == StaticValues.answer2 && answer3 == StaticValues.answer3){
      Navigator.pop(context);
      setPassword(context);

    }else{
      Fluttertoast.showToast(
          msg: "Incorrect Answers",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.black,
          fontSize: 16.0
      );
    }
  }

  changePassword(BuildContext context){
    String currentPassword ='', password1='' ,password2='';
    showDialog(barrierDismissible: false,context: context ,builder: (context) => new
    AlertDialog(title: Text('Change Password'),content: Column(mainAxisSize: MainAxisSize.min,
      children: [
        textFromField('Enter Current Password', Icons.looks_one, 6),
        textFromField('Enter New Password', Icons.looks_one, 4),
        textFromField('Re-Enter New Password', Icons.looks_one, 5),
      ],

    ),actions: [
      FlatButton(onPressed: ()=> Navigator.pop(context), child:Text('Cancel', style: TextStyle(color: Colors.grey),)),
      FlatButton(onPressed: ()=> validatePasswordChange(currentPassword , password1, password2), child:Text('Change Password',style: TextStyle(color: Colors.grey))),
    ],)
    );
  }

  setPassword(BuildContext context){

    showDialog(barrierDismissible: false,context: context ,builder: (context) => new
    AlertDialog(title: Text('Set Password'),content: Column(mainAxisSize: MainAxisSize.min,
      children: [
        textFromField('Enter New Password', Icons.looks_one, 4),
        textFromField('Re-Enter New Password', Icons.looks_one, 5),

      ],

    ),actions: [
      FlatButton(onPressed: ()=> Navigator.pop(context), child:Text('Cancel', style: TextStyle(color: Colors.grey),)),
      FlatButton(onPressed: ()=> setNewPassword(), child:Text('Change Password',style: TextStyle(color: Colors.grey))),
    ],)
    );
  }



  validatePasswordChange(String currPass , String pass1 , String pass28fd)async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (currentPassword.isEmpty) {
      Fluttertoast.showToast(
          msg: "Current Password field cannot be left empty",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.black,
          fontSize: 16.0
      );
    } else if (password1.isEmpty || password2.isEmpty) {
      Fluttertoast.showToast(
          msg: "New Password fields cannot be left empty",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.black,
          fontSize: 16.0
      );
    } else {
      if (StaticValues.pin == currentPassword) {
        if (password2 == password1) {
          SharedPreferences sp = await SharedPreferences.getInstance();
          sp.setString('PIN', pass1);
          StaticValues.pin == pass1;
          Fluttertoast.showToast(
              msg: "Pin Changed Succesfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.black,
              fontSize: 16.0
          );
          Navigator.pop(context);
        } else {
          Fluttertoast.showToast(
              msg: "New Passwords do not match",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.black,
              fontSize: 16.0
          );
        }
      } else {
        Fluttertoast.showToast(
            msg: "Invalid current password",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.black,
            fontSize: 16.0
        );
      }
    }
  }

  Widget textFromField(String email, IconData icon,
      int textFieldNumber) {
    return  Padding(
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


              onChanged: (value) async {
                switch (textFieldNumber) {
                  case 1:
                    answer1 = value;
                    break;
                  case 2:
                    answer2 = value;
                    break;
                  case 3:
                    answer3 = value;
                    break;
                  case 4:
                    password1 = value;
                  break;
                  case 5 :
                    password2 = value;
                    break;
                  case 6 : currentPassword = value;
                      break;

                }
              },

            ),
          ),
        ),

    );
  }

  setNewPassword() async{
    if(password1.isEmpty|| password2.isEmpty){
      Fluttertoast.showToast(
          msg: "One or more fields have been left blank, Please fill in all fields to change password",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.black,
          fontSize: 16.0
      );
    }else if(password1!= password2){
      Fluttertoast.showToast(
          msg: "Entered Passwords do not match",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.black,
          fontSize: 16.0
      );
    }else{

      SharedPreferences pass = await SharedPreferences.getInstance();
      pass.setString('PIN', password1);
      Fluttertoast.showToast(
          msg: "Pin Changed Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.black,
          fontSize: 16.0
      );
      Navigator.pop(context);
    }
  }
}
