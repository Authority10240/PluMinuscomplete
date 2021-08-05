import 'dart:async';

import 'package:flutter/material.dart';
import 'package:treva_shop_flutter/UI/BottomNavigationBar.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:treva_shop_flutter/UI/LoginOrSignup/UserInformation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:treva_shop_flutter/DataModels/StaticValues.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';


class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> with TickerProviderStateMixin {
  //Animation Declaration
  AnimationController sanimationController;
  AnimationController animationControllerScreen;
  Animation animationScreen;
  var tap = 0;

  /// Set AnimationController to initState
  ///

  ///Fingerprint scannners

  @override
  void initState() {
    sanimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800))
          ..addStatusListener((statuss) {
            if (statuss == AnimationStatus.dismissed) {
              setState(() {
                tap = 0;
              });
            }
          });
    // TODO: implement initState
    super.initState();
  }

  /// Dispose animationController
  @override
  void dispose() {
    super.dispose();
    sanimationController.dispose();
  }

  /// Playanimation set forward reverse
  Future<Null> _PlayAnimation() async {
    try {
      await sanimationController.forward();
      await sanimationController.reverse();
    } on TickerCanceled {}
  }
  /// Component Widget layout UI
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    mediaQueryData.devicePixelRatio;
    mediaQueryData.size.height;
    mediaQueryData.size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body:Card(color: Colors.white,
        child:  ListView(

            padding: EdgeInsets.all(0.0),
            children: <Widget>[
              Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        alignment: AlignmentDirectional.topCenter,
                        child: Column(
                          children: <Widget>[
                            /// padding logo
                            Padding(
                                padding: EdgeInsets.only(
                                    top:
                                    mediaQueryData.padding.top + 70.0)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[

                                Image(
                                  image: AssetImage("assets/img/Logo.png"),
                                  height: 150.0,
                                ),


                                Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.0)),
                                /// Animation text treva shop accept from login layout
                              ],
                            ),

                            Padding(
                                padding:
                                EdgeInsets.symmetric(vertical: 20.0)),


                            /// TextFromField Email
                            Container(padding: EdgeInsets.only(left: 25 , right: 25),child:
                            Center(child:Card(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)) ,
                                child:Column(children: [ GestureDetector(
                                child: Container(
                                  padding: EdgeInsets.only(top:20,left:20,right:20),
                                  child:Text('By "Logging In" you are accepting'
                                      ' the Conceptual Agency\'s Terms and Conditions '
                                      'and Privacy Policy for the use of the '
                                      'PlusMinus App',
                                    textAlign: TextAlign.justify,style: TextStyle(
                                    color: Colors.black26,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Gotik'),),
                                )),
                              Padding(
                                  padding:
                                  EdgeInsets.symmetric(vertical: 10.0)),
                              Center(child: GestureDetector(
                                child: Text('Terms And Conditions',style: TextStyle(
                                    color: Colors.black26,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Gotik'),),
                                onTap: (){
                                  launch("https://conceptage.co.za/index.php/terms-and-conditions/");
                                },
                              )),
                              Center(child: GestureDetector(
                                child:Text('And',style: TextStyle(
                                    color: Colors.black26,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Gotik'),),
                              )),
                              Container(padding: EdgeInsets.only(bottom: 10),child:
                              Center(child: GestureDetector(
                                child: Text('Privacy Policy',style: TextStyle(
                                    color: Colors.black26,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Gotik'),),
                                onTap: (){
                                  launch("https://conceptage.co.za/index.php/privacy-policy/");
                                },
                              )),)]))),),
                            Padding(
                                padding:
                                EdgeInsets.symmetric(vertical: 10.0)),
                            buttonCustomGoogle(),


                            Padding(
                                padding:
                                EdgeInsets.symmetric(vertical: 5.0)
                            ),

                            Padding(
                                padding:
                                EdgeInsets.symmetric(vertical: 5.0)),

                            /// google Login Button Password


                            /// Button Login

                            Padding(
                              padding: EdgeInsets.only(
                                  top: mediaQueryData.padding.top + 175.0,
                                  bottom: 0.0),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
      ),
    );
  }
}

/// textfromfield custom class
class textFromField extends StatelessWidget {
  bool password;
  String email;
  IconData icon;
  TextInputType inputType;

  textFromField({this.email, this.icon, this.inputType, this.password});

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
          child: TextFormField(
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
                    fontFamily: 'Gotik',
                    letterSpacing: 0.3,
                    color: Colors.black38,
                    fontWeight: FontWeight.w600)),
            keyboardType: inputType,
          ),
        ),
      ),
    );
  }
}

