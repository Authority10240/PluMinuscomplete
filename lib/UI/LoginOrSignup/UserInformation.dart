import 'package:flutter/material.dart';
import 'package:treva_shop_flutter/DataModels/StaticValues.dart';
import 'package:treva_shop_flutter/DataModels/UserModel.dart';
import 'package:treva_shop_flutter/UI/BottomNavigationBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:treva_shop_flutter/UI/LoginOrSignup/ProfilePicture.dart';
class UserInformation extends StatefulWidget {
  @override
  _UserInformationState createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
    UserModel userModel = new UserModel.blank();
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        centerTitle: true,
        title: Text('Hi ${StaticValues.userName} ${StaticValues.userSurname}' ,style: TextStyle(
            color: Colors.white,

            fontWeight: FontWeight.w500,
            fontFamily: 'Gotik')),
        backgroundColor: Colors.grey,
      ) ,
      body: ListView(
        children: <Widget>[
          SizedBox(height: 15,),
          Center(
            child: Text('Few more things before we start',style: TextStyle(
                color: Colors.grey,
                fontSize: 25,
                fontWeight: FontWeight.w500,
                fontFamily: 'Gotik')),

          ),
          SizedBox(height: 15,),
          Center(
            child: Text('About You:',style: TextStyle(
                color: Colors.grey,
                fontSize: 25,
                fontWeight: FontWeight.w500,
                fontFamily: 'Gotik')),
          ),
          SizedBox(height: 15,),
          textFromField(icon: Icons.work,email: 'Occupation*',password: false,inputType: TextInputType.text,textFieldNumber: 4,userModel: userModel, length: 30,),
          SizedBox(height: 15,),
          textFromField(icon: Icons.confirmation_number,email: 'Age*',password: false,inputType: TextInputType.number,textFieldNumber:2,userModel: userModel , length: 3,),
          SizedBox(height: 15,),
          textFromField(icon: Icons.apps,email: 'Enter Pin*',password:true,inputType: TextInputType.number,textFieldNumber:1,userModel: userModel, length: 5),
          SizedBox(height: 15,),
          textFromField(icon: Icons.apps,email: 'Confirm Pin*',password: true,inputType: TextInputType.number,textFieldNumber:3,userModel: userModel, length : 5),
          SizedBox(height: 10,),
          Container(padding: EdgeInsets.all(25),child:FlatButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            padding: EdgeInsets.symmetric( horizontal:30.0),
            onPressed: () {
              validateFields();
            },
            child: Text(
              "Next",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.0,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Gotik"),
            ),
            color: Colors.grey,),)
         // textFromField(icon: Icons.confirmation_number,email: '',password: false,inputType: TextInputType.number,),


        ],
      ),
    );
  }

  validateFields(){

     if(userModel.iAge==0){
      Confirm(context, 'Empty Field', 'Please enter your age into the age field.');
    }
    else if(userModel.sOccupation.isEmpty){
      Confirm(context, 'Empty Field', 'Please enter your occupation into the occuptation field.');
    }else{
      ConfirmInformation(context, 'Register Details', 'Are you sure you want to register the inserted details?',userModel);

    }
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


class textFromField extends StatelessWidget {
  bool password;
  String email;
  IconData icon;
  TextInputType inputType;
  int textFieldNumber;
  UserModel userModel = new UserModel.blank();
  SharedPreferences reg ;
  int length ;


  textFromField({this.email, this.icon, this.inputType, this.password ,
    this.textFieldNumber, this.userModel, this.length});

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
              switch(textFieldNumber){
                case 0 : userModel.sName = value;
                break;
                case 1 : userModel.sEmail = value;
                break ;
                case 2 : userModel.iAge = int.parse(value);
                break;
                case 3 : userModel.sPIN = value;
                break;
                case 4 : userModel.sOccupation = value;
              }
            },

          ),
        ),
      ),
    );
  }
}

ConfirmInformation(BuildContext context, String title,
    String description, UserModel userModel) {
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
              child: Text('Yes', style: TextStyle(color: Colors.black)),
              onPressed: () {
                registerPreference(userModel);
                Navigator.pop(context);
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (
                        BuildContext context) => new ProfilePicSelector()));
              },
            ),
            FlatButton(
              child: Text('No', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),

          ],
        );
      }
  );


}

registerPreference(UserModel userModel)async{
  SharedPreferences reg = await SharedPreferences.getInstance();
  reg.setInt('AGE', userModel.iAge);
  reg.setString('OCCUPATION', userModel.sOccupation);
  reg.setString('EMPLOYEE_NUMBER',reg.getString('EMAIL'));
  reg.setString('PIN', userModel.sPIN);
  reg.setBool('BIO', true );

}