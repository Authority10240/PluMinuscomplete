import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:treva_shop_flutter/UI/BottomNavigationBar.dart';
import 'package:treva_shop_flutter/UI/LoginOrSignup/Login.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SecurityQuestions extends StatefulWidget {
  @override
  _SecurityQuestionsState createState() => _SecurityQuestionsState();
}

class _SecurityQuestionsState extends State<SecurityQuestions> {

  @override
  String answer1 = '',
      answer2 = '',
      answer3 = '';

  Widget build(BuildContext context) {
    return Scaffold(appBar:
    AppBar(
      backgroundColor: Colors.white,),
       body: ListView(
          children: [
            Container(
                padding: EdgeInsets.all(30),
                child:Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child:  Container(padding: EdgeInsets.all(20),
                      child: Text(
                        'Enter 3 password recovery Words',
                        style: _fontTextStyle,
                        textAlign: TextAlign.center,maxLines: 5,),
                  ),)
            ),
             textFromField('First Word', Icons.title, 1),
          SizedBox(height: 10,),
          textFromField('Second Word', Icons.title, 2),
          SizedBox(height: 10,),
          textFromField('Third Word', Icons.title, 3),
          SizedBox(height: 20,),
             GestureDetector(onTap: () {
            saveRecoveryWords();
          }, child:
         Container(decoration: BoxDecoration(
              color: Colors.grey, borderRadius: BorderRadius.circular(10)),
            padding: EdgeInsets.only(bottom: 10, left: 20, right: 20, top: 10,),
            margin: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 100),
            child: Row(
              children: <Widget>[
                Icon(Icons.forward, size: 40, color: Colors.white,),
                Text('Finish   ', style: TextStyle(color: Colors.white),)
              ],
            ),),),
          ],
        ),
      );
  }

  var _fontTextStyle = TextStyle(
      fontFamily: "Gotik",
      fontSize: 15.0,
      color: Colors.black26,
      fontWeight: FontWeight.w400

  );
  var _fontDescriptionStyle = TextStyle(
      fontFamily: "Gotik",
      fontSize: 20.0,
      color: Colors.black26,
      fontWeight: FontWeight.w400

  );

  Widget textFromField(String email, IconData icon,
      int textFieldNumber) {
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
                }
              },

            ),
          ),
        ),
      );
  }

  saveRecoveryWords() async {
    SharedPreferences word = await SharedPreferences.getInstance();

    if (answer1.isEmpty || answer2.isEmpty || answer3.isEmpty) {
      Fluttertoast.showToast(
          msg: "One or more fields have been left empty, please fill in all words before attempting to continue.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.grey,
          fontSize: 16.0
      );
    } else {
      word.setString('ANSWER1', answer1);
      word.setString('ANSWER2', answer2);
      word.setString('ANSWER3', answer3);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => new bottomNavigationBar()));
    }
  }

}