///ButtonBlack class
class buttonBlackBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(30.0),
      child: Container(
        height: 55.0,
        width: 600.0,
        child: Text(
          "Sign Up",
          style: TextStyle(
              color: Colors.white,
              letterSpacing: 0.2,
              fontFamily: "Gotik",
              fontSize: 18.0,
              fontWeight: FontWeight.w800),
        ),
        alignment: FractionalOffset.center,
        decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 15.0)],
            borderRadius: BorderRadius.circular(30.0),
            gradient: LinearGradient(
                colors: <Color>[Colors.green[900], Colors.blue[900]])),
      ),
    );
  }
}

class buttonCustomGoogle extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  List<String> names = List();
  String email ="";
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Container(
        alignment: FractionalOffset.center,
        height: 49.0,
        width: 500.0,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black, blurRadius: 10.0)],
          borderRadius: BorderRadius.circular(40.0),
        ),
        child: new GestureDetector(
          onTap: (){
           _handleSignIn(context).then((onValue){
              if (onValue.isEmailVerified){
                init(context);
                setVirginity();
              }
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "assets/img/google.png",
                height: 25.0,

              ),
              Padding(padding: EdgeInsets.symmetric(horizontal: 7.0)),
              Text(
                "Login With Google",
                style: TextStyle(
                    color: Colors.black26,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Gotik'),
              )

            ],
          ),
        ),
      ),
    );


  }

  init(BuildContext context) async{




    try {
      SharedPreferences reg = await SharedPreferences.getInstance();
      StaticValues.userName = reg.getString('NAME');
      if(StaticValues.userName == null){

          SharedPreferences reg = await SharedPreferences.getInstance();
          //get info from email sign in
          reg.setString('NAME', names[0]);
          reg.setString('SURNAME', names[1]);
          reg.setString('EMAIL', email);

          StaticValues.userName = names[0];
          StaticValues.userSurname = names[1];
          StaticValues.email = email;
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => new UserInformation()));

          // put info into

      }else {

        StaticValues.userSurname = reg.getString('SURNAME');
        StaticValues.employeeNumber = reg.getString('EMPLOYEE_NUMBER');
        StaticValues.occupation = reg.getString('OCCUPATION');
        StaticValues.Age = reg.getInt('AGE');
        StaticValues.email = reg.getString('EMAIL');
        
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => new bottomNavigationBar()));
      }
    }catch(Ex){
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => new UserInformation()));
    }
  }
  Future<FirebaseUser> _handleSignIn(BuildContext context) async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user = await _auth.signInWithCredential(credential);
    print("Signed in " + user.displayName);
    names = user.displayName.split(' ');
    email = user.email;
    return user;
  }

  setVirginity() async{
    SharedPreferences virginity = await SharedPreferences.getInstance();
    virginity.setBool('Virginity', true);
  }

}

class buttonCustomFacebook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Container(
        alignment: FractionalOffset.center,
        height: 49.0,
        width: 500.0,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(40.0),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 15.0)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/img/icon_facebook.png",
              height: 25.0,
            ),
            Padding(padding: EdgeInsets.symmetric(horizontal: 7.0)),
            Text(
              "Login With Facebook",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Gotik'),
            ),
          ],
        ),
      ),
    );
  }



}